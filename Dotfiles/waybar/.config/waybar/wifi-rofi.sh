#!/usr/bin/env bash

# Notify user that we are fetching the list of available Wi-Fi networks
notify-send "Getting list of available Wi-Fi networks..."

# Get a list of available Wi-Fi networks, display the SSID with icons based on security type
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | \
    sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Check if Wi-Fi is enabled or disabled
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
    toggle="󰖩  Enable Wi-Fi"
fi

# Use rofi to display the list of Wi-Fi networks with the option to toggle Wi-Fi on/off
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: ")

# Get the name of the selected connection (SSID)
read -r chosen_id <<< "${chosen_network:3}"

# If no selection is made, exit the script
if [ -z "$chosen_network" ]; then
    exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
    # Enable Wi-Fi if it's disabled
    nmcli radio wifi on
    notify-send "Wi-Fi Enabled" "Wi-Fi is now enabled."
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
    # Disable Wi-Fi if it's enabled
    nmcli radio wifi off
    notify-send "Wi-Fi Disabled" "Wi-Fi is now disabled."
else
    # Check if the selected network is saved or not
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        # If the network is saved, connect to it
        nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
    else
        # If the network is not saved, ask for the password (if WPA or WPA2)
        if [[ "$chosen_network" =~ "" ]]; then
            wifi_password=$(rofi -dmenu -p "Password: " )
        fi
        # Try to connect to the Wi-Fi network
        nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi


