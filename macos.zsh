# --- macos only ---
if [[ "$OSTYPE" != "darwin"* ]]; then
	return
fi

export HOMEBREW_NO_ENV_HINTS=1

alias vpn='networksetup -setsocksfirewallproxystate Wi-Fi'

hack() {
	sudo xattr -cr $1 && codesign --force --deep --sign - $1
}
flushdns() {
	sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}
