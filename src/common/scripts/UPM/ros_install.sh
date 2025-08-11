#!/bin/bash

if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
elif [ -n "$1" ]; then
    # Allow passing username as first argument
    TARGET_USER="$1"
else
    # Default to a common username or create a dedicated user
    echo "No user specified, exit..."
    exit 1
fi

source /opt/ros/noetic/setup.bash
echo "source /opt/ros/noetic/setup.bash" >> /home/$TARGET_USER/.bashrc
source /home/$TARGET_USER/.bashrc

rosdep init \
 && rosdep fix-permissions \
 && rosdep update


source /home/$TARGET_USER/.bashrc
echo "Ros installation completed successfully for user: $TARGET_USER"

echo "Configuring ROS Noetic post-installation setup..."

# Check if ROS Noetic is installed
if [ ! -f "/opt/ros/noetic/setup.bash" ]; then
    echo "Warning: ROS Noetic not found at /opt/ros/noetic/setup.bash"
    echo "ROS Noetic should be installed before this package"
    exit 0
fi

# Initialize rosdep system-wide if not already done
if [ ! -d "/etc/ros/rosdep/sources.list.d" ] || [ -z "$(ls -A /etc/ros/rosdep/sources.list.d 2>/dev/null)" ]; then
    echo "Initializing rosdep system-wide..."
    rosdep init || {
        echo "rosdep init failed, but continuing installation..."
    }
else
    echo "rosdep already initialized"
fi

# Create a system-wide ROS setup script
cat > /etc/profile.d/ros-noetic.sh << 'EOF'
# ROS Noetic Environment Setup
if [ -f "/opt/ros/noetic/setup.bash" ]; then
    source /opt/ros/noetic/setup.bash
fi
EOF

chmod 644 /etc/profile.d/ros-noetic.sh
echo "Created system-wide ROS environment setup in /etc/profile.d/ros-noetic.sh"

# Add ROS sourcing to /etc/bash.bashrc for all users
if [ -f "/etc/bash.bashrc" ]; then
    if ! grep -q "source /opt/ros/noetic/setup.bash" /etc/bash.bashrc; then
        echo "" >> /etc/bash.bashrc
        echo "# ROS Noetic Environment" >> /etc/bash.bashrc
        echo "if [ -f /opt/ros/noetic/setup.bash ]; then" >> /etc/bash.bashrc
        echo "    source /opt/ros/noetic/setup.bash" >> /etc/bash.bashrc
        echo "fi" >> /etc/bash.bashrc
        echo "Added ROS environment to /etc/bash.bashrc"
    fi
fi

# Set up ROS environment for existing users
for user_home in /home/*; do
    if [ -d "$user_home" ]; then
        username=$(basename "$user_home")
        bashrc_file="$user_home/.bashrc"

        # Skip if user doesn't exist or is a system user
        if ! getent passwd "$username" > /dev/null || [ "$(id -u "$username")" -lt 1000 ]; then
            continue
        fi

        # Add ROS sourcing to user's .bashrc if it exists and doesn't already have it
        if [ -f "$bashrc_file" ]; then
            if ! grep -q "source /opt/ros/noetic/setup.bash" "$bashrc_file"; then
                echo "" >> "$bashrc_file"
                echo "# ROS Noetic Environment" >> "$bashrc_file"
                echo "source /opt/ros/noetic/setup.bash" >> "$bashrc_file"
                chown "$username:$username" "$bashrc_file"
                echo "Added ROS environment to $bashrc_file"
            fi
        fi
    fi
done

# Update rosdep for users (run in background to avoid blocking installation)
(
    for user_home in /home/*; do
        if [ -d "$user_home" ]; then
            username=$(basename "$user_home")

            # Skip if user doesn't exist or is a system user
            if ! getent passwd "$username" > /dev/null || [ "$(id -u "$username")" -lt 1000 ]; then
                continue
            fi

            echo "Updating rosdep for user: $username"
            sudo -u "$username" bash -c "
                export HOME='$user_home'
                source /opt/ros/noetic/setup.bash 2>/dev/null || true
                rosdep update 2>/dev/null || true
            " &
        fi
    done
    wait
) &

echo "ROS Noetic post-installation setup completed"
echo "Users will have ROS environment available in new terminal sessions"