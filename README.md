### A small script to email images using only bash
This script ships screenshots from every camera attached to a unifi device to many email recipients. To send out 9am screenshots add a crontab like this
```crontab
58 8 * * * /usr/local/bin/email-images.sh 09
```
Make sure to install inotify-tools. I posted the script here because it has a few features that I love:

- Send emails using only bash (ok, ok. bash+openssl).
- SMTP pipelining. Reuse the TLS connection and AUTH for all recipients instead of using one for each recipient.
- inotify waits (efficiently) for all the new screenshots to land on the disk.
