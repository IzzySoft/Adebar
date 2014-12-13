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


## `packages.xml` (and/or other files) not retrievable
On some devices (all 4.1+ devices with the ADB daemon running in non-root mode?),
`packages.xml` can not be pulled. Hence *Adebar* obtains related information via
`dumpsys` instead.

This applies to some other files as well, especially those with sensitive details
(e.g. `wpa_supplicant.conf`). If you want to pull them, you'll have to root your
device and make sure the ADB daemon runs in root-mode (which can e.g. be achieved
using chainfire's [adbd Insecure](http://play.google.com/store/apps/details?id=eu.chainfire.adbd)).


## `disable` script not working?
It seems many (all?) `adb pm disable` commands are not performed when `adbd` is
running in non-root mode, at least when run against pre-installed apps (aka
„bloatware“; confirmations/dementis welcome, as the list of devices at my
disposal is pretty limited, so I can not say whether that's a general rule).
Nothing we can do about that.


## Apps are always listed by their package names
Even in `doc/userApps.md`, which is a documentation file, apps are only listed
with their package names (e.g. `eu.chainfire.adbd` for chainfire's *adbd Insecure*).
I wish there were means to list the „human readable app name“ along – but apart
from pulling the entire `.apk` file and dissecting it via `aapt`, or trying to
look up the package in the app stores' web pages, I know of no simple way to get
hold on it.

To work around that, you can manually create the corresponding cache files, as
described in `hints.md`.

Alternative suggestions welcome.
