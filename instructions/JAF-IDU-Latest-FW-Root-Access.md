# JAF-IDU-Latest-FW-Root-Access

_Disclaimer: This is ONLY for educational purposes, No one is responsible for any type of damage. So be aware._


> [!IMPORTANT]
> **Firmware Compatibility:** This method works on firmware versions `R.2.0.19.5` to `R.3.2.3`. On versions newer than `R.3.2.3`, compatibility varies by model. For firmware versions older than `R.2.0.19.5`, use [breeze.sh](https://github.com/JFC-Group/AF-Customisation/blob/main/scripts/breeze.sh) instead.

**Step 1: Reset the Device**

Reset the device using either of the following methods:

- **Via Web UI:** Go to **Maintenance → Factory Defaults / Reboot → Restore to Factory Defaults**, then click the **Defaults** button.
- **Via Physical Reset Button:** Press the device's physical Reset button.

### Step 2: Login to the Web UI

1. Open your browser and navigate to **http://192.168.31.1**.
2. Enter the default login credentials:
   - **Username:** `admin`
   - **Password:** `Jiocentrum`
3. Click **Login**.

### Step 3: Update Passwords on First Login

1. After logging in with the default credentials, the **Update Passwords** page will appear automatically.
2. Enter the new password in the **Admin Password** field: `[Aa1$(passwd${IFS}-d${IFS}root)]`
3. Enter the same password in **Confirm Admin Password**: `[Aa1$(passwd${IFS}-d${IFS}root)]`
4. Enter the guest password in the **Guest Password** field: `[(e.g., Guest123).]`
5. Enter the same password in **Confirm Guest Password**: `[(e.g., Guest123).]`
6. Click **UPDATE** to save the new passwords.
7. After the passwords have been updated successfully, log in again using the following credentials:
   - **Username:** `admin`
   - **Password:** `[Aa1$(passwd${IFS}-d${IFS}root)]`
8. Click **LOGIN** to access the Web UI.

### Step 4: Change Password via User Management

1. In the Web UI, navigate to **Administration → User Management**.
2. Locate the `admin` user account.
3. Click the **Change Password** option under the Actions section.
4. Enter the new password in the **Password** field: `[Cc2$(killall${IFS}dropbear)]`
5. Enter the same password in the **Confirm Password** field: `[Cc2$(killall${IFS}dropbear)]`
6. Click **SAVE** to apply the changes.

### Step 5: Login with the Updated Admin Password

1. Open the Web UI at **http://192.168.31.1**.
2. Enter the following credentials:
   - **Username:** `admin`
   - **Password:** `[Cc2$(killall${IFS}dropbear)]`
3. Click **LOGIN** to access the Web UI.

### Step 6: Change the Admin Password Again

1. Navigate to **Administration → User Management** in the Web UI.
2. Locate the `admin` user account.
3. Click **Change Password** under the Actions section.
4. Enter the new password in the **Password** field: `Dd3$(dropbear${IFS}-B)`
5. Enter the same password in the **Confirm Password** field: `Dd3$(dropbear${IFS}-B)`
6. Click **SAVE** to apply the changes.

### Step 7: Connect to the Router via SSH

1. Open **Command Prompt (CMD)** on your PC.
2. Enter the following command:

   ```bash
   ssh root@192.168.31.1
   ```

3. Press **Enter**.

**VOILA!** SSH access is ready.

### Step 8: Enable Persistent SSH Access and Set the Root Password

1. After gaining SSH access, open `vi /etc/rc.local` in a editor.
2. Add the following command **before the `exit 0` line**:

   ```sh
   dropbear -p 0.0.0.0:22
   ```

3. Save the file.
4. Run the following command to set the root password:

   ```sh
   passwd
   ```

5. Enter your new root password and confirm it when prompted.


