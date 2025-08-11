#!/bin/bash

# CMake 3.24.1 installation script for .deb package postinst
# Supports both x86_64 (AMD64) and aarch64 (ARM64) architectures
# Designed to run within debian package postinst context

set -e  # Exit on any error

# Logging function for package installation context
log_info() {
    echo "cmake-installer: $1" >&2
}

log_error() {
    echo "cmake-installer: ERROR: $1" >&2
}

# Check if we're running as root (postinst always runs as root)
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (should be automatic in postinst)"
    exit 1
fi

log_info "Installing CMake 3.24.1..."

# Detect system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        CMAKE_ARCH="linux-x86_64"
        ;;
    aarch64|arm64)
        CMAKE_ARCH="linux-aarch64"
        ;;
    *)
        log_error "Unsupported architecture: $ARCH"
        log_error "This package supports x86_64 (AMD64) and aarch64 (ARM64) only"
        exit 1
        ;;
esac

log_info "Detected architecture: $ARCH (using $CMAKE_ARCH)"

# Variables
CMAKE_VERSION="3.24.1"
CMAKE_BUILD="cmake-${CMAKE_VERSION}-${CMAKE_ARCH}"
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_BUILD}.tar.gz"
INSTALL_DIR="/opt/cmake-${CMAKE_VERSION}"
TEMP_DIR="/tmp/cmake-install-$$"  # Use PID to avoid conflicts

# Cleanup function
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Set up cleanup on exit
trap cleanup EXIT

# Check for required tools
for tool in wget tar; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        log_error "Required tool '$tool' not found. Please install it first."
        exit 1
    fi
done

# Check internet connectivity
if ! wget -q --spider --timeout=10 "https://github.com" 2>/dev/null; then
    log_error "No internet connection available. Cannot download CMake."
    exit 1
fi

# Create temporary directory
log_info "Creating temporary directory..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download CMake with retry logic
log_info "Downloading CMake ${CMAKE_VERSION}..."
DOWNLOAD_RETRIES=3
for i in $(seq 1 $DOWNLOAD_RETRIES); do
    if wget -q --timeout=30 --tries=3 "$CMAKE_URL"; then
        break
    elif [ $i -eq $DOWNLOAD_RETRIES ]; then
        log_error "Failed to download CMake after $DOWNLOAD_RETRIES attempts"
        exit 1
    else
        log_info "Download attempt $i failed, retrying..."
        sleep 2
    fi
done

# Verify download
if [ ! -f "${CMAKE_BUILD}.tar.gz" ]; then
    log_error "Download failed - file not found"
    exit 1
fi

# Check file size (should be at least 40MB)
FILE_SIZE=$(stat -c%s "${CMAKE_BUILD}.tar.gz" 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -lt 40000000 ]; then
    log_error "Downloaded file seems corrupted (size: $FILE_SIZE bytes)"
    exit 1
fi

# Extract the archive
log_info "Extracting CMake..."
if ! tar -xzf "${CMAKE_BUILD}.tar.gz"; then
    log_error "Failed to extract CMake archive"
    exit 1
fi

# Verify extraction
if [ ! -d "$CMAKE_BUILD" ]; then
    log_error "Extraction failed - directory not found"
    exit 1
fi

# Remove existing CMake installation if it exists
if [ -d "$INSTALL_DIR" ]; then
    log_info "Removing existing CMake installation..."
    rm -rf "$INSTALL_DIR"
fi

# Move to installation directory
log_info "Installing CMake to ${INSTALL_DIR}..."
mv "$CMAKE_BUILD" "$INSTALL_DIR"

# Verify installation directory
if [ ! -d "$INSTALL_DIR" ] || [ ! -f "$INSTALL_DIR/bin/cmake" ]; then
    log_error "Installation failed - CMake binary not found"
    exit 1
fi

# Create symbolic links in /usr/local/bin
log_info "Creating symbolic links..."
mkdir -p /usr/local/bin

# Create links with error checking
for binary in cmake ccmake cpack ctest; do
    if [ -f "${INSTALL_DIR}/bin/${binary}" ]; then
        ln -sf "${INSTALL_DIR}/bin/${binary}" "/usr/local/bin/${binary}"
    else
        log_info "Warning: ${binary} not found in CMake installation"
    fi
done

# Update PATH for current session (mainly for verification)
export PATH="/usr/local/bin:$PATH"

# Verify installation
log_info "Verifying installation..."
if command -v cmake >/dev/null 2>&1; then
    CMAKE_INSTALLED_VERSION=$(cmake --version 2>/dev/null | head -n1 | cut -d' ' -f3 || echo "unknown")
    if [ "$CMAKE_INSTALLED_VERSION" = "$CMAKE_VERSION" ]; then
        log_info "CMake ${CMAKE_VERSION} installed successfully for ${CMAKE_ARCH}"
        log_info "Installation location: ${INSTALL_DIR}"
        log_info "Symbolic links created in: /usr/local/bin"
    else
        log_error "Version mismatch. Expected ${CMAKE_VERSION}, got ${CMAKE_INSTALLED_VERSION}"
        exit 1
    fi
else
    log_error "CMake installation failed - command not found"
    exit 1
fi

## Create a file to track this installation for potential removal
#cat > "/var/lib/cmake-${CMAKE_VERSION}.install" << EOF
## CMake installation tracking file
#INSTALL_DIR=${INSTALL_DIR}
#CMAKE_VERSION=${CMAKE_VERSION}
#CMAKE_ARCH=${CMAKE_ARCH}
#INSTALL_DATE=$(date)
#SYMLINKS=/usr/local/bin/cmake,/usr/local/bin/ccmake,/usr/local/bin/cpack,/usr/local/bin/ctest
#EOF

log_info "Installation complete. CMake ${CMAKE_VERSION} is now available system-wide."

# Note: cleanup() will be called automatically due to trap