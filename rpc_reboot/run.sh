#!/usr/bin/with-contenv bashio
set -e

# Read commands from Home Assistant
while read -r input; do
    computer=$(bashio::jq "${input}" '.')
    bashio::log.info "Rebooting target: $computer"

    # Pull address, credentials, etc. from config
    ADDRESS=$(bashio::config "computers.${computer}.address")
    CREDENTIALS=$(bashio::config "computers.${computer}.credentials")
    DELAY=$(bashio::config "computers.${computer}.delay")
    MESSAGE=$(bashio::config "computers.${computer}.message")

    [ -z "$DELAY" ] && DELAY=0

    # Run reboot instead of shutdown
    if ! msg="$(net rpc shutdown -I "$ADDRESS" -U "$CREDENTIALS" -t "$DELAY" -C "$MESSAGE" -r)"; then
        bashio::log.error "Reboot failed: $msg"
    fi
done
