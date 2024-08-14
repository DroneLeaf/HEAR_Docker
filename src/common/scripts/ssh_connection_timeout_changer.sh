#!/bin/bash



sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}



# Path to SSH configuration file
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup the current SSH configuration file
cp $SSHD_CONFIG $SSHD_CONFIG.bak

# Function to modify or add a configuration directive
modify_sshd_config() {
    local directive="$1"
    local value="$2"
    
    # Check if the directive already exists in the file
    if grep -q "^${directive}" $SSHD_CONFIG; then
        # Replace the existing directive with the new value
        sed -i "s/^${directive}.*/${directive} ${value}/" $SSHD_CONFIG
    else
        # Append the directive to the end of the file
        echo "${directive} ${value}" >> $SSHD_CONFIG
    fi
}

# Set the desired timeout values
modify_sshd_config "ClientAliveInterval" "300000"    # 300 seconds (5 minutes)
modify_sshd_config "ClientAliveCountMax" "3"      # 3 intervals before disconnecting

# Restart the SSH service to apply changes
systemctl restart sshd

echo "SSH server connection timeout has been increased."
