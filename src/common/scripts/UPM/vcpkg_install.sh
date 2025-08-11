#!/bin/bash

# vcpkg installation script for .deb package postinst
# Uses CMake 3.24.1 and installs vcpkg with common packages

set -e  # Exit on any error

# Logging function for package installation context
log_info() {
    echo "vcpkg-installer: $1" >&2
}

log_error() {
    echo "vcpkg-installer: ERROR: $1" >&2
}

# Check if running as root (postinst runs as root)
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (should be automatic in postinst)"
    exit 1
fi

log_info "Installing vcpkg with CMake 3.24.1..."

# Install system dependencies (equivalent to linux-headers)
#log_info "Installing system development headers..."
#apt-get update -qq
#apt-get install -y \
#    linux-libc-dev \
#    libc6-dev \
#    build-essential \
#    pkg-config \
#    curl \
#    zip \
#    unzip \
#    tar \
#    git || {
#    log_error "Failed to install system dependencies"
#    exit 1
#}

# Define paths
CMAKE_324_PATH="/opt/cmake-3.24.1/bin"
CMAKE_BINARY="$CMAKE_324_PATH/cmake"

# Verify CMake 3.24.1 is available
if [ ! -f "$CMAKE_BINARY" ]; then
    log_error "CMake 3.24.1 not found at $CMAKE_BINARY"
    log_error "Please ensure cmake-3.24.1 package is installed first"
    exit 1
fi

# Verify CMake version
CMAKE_VERSION=$($CMAKE_BINARY --version | head -n1 | cut -d' ' -f3)
if [ "$CMAKE_VERSION" != "3.24.1" ]; then
    log_error "Expected CMake 3.24.1, found $CMAKE_VERSION at $CMAKE_BINARY"
    exit 1
fi

log_info "Verified CMake 3.24.1 at $CMAKE_BINARY"

# Set up environment to use correct CMake
export PATH="$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin"
export CMAKE_PROGRAM="$CMAKE_BINARY"
export VCPKG_FORCE_SYSTEM_BINARIES=1

# Verify cmake command points to correct version
CURRENT_CMAKE=$(which cmake)
CURRENT_CMAKE_VERSION=$(cmake --version | head -n1 | cut -d' ' -f3)
log_info "Using cmake from: $CURRENT_CMAKE (version: $CURRENT_CMAKE_VERSION)"

if [ "$CURRENT_CMAKE_VERSION" != "3.24.1" ]; then
    log_error "cmake command is still pointing to version $CURRENT_CMAKE_VERSION"
    log_error "Expected version 3.24.1. Check your cmake installation."
    exit 1
fi

# Get the username (since we're running as root, we need to get the actual user)
# First try to get the user who invoked sudo, then fallback to specific user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
elif [ -n "$1" ]; then
    # Allow passing username as first argument
    TARGET_USER="$1"
else
    # Default to a common username or create a dedicated user
    TARGET_USER="vcpkg"
    if ! id "$TARGET_USER" >/dev/null 2>&1; then
        log_info "Creating vcpkg user..."
        useradd -m -s /bin/bash "$TARGET_USER"
    fi
fi

log_info "Installing vcpkg for user: $TARGET_USER"

# Get user's home directory
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
VCPKG_DIR="$USER_HOME/vcpkg"

log_info "Installing vcpkg to: $VCPKG_DIR"

# Remove existing vcpkg installation if it exists
if [ -d "$VCPKG_DIR" ]; then
    log_info "Removing existing vcpkg installation..."
    rm -rf "$VCPKG_DIR"
fi

# Clone vcpkg with specific version
log_info "Cloning vcpkg version 2023.02.24..."
sudo -u "$TARGET_USER" git clone --depth 1 --branch 2023.02.24 https://github.com/Microsoft/vcpkg.git "$VCPKG_DIR"

# Change to vcpkg directory
cd "$VCPKG_DIR"

# Bootstrap vcpkg with correct CMake
log_info "Bootstrapping vcpkg..."
sudo -u "$TARGET_USER" bash -c "
    export PATH='$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin'
    export CMAKE_PROGRAM='$CMAKE_BINARY'
    export VCPKG_FORCE_SYSTEM_BINARIES=1
    cd '$VCPKG_DIR'
    ./bootstrap-vcpkg.sh -disableMetrics
"

# Verify vcpkg bootstrap was successful
if [ ! -f "$VCPKG_DIR/vcpkg" ]; then
    log_error "vcpkg bootstrap failed"
    exit 1
fi

# Test vcpkg and check cmake version it's using
log_info "Verifying vcpkg cmake detection..."
VCPKG_CMAKE_INFO=$(sudo -u "$TARGET_USER" bash -c "
    export PATH='$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin'
    export CMAKE_PROGRAM='$CMAKE_BINARY'
    export VCPKG_FORCE_SYSTEM_BINARIES=1
    cd '$VCPKG_DIR'
    ./vcpkg version 2>/dev/null | grep -i cmake || echo 'CMake info not found'
")

log_info "vcpkg cmake info: $VCPKG_CMAKE_INFO"

# Install common packages
log_info "Installing vcpkg packages..."
log_info "Note: linux-headers is not a vcpkg port - system headers installed via apt instead"

# Define packages to install
# Note: linux-headers is not a vcpkg port - system headers should be installed via apt
PACKAGES=(
    "cpr"
    "rapidjson"
    "boost-context"
    "boost-filesystem"
    "boost-system"
)

# Install each package
for package in "${PACKAGES[@]}"; do
    log_info "Installing package: $package"
    sudo -u "$TARGET_USER" bash -c "
        export PATH='$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin'
        export CMAKE_PROGRAM='$CMAKE_BINARY'
        export VCPKG_FORCE_SYSTEM_BINARIES=1
        cd '$VCPKG_DIR'
        ./vcpkg install '$package' --recurse
    " || {
        log_error "Failed to install package: $package"
        exit 1
    }
done

# Create convenience scripts
log_info "Creating convenience scripts..."

# Create vcpkg wrapper script
cat > "$VCPKG_DIR/vcpkg-env.sh" << EOF
#!/bin/bash
# Environment setup for vcpkg with CMake 3.24.1
export PATH="$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin"
export CMAKE_PROGRAM="$CMAKE_BINARY"
export VCPKG_FORCE_SYSTEM_BINARIES=1
export VCPKG_ROOT="$VCPKG_DIR"
EOF

chmod +x "$VCPKG_DIR/vcpkg-env.sh"
chown "$TARGET_USER:$TARGET_USER" "$VCPKG_DIR/vcpkg-env.sh"

# Create system-wide vcpkg command
cat > /usr/local/bin/vcpkg << EOF
#!/bin/bash
# System-wide vcpkg wrapper with CMake 3.24.1
export PATH="$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin"
export CMAKE_PROGRAM="$CMAKE_BINARY"
export VCPKG_FORCE_SYSTEM_BINARIES=1
cd "$VCPKG_DIR"
exec sudo -u "$TARGET_USER" ./vcpkg "\$@"
EOF

chmod +x /usr/local/bin/vcpkg

# Add vcpkg environment to user's profile
if [ -f "$USER_HOME/.bashrc" ]; then
    if ! grep -q "vcpkg-env.sh" "$USER_HOME/.bashrc"; then
        echo "" >> "$USER_HOME/.bashrc"
        echo "# vcpkg environment with CMake 3.24.1" >> "$USER_HOME/.bashrc"
        echo "if [ -f \"$VCPKG_DIR/vcpkg-env.sh\" ]; then" >> "$USER_HOME/.bashrc"
        echo "    source \"$VCPKG_DIR/vcpkg-env.sh\"" >> "$USER_HOME/.bashrc"
        echo "fi" >> "$USER_HOME/.bashrc"
        chown "$TARGET_USER:$TARGET_USER" "$USER_HOME/.bashrc"
    fi
fi

# Set proper ownership
chown -R "$TARGET_USER:$TARGET_USER" "$VCPKG_DIR"

# Create installation tracking file
#cat > "/var/lib/vcpkg.install" << EOF
## vcpkg installation tracking
#VCPKG_DIR=$VCPKG_DIR
#TARGET_USER=$TARGET_USER
#USER_HOME=$USER_HOME
#CMAKE_BINARY=$CMAKE_BINARY
#CMAKE_VERSION=$CMAKE_VERSION
#VCPKG_VERSION=2023.02.24
#INSTALLED_PACKAGES=${PACKAGES[*]}
#INSTALL_DATE=$(date)
#EOF

# Final verification
log_info "Final verification..."
FINAL_TEST=$(sudo -u "$TARGET_USER" bash -c "
    export PATH='$CMAKE_324_PATH:/usr/local/bin:/usr/bin:/bin'
    export CMAKE_PROGRAM='$CMAKE_BINARY'
    export VCPKG_FORCE_SYSTEM_BINARIES=1
    cd '$VCPKG_DIR'
    ./vcpkg list | wc -l
" 2>/dev/null || echo "0")

log_info "vcpkg installation complete!"
log_info "Installed $FINAL_TEST packages"
log_info "User: $TARGET_USER"
log_info "Location: $VCPKG_DIR"
log_info "Using CMake: $CMAKE_VERSION"
log_info "System command: vcpkg (available globally)"
log_info "User environment: source $VCPKG_DIR/vcpkg-env.sh"
log_info ""
log_info "Note: System headers (linux-libc-dev) installed via apt instead of vcpkg"
log_info "To see available vcpkg packages: vcpkg search"
log_info "Common useful packages: fmt, spdlog, nlohmann-json, openssl, zlib"