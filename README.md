# Adebar
***Adebar*** stands for <b>A</b>ndroid <b>De</b>vice <b>B</b>ackup <b>a</b>nd <b>R</b>eport. It is mainly based on [Bash](http://en.wikipedia.org/wiki/Bash_%28Unix_shell%29 "Wikipedia: Bash (Unix shell)") and [Adb](http://en.wikipedia.org/wiki/Android_Debug_Bridge "Wikipedia: Android Debug Bridge"). It reportedly works on Linux, Mac and Windows (Cygwin).

**Note:** As this is a collection of Shell scripts, you won't find any „binaries“ attached to releases – there are none for *Adebar* and no „compilation“ is required. Please take a look at [the wiki](https://codeberg.org/izzy/Adebar/wiki) for further details and instructions.


## What makes *Adebar* specific?
There are plenty of backup solutions available for Android, including such intended as front-end for ADB. So what is specific for *Adebar* that I wrote it, knowing of those other solutions?

The task I wrote *Adebar* for is to be able to quickly backup a device, and restore the backup again – e.g. when I need to factory-reset a device. That includes the case where I have to send a device to be serviced, and need to use a different device meanwhile: that would rule out a "complete restore" due to the side-effects system-apps might cause, especially when the second device is from a completely different manufacturer, and/or runs a different version of Android or even a completely different ROM. That's one of the reasons why the scripts generated by *Adebar* create one backup file per app (instead of one huge `backup.ab` holding them all) – while the other is to be able to select what to restore in general.

As a side-effect, *Adebar* generates a „report“ (or „short documentation“) on the device – including general device information (like model, Android version, device features, device status, configured accounts) as well as some details on installed apps (install source/date, last update, version, etc.).


## What kind of backup does *Adebar* create?
*Adebar* itself does not create any backups. But it generates multiple files, including

* a [shell script](http://en.wikipedia.org/wiki/Shell_script "Wikipedia: Shell script") to create separate ADB backups for the apps you've installed yourself ("user-apps"), including their `.apk` files and their data
* a shell script to create ADB backups of system apps, only containing their data
* a shell script to create disk images of your device's partitions
* a shell script to download contents of your internal/external SDCards and Backups via Titanium Backup's built-in web server
* a shell script to disable (freeze) all apps you had disabled/frozen on your device
* it pulls the `wpa_supplicant.conf` from your device, which holds information on all WiFi APs you've configured (root required) – and also some more configuration files.
* it pulls the `packages.xml` from your device, which holds all information about apps installed on your device (with Android 4.1 and above, this again requires root)
* a shell script to disable all broadcast receivers (aka "auto-starts") which were disabled on the given device
* a [HTML][2] file listing all user-installed apps with their sources you've installed them from (e.g. *Google Play*, *F-Droid*, *Aptoide*), date of first install/last update, installed version, and more – plus the same for the (pre-installed) system apps.
* a [HTML][2] file with some general device documentation.

Those three HTML files still have a `.md` file extension for historical reasons (before v2.0.0, they were created using [Markdown][4]). They are not complete HTML documents (no header, no footer); the example configuration in `doc/` has a user-function `uf_postrun()` taking care to assemble the pieces into one file which then will be a valid HTML document and thus have an `.html` file extension. Some examples of such "assembled device documentation pages" can be [found here](https://pages.codeberg.org/izzy/adebar/).

![Adebar-created files](https://codeberg.org/izzy/Adebar/wiki/raw/AdebarFiles.png)

Optionally, if you have the PHP [CLI](https://en.wikipedia.org/wiki/Command-line_interface "Wikipedia: Command-line interface") available on your computer, you can parse the `packages.xml` with provided PHP scripts, located in the `tools/` directory. This directory also includes a few additional scripts:

* `ab2tar`: shell script to convert ADB backup files into `.tar.gz` archives (requires `openssl` or `zlib-flate` and currently can only handle backups which were not password-protected)
* `abrestore`: to help you if you have issues restoring ADB backups on Android 7 or higher (if your device is affected by the ADB restore bug, only restoring backups of apps already installed on the device)
* `getapk`: grab the APK for a given app via ADB
* `mkdummy`: to create a "dummy device" from your real one (mainly intended for debug purposes: if you need assistance, you could zip/tar that after having it sanitized and attach it to an issue, or send it by other means)
* `ssnap`: to create a series of screenshots from your device

> **As I cannot test *Adebar* on all existing devices, there might be some errors/bugs here and there (specific to a given device, ROM or newer Android version); if you encounter one, please file an issue at [the project's Codeberg presence][1]. General feedback is also more than welcome if you're successfully using *Adebar* with your device, see [List of tested devices](https://codeberg.org/izzy/Adebar/issues/7).**


## Requirements
Most of them should already be obvious from above description. Nevertheless, all of them here in short:

* **ADB** installed (and configured for your device) on your computer. This can either be the [complete Android SDK](https://developer.android.com/sdk/index.html "Android SDK at Android Developers"), or a [minimal installation of ADB](https://android.stackexchange.com/q/42474/16575 "Android.SE: Is there a minimal installation of ADB?").
* **Bash** (version 4 or higher). As this is a very common shell environment, it's available by default on most Linux distributions. If you're a Windows user: sorry, the only windows I have are for light and fresh air – but I've received reports that *Adebar* ran successfully with [Cygwin](https://en.wikipedia.org/wiki/Cygwin).
* **Android 4.0+**: As the `adb backup` and `adb restore` commands have not been present before Android 4.0, *Adebar* will not be of much use with devices running older versions – except for, maybe, creating a „device documentation“ as outlined above.
* some features require root on the Android device


## QuickStart
To get started without too much hazzle, please see `doc/quickstart_config.sample`. Basically, you just copy that file to `config/` (giving it a name of your choice), adjust 4 to 6 settings to reflect your device plus directory structure, and you're ready-to-go.


## More details
A documentation describing steps for installation, configuration, usage, and more can be found in [the project wiki][3].


## Contribute
You like *Adebar* and want to contribute?

* Pull Requests are welcome!
* [Report back your device](https://codeberg.org/izzy/Adebar/issues/7) that works with *Adebar* so it can be added to the wiki!
* Motivate me e.g. by sending me some mBTC to `1FsfvUGUpoPkLvJboKAnuBXHZ1zN3hbBL1` :)


[1]: https://codeberg.org/izzy/Adebar "Adebar at Codeberg"
[2]: https://en.wikipedia.org/wiki/HTML "Wikipedia: HTML"
[3]: https://codeberg.org/izzy/Adebar/wiki "Adebar Wiki at Codeberg"
[4]: https://en.wikipedia.org/wiki/Markdown "Wikipedia: Markdown"
