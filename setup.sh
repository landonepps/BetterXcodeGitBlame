#!/usr/bin/env bash
set -euo pipefail  # http://redsymbol.net/articles/unofficial-bash-strict-mode/

if ! [ $(id -u) = 0 ]
then
   echo "This script needs to be run as root." 1>&2
   exit 1
fi

PLIST_FILE='/Library/LaunchDaemons/com.landonepps.BetterXcodeBlame.plist'

if [ ! -f $PLIST_FILE ]
then
cat > $PLIST_FILE << _EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>local.job</string>
	<key>ProgramArguments</key>
	<array>
		<string>$HOME/.xcode_blame/install</string>
		<string>--local</string>
	</array>
	<key>RunAtLoad</key>
	<false/>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Hour</key>
		<integer>6</integer>
		<key>Minute</key>
		<integer>0</integer>
	</dict>
</dict>
</plist>

_EOF
chown root:wheel $PLIST_FILE
chmod 644 $PLIST_FILE
launchctl load -w $PLIST_FILE
fi
