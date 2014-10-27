# Known Issues

## Some apps simply don't want to be backed up via ADB
At least on my P880 I've encountered several apps which seem to simply refuse
being backed up via ADB. In those cases, backups result in a 41 byte file (which
is just the backup file header). So watch out for those, and see to have them
backed up by other means; as *Adebar* here is no more than a "front-end" to the
`adb backup` command, I don't see what it could fix here.

Apps which I found having this issue include the following:

* installed as system apps:
  - GMail
  - SuperSU
* installed as user apps:
  - AppMonster Pro
  - DavDroid
  - JuiceSSH
  - MobilityMap
  - WakeLockDetector


## Backup of each app has to be confirmed separately
Yes. That's a security measure so no stranger could simply connect an USB cable
to your device and steal your data. I didn't yet check whether it's possible to
at least temporarily disable that. If I do and find a way, you will find it with
the other hints :)
