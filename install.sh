#!/bin/bash

# Remove the Firefox profile directory

pkill firefox
wait
rm -rf ~/.var/app/org.mozilla.firefox/

#mkdir /home/.var/app/org.mozilla.firefox/.mozilla/firefox/profile1.default-release
#profile_dir=$(/home/.var/app/org.mozilla.firefox/.mozilla/firefox/profile1.default-release)
#flatpak run org.mozilla.firefox -CreateProfile "profile1 profile_dir"

flatpak install org.mozilla.firefox 1>/dev/null 2>/dev/null
flatpak run org.mozilla.firefox 1>/dev/null 2>/dev/null &
sleep 5
flatpak kill org.mozilla.firefox

# Modify Firefox preferences
profile_dir=$(find ~/.var/app/org.mozilla.firefox/.mozilla/firefox/ -maxdepth 1 -type d -name '*.default-release')
if [ -n "$profile_dir" ]; then
	#Disable Password Saving
    echo 'user_pref("signon.rememberSignons", false);' >> "$profile_dir/prefs.js"
    # Set enabled addons
    echo 'user_pref("extensions.enabledAddons", "{\"darkreader@darkreader.org\":\"4.9.77\",\"ublockorigin@raymondhill.net\":\"1.56.0\",\"lastpass@lastpass.com\":\"4.126.0.1\",\"cobalt@quicksaver\":null}");' >> "$profile_dir/prefs.js"
    # Set homepage
	echo 'user_pref("browser.startup.homepage", "intra.42.fr");' >> "$profile_dir/prefs.js"
	# Add or modify the preference in the prefs.js file
	echo 'user_pref("browser.toolbars.bookmarks.visibility", "never");' >> "$profile_dir/prefs.js"
	# Add or modify the preference in the prefs.js file
	echo 'user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);' >> "$profile_dir/prefs.js"
	# Disable session restore after crash
	echo 'user_pref("browser.sessionstore.resume_from_crash", false);' >> "$profile_dir/prefs.js"
	# Hide the "View" button in the toolbar
    echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$profile_dir/prefs.js"
    echo 'user_pref("browser.uiCustomization.state", "{\"toolbar\":\"visible\",\"menubar\":\"visible\",\"location\":\"visible\",\"personal-bookmarks\":\"visible\",\"toolbar-customize\":{\"placements\":{\"viewButton\":\"-1\"}},\"inFullscreen\":\"auto\",\"sidebar\":{\"position\":\"right\"},\"responsiveUI\":\"auto\",\"onboarding\":{\"panels\":\"0\",\"version\":\"2020.01.01\"}}");' >> "$profile_dir/prefs.js"
else
    echo "Failed to find Firefox profile directory"
fi


~/.local/bin/firefox_sh/InstallFirefoxAddon.py -f "darkreader" &
~/.local/bin/firefox_sh/InstallFirefoxAddon.py -f "ublockorigin" &
~/.local/bin/firefox_sh/InstallFirefoxAddon.py -f "lastpass" &
~/.local/bin/firefox_sh/InstallFirefoxAddon.py -f "cobalt" &
~/.local/bin/firefox_sh/InstallFirefoxAddon.py -f "i still don't care about cookies" &
~/.local/bin/firefox_sh/InstallFirefoxAddon.py -f "Vimium C" &

sleep 3
flatpak run org.mozilla.firefox 1>/dev/null 2>/dev/null &
disown %%
