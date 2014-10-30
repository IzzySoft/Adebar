# Known Issues

## Some apps simply don't want to be backed up via ADB
In my tests I've encountered several apps which seem to simply refuse
being backed up via ADB. In those cases, backups result in a 41 byte file (which
is just the backup file header). So watch out for those, and see to have them
backed up by other means; as *Adebar* here is no more than a "front-end" to the
`adb backup` command, I don't see what it could fix here. As the example of
[DavDroid](https://github.com/rfc2822/davdroid) shows, this is rather to be
fixed on the corresponding Android app's end.

Apps which I found having this issue include the following:

* installed as system apps:
  - GMail
  - SuperSU
* installed as user apps:
  - AppMonster Pro
  - DavDroid (pre-0.6.4; fixed [on DavDroid's end](https://github.com/rfc2822/davdroid/releases/tag/v0.6.4))
  - JuiceSSH
  - MobilityMap
  - WakeLockDetector


## Backup of each app has to be confirmed separately
Yes. That's a security measure so no stranger could simply connect an USB cable
to your device and steal your data. I didn't yet check whether it's possible to
at least temporarily disable that. If I do and find a way, you will find it with
the other hints :)
