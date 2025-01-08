#!/bin/bash

# Usage: ./breeze.sh <encrypted_file>

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage instructions
usage() {
  echo "Usage: $0 <encrypted_file>"
  echo "Example: $0 backup.enc"
  exit 1
}

# Function to check the success of the last executed command
check_success() {
  if [ "$?" -ne 0 ]; then
    echo "Error: $1 failed."
    exit 1
  fi
}

# Check if OpenSSL version is 1.1.1(x) where x is optional
check_openssl_version() {
  openssl_version=$(openssl version | awk '{print $2}')
  if [[ ! "$openssl_version" =~ ^1\.1\.1([[:alnum:]]*)$ ]]; then
    echo "Error: OpenSSL version must be 1.1.1 or 1.1.1(x), but found version $openssl_version."
    exit 1
  fi
}

# Step 0: Check OpenSSL version
check_openssl_version

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Error: Incorrect number of arguments."
  usage
fi

# Assign command-line arguments to variables
ENCRYPTED_FILE="$1"
DECRYPTED_FILE="dec_backup_og.tar.gz"

# Check if the encrypted file exists
if [ ! -f "$ENCRYPTED_FILE" ]; then
  echo "Error: Encrypted file '$ENCRYPTED_FILE' does not exist."
  exit 1
fi

# Check for required tools
REQUIRED_TOOLS=("openssl" "tar" "gunzip")
for tool in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    echo "Error: '$tool' is not installed. Please install it before running this script."
    exit 1
  fi
done

# Step 1: Decrypt the configuration backup
echo "Step 1: Decrypting the configuration backup..."
openssl enc -pbkdf2 -in "$ENCRYPTED_FILE" -out "$DECRYPTED_FILE" -d -aes256 -k "/etc/server.key" || {
  echo "Warning: Failed to decrypt the backup. The key may be invalid."
  exit 1
}
check_success "Decryption"

# Step 2: Extract the decrypted backup
echo "Step 2: Extracting the decrypted backup..."
EXTRACT_DIR="extracted_backup"
mkdir -p "$EXTRACT_DIR"
tar -xzvf "$DECRYPTED_FILE" -C "$EXTRACT_DIR"
check_success "Extraction"

# Step 3: Modify the necessary files in the backup
SHADOW_FILE="$EXTRACT_DIR/etc/shadow"
MWAN_FILE="$EXTRACT_DIR/etc/mwan3.user"

# Ensure the shadow file exists
if [ ! -f "$SHADOW_FILE" ]; then
  echo "Error: Shadow file '$SHADOW_FILE' does not exist in the backup."
  exit 1
fi

# Generate a new root password hash
read -sp "Enter desired root password: " ROOT_PASSWORD
echo
read -sp "Enter salt for password hashing: " SALT
echo

if [ -z "$ROOT_PASSWORD" ] || [ -z "$SALT" ]; then
  echo "Error: Password and salt cannot be empty."
  exit 1
fi

NEW_PASSWORD_HASH=$(openssl passwd -1 -salt "$SALT" "$ROOT_PASSWORD")

# Backup the original shadow file
cp "$SHADOW_FILE" "${SHADOW_FILE}.bak"

# Update the root password hash in the shadow file
echo "Step 3: Setting new root password hash..."

# check if macos
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s|^root:[^:]*:|root:${NEW_PASSWORD_HASH}:|" "$SHADOW_FILE"
else
  sed -i "s|^root:[^:]*:|root:${NEW_PASSWORD_HASH}:|" "$SHADOW_FILE"
fi
check_success "Updating root password hash"

# Ensure the mwan3.user file exists, or prompt for alternative methods
if [ ! -f "$MWAN_FILE" ]; then
  echo "Warning: mwan3.user file '$MWAN_FILE' does not exist in the backup."
  read -p "Would you like to use an alternative method (e.g., /etc/firewall.user)? (y/n): " ALTERNATE_METHOD
  if [[ "$ALTERNATE_METHOD" =~ ^[Yy]$ ]]; then
    FIREWALL_FILE="$EXTRACT_DIR/etc/firewall.user"
    mkdir -p "$(dirname "$FIREWALL_FILE")"
    echo 'dropbear -p 0.0.0.0:22' > "$FIREWALL_FILE"
    echo "Step 4 (Alternative): Configuring /etc/firewall.user to start dropbear..."
    check_success "Creating firewall.user for dropbear"
    echo "Note: After gaining SSH access, it is recommended to move the configuration to /etc/rc.local:"
    echo "      Add 'dropbear -p 0.0.0.0:22' before the 'exit 0' line in /etc/rc.local."
    echo "      Delete /etc/firewall.user after SSH setup to avoid unnecessary configurations."
  else
    echo "Error: mwan3.user is not found, and no alternative method selected. Exiting..."
    exit 1
  fi
else
  # Append dropbear command to mwan3.user
  echo "Step 4: Configuring mwan3.user to start dropbear on Dual WAN activation..."
  echo 'dropbear -p 0.0.0.0:22' >> "$MWAN_FILE"
  check_success "Configuring dropbear in mwan3.user"
fi

# Step 5: Repackage the modified backup
echo "Step 5: Repackaging the modified backup..."
MODIFIED_TAR="backup_mod.tar.gz"
tar -czvf "$MODIFIED_TAR" -C "$EXTRACT_DIR" .
check_success "Repackaging"

# Step 6: Re-encrypt the modified backup
echo "Step 6: Re-encrypting the modified backup..."
openssl enc -pbkdf2 -in "$MODIFIED_TAR" -out "encrypted_backup_mod.tar.gz" -e -aes256 -k "/etc/server.key"
check_success "Re-encryption"

# Step 7: Cleanup temporary files
echo "Step 7: Cleaning up temporary files..."
rm -rf "$DECRYPTED_FILE" "$EXTRACT_DIR" "$MODIFIED_TAR"
check_success "Cleanup"

# Final Instructions
echo "========================================"
echo "The modified and re-encrypted backup is ready as 'encrypted_backup_mod.tar.gz'."
echo "Follow these steps to restore and gain root access:"
echo "1. Upload 'encrypted_backup_mod.tar.gz' using the device's backup restore feature."
echo "2. Navigate to https://192.168.31.1/#/WAN/DualWan and enable Dual WAN."
echo "   This will reboot the device and enable SSH access."
echo "   If /etc/firewall.user was created, it will also start Dropbear on port 22."
echo "3. After gaining SSH access, to make it persistent:"
echo "   a. Add 'dropbear -p 0.0.0.0:22' to '/etc/rc.local' before the 'exit 0' line."
echo "   b. Delete '/etc/firewall.user' if it was used for SSH access."
echo "4. Disable Dual WAN as it may not function correctly and could cause issues."
echo "========================================"
echo "All steps completed successfully!"
