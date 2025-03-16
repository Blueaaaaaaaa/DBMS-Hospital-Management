#!/bin/bash

echo "Oracle Instant Client Installation Script"
echo "========================================"
echo "This script will help you install Oracle Instant Client, required for cx_Oracle."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
else
    echo "Cannot detect OS. Please install Oracle Instant Client manually."
    exit 1
fi

echo "Detected OS: $OS $VER"

# Install Oracle Instant Client based on OS
case "$OS" in
    "Ubuntu" | "Debian GNU/Linux" | "Debian")
        echo "Installing Oracle Instant Client for Ubuntu/Debian..."
        apt-get update
        apt-get install -y libaio1
        
        # Download and extract Oracle Instant Client Basic
        echo "Downloading Oracle Instant Client..."
        TEMP_DIR=$(mktemp -d)
        cd $TEMP_DIR
        
        echo "Please go to https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html"
        echo "Download the 'Basic Package' ZIP file and place it in your Downloads folder."
        echo "Press Enter once you've downloaded the file."
        read -p ""
        
        # Check if file exists in Downloads
        ORACLE_ZIP=$(find /home/*/Downloads -name "instantclient-basic-linux.x64-*.zip" -type f | head -1)
        
        if [ -z "$ORACLE_ZIP" ]; then
            echo "Oracle Instant Client ZIP file not found in Downloads folder."
            echo "Please download it manually and follow the cx_Oracle installation instructions."
            exit 1
        fi
        
        # Extract and install
        echo "Installing Oracle Instant Client from $ORACLE_ZIP..."
        mkdir -p /opt/oracle
        unzip -q "$ORACLE_ZIP" -d /opt/oracle
        ORACLE_DIR=$(find /opt/oracle -type d -name "instantclient_*" | head -1)
        
        # Create symlinks
        echo "Setting up symlinks..."
        ln -sf $ORACLE_DIR/libclntsh.so.* $ORACLE_DIR/libclntsh.so
        ln -sf $ORACLE_DIR/libocci.so.* $ORACLE_DIR/libocci.so
        
        # Configure ldconfig
        echo "$ORACLE_DIR" > /etc/ld.so.conf.d/oracle-instantclient.conf
        ldconfig
        
        # Set environment variables
        echo "export LD_LIBRARY_PATH=$ORACLE_DIR:\$LD_LIBRARY_PATH" > /etc/profile.d/oracle-instantclient.sh
        chmod +x /etc/profile.d/oracle-instantclient.sh
        ;;
        
    "CentOS Linux" | "Red Hat Enterprise Linux" | "Fedora")
        echo "Installing Oracle Instant Client for CentOS/RHEL/Fedora..."
        yum install -y libaio
        
        # Same as above for downloads
        echo "Please go to https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html"
        echo "Download the 'Basic Package' RPM file and place it in your Downloads folder."
        echo "Press Enter once you've downloaded the file."
        read -p ""
        
        # Check if file exists in Downloads
        ORACLE_RPM=$(find /home/*/Downloads -name "oracle-instantclient*-basic-*.rpm" -type f | head -1)
        
        if [ -z "$ORACLE_RPM" ]; then
            echo "Oracle Instant Client RPM file not found in Downloads folder."
            echo "Please download it manually and follow the cx_Oracle installation instructions."
            exit 1
        fi
        
        # Install RPM
        rpm -Uvh "$ORACLE_RPM"
        ;;
        
    *)
        echo "Your OS ($OS) is not directly supported by this script."
        echo "Please install Oracle Instant Client manually following instructions at:"
        echo "https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html"
        exit 1
        ;;
esac

echo ""
echo "Oracle Instant Client installation completed."
echo "You may need to restart your shell session or run 'source /etc/profile.d/oracle-instantclient.sh'"
echo "to update your environment variables." 