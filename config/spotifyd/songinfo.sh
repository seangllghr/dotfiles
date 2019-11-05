user_id=93a4fc13d6c340cd9a3f83b47056ee5a # generated on https://developer.spotify.com/dashboard/applications
secret_id=7b224616d12f49f7a533df70dcad55fc

myToken=$(curl -s -X 'POST' -u $user_id:$secret_id -d grant_type=client_credentials https://accounts.spotify.com/api/token | jq '.access_token' | cut -d\" -f2)
RESULT=$?

if [ "$PLAYER_EVENT" = "start" ];
then
    if [ $RESULT -eq 0 ]; then
      trackJSON=$(curl -s -X 'GET' https://api.spotify.com/v1/tracks/$TRACK_ID -H 'Accept: application:/json' -H 'Content-Type: application-json' -H "Authorization:\"Bearer $myToken\"")
      trackname=$(echo $trackJSON | jq '.name')
      trackartists=$(echo $trackJSON | jq '.artists[].name')
      trackartists=$(echo $trackartists)
      notify-send\
        --urgency=low\
        --expire-time=3000\
        --icon=/usr/share/icons/gnome/32x32/actions/player_fwd.png\
        --app-name=spotifyd\
        " spotifyd -- Now Playing"\
        "$trackname\n$(echo ${trackartists}\ | sed 's/" "/, /g'\ | sed 's/"//g')"
      else
        echo "Cannot get token."
    fi
elif [ "$PLAYER_EVENT" = "change" ];
then
    if [ $RESULT -eq 0 ]; then
      trackJSON=$(curl -s -X 'GET' https://api.spotify.com/v1/tracks/$TRACK_ID -H 'Accept: application:/json' -H 'Content-Type: application-json' -H "Authorization:\"Bearer $myToken\"")
      trackname=$(echo $trackJSON | jq '.name')
      trackartists=$(echo $trackJSON | jq '.artists[].name')
      trackartists=$(echo $trackartists)
      notify-send\
        --urgency=low\
        --expire-time=3000\
        --icon=/usr/share/icons/gnome/32x32/actions/player_fwd.png\
        --app-name=spotifyd\
        " spotifyd -- Now Playing"\
        "$trackname\n$(echo ${trackartists}\ | sed 's/" "/, /g'\ | sed 's/"//g')"
    else
        echo "Cannot get token."
    fi
elif [ "$PLAYER_EVENT" = "stop" ];
then
    if [ $RESULT -eq 0 ]; then
        notify-send\
          --urgency=low\
          --expire-time=3000\
          --app-name=spotifyd\
          " spotifyd -- Stopped"
    else
        echo "Cannot get token."
    fi
else
    echo "Unkown event."
fi
