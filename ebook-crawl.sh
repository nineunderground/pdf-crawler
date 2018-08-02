#!/bin/bash
# It does a web url called to attempt a login request tot he ebook service.
# Then it uses the given token for the claim pdf

echo "Reading config"
sleep 1.5

################################################
# STEP 0
# Getting values from config.ini
################################################
filename="./config.ini"
myuser=""
mypass=""
while read -r line
do
    initial="$(echo $line | head -c 1)"
    if  [ "$initial" != "#" ]
    then
      entry=$(echo $line | cut -c1-4)
      if [ "$entry" = "USER" ]
      then
        myuser=$(echo $line | cut -c6-)
      fi

      if [ "$entry" = "PASS" ]
      then
        mypass=$(echo $line | cut -c6-)
      fi
    fi
done < "$filename"

if  [ "$myuser" = "" ] | [ "$mypass" = "" ]
then
  echo "Check your config values"
  exit -1
fi

################################################
# STEP 1
# Sign in request
################################################
echo "Sign in request"
sleep 1.5
# Login to get auth token
# TODO Replace into myuser variable, value "@" for "%40"
# TODO Replace USER and PASS into file "form_req.data" with values myuser & mypass
curl -d "@form_req.data" --dump-header response-headers https://www.packtpub.com/
# There must be a file created with name "response-headers"

# 1.A If everything goes well (TODO first line in response-headers contains "HTTP/1.1 302 Found"), continues

# 1.B If fails, prints received message and ends with error

# 2. Make the claim PDF request with token PDF_TOKEN
# Replaces cookie values  "SESS_live", "access_token_live" & "refresh_token_live" into file my-ebooks-headers.data
curl -d "@my-ebooks-headers.data" -POST https://www.packtpub.com/account/my-ebooks

# 2.A If succeeded then save local PDF file and ends with success

# 2.C If succeeded send file to slack channel?

# 2.B If fails, then prints received message and ends with error
