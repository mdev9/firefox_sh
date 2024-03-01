#!/bin/sh

# Remove the Firefox profile directory
rm -rf ~/.var/app/org.mozilla.firefox/


# Check if Firefox is installed and launch it
(flatpak run org.mozilla.firefox) || { echo "Firefox not installed"; exit 1; }

wait

# Modify Firefox preferences
profile_dir=$(find ~/.var/app/org.mozilla.firefox/.mozilla/firefox/ -maxdepth 1 -type d -name '*.default-release')
if [ -n "$profile_dir" ]; then
    # Set enabled addons
    echo 'user_pref("extensions.enabledAddons", "{\"darkreader@darkreader.org\":\"4.9.77\",\"ublockorigin@raymondhill.net\":\"1.56.0\",\"lastpass@lastpass.com\":\"4.126.0.1\",\"cobalt@quicksaver\":null}");' >> "$profile_dir/prefs.js"
    # Set homepage
    echo 'user_pref("browser.startup.homepage", "intra.42.fr");' >> "$profile_dir/prefs.js"
else
    echo "Failed to find Firefox profile directory"
fi

~/.local/bin/InstallFirefoxAddon.py -f "darkreader"
~/.local/bin/InstallFirefoxAddon.py -f "ublockorigin"
~/.local/bin/InstallFirefoxAddon.py -f "lastpass"
~/.local/bin/InstallFirefoxAddon.py -f "cobalt"

