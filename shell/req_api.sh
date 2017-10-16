if ! type "$brew" > /dev/null; then
  echo "homebrew is not installed, please install homebrew"
else
  if ! type "$curl" > /dev/null; then
    echo "curl is not installed, please install curl"
  else
    if ! type "$jq" > /dev/null; then
      echo "jq is not installed, please install jq"
    else
      if [ -z "$2" ]; then
        echo syntax: sh req_api.sh '<apipath> <postdata> [envvar_replace] [jq_query] [envvar]'
      else
        if [ -z "$3" ]; then
          resp=$(curl -sS -X POST ${apiurl}/$1 -H 'Content-Type: application/json' -d "$2")
        else
          # 3rd parameter means to replace a tag in the json file with the value of an environment variable
          json=$(cat "$2")
          for var in $(echo $3 | tr "," " "); do
            json=$(echo "$json" | sed "s/-$var-/${!var}/g")
          done
          resp=$(echo "$json" | curl -sS -X POST ${apiurl}/$1 -H 'Content-Type: application/json' -d @-)
        fi

        if [ -z "$4" ]; then
          echo $resp
        else
          # 4th parameter is a jasonquery jq filter
          if [ -z "$5" ]; then
            echo $resp | jq -r $4
          else
            # 5th parameter sets an environment variable with the value
            export $5="$(echo $resp | jq -r $4)"
            echo "${!5}"
          fi
        fi
      fi
    fi
  fi
fi
