###### A small script to email images using only bash
This script ships screenshots from every camera dir on a unifi device to your email recipients. To send out 9am screenshots add a crontab like this
```cron
58 8 * * * /usr/local/bin/email-images.sh 09
```
Make sure to install inotify-tools.
