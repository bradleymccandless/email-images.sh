#!/bin/sh

if [ ! $(which inotifywait) ]; then printf -- 'Need inotify-tools\n'; exit 127; fi
if [ ! $(which openssl) ]; then printf -- 'Need openssl\n'; exit 127; fi

screenshot_dir=/srv/unifi-video/snapshot
emails="user1@domain.com user2@domain.com"
host=domain.com
name="$(date +%F) ${1}00.jpg"

compose_emails(){
  if [ "$(find $screenshot_dir -mmin -90 -name $1.jpg)" ]; then
    cat <<EOF | openssl s_client -quiet -connect $host:465
EHLO $host
Auth Plain ***
$(for email in $emails; do
printf -- "Mail From: Autobot <bot@domain.com>
Rcpt To: $email
Data
From: Autobot <bot@domain.com>
To: <$email>
Subject: Screenshot Images
Reply-To: Autobot <bot@domain.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=-

$(for folder in $(ls $screenshot_dir); do
  if [ $(find $screenshot_dir/$folder -mmin -90 -name $1.jpg) ]; then
    printf -- "---
Content-Type: image/jpeg
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=$name\n\n"
    base64 $screenshot_dir/$folder/$1.jpg
    printf "\n"
  fi; done; printf -- "-----\n";)
.
"
done;)
Quit
EOF
fi
}

wait_for_screenshot(){
  for folder in $(ls $screenshot_dir); do \
    inotifywait -e delete_self -t 3720 $screenshot_dir/$folder/$1.jpg & done
  wait
  compose_emails $1
}

wait_for_screenshot $1 & done
