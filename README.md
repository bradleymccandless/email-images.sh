#### A small script to email images using only bash
This script ships screenshots from every camera dir on a unifi device to your email recipients. To send out 9am screenshots add a crontab like this
```crontab
58 8 * * * /usr/local/bin/email-images.sh 09
```
Make sure to install inotify-tools. I posted the script here because it has a couple little features that I love:

- Send emails using only bash (ok, ok. bash+openssl).
- SMTP pipelining. Reuse the TLS connection for all recipients instead of starting one per each recipient.
- inotify waits for all the new screenshots to land on the disk.
