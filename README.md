# Adebar
***Adebar*** stands for <b>A</b>ndroid <b>De</b>vice <b>B</b>ackup <b>a</b>nd <b>R</b>eport. It is mainly based on [Bash](http://en.wikipedia.org/wiki/Bash_%28Unix_shell%29 "Wikipedia: Bash (Unix shell)") and [Adb](http://en.wikipedia.org/wiki/Android_Debug_Bridge "Wikipedia: Android Debug Bridge").


## What makes *Adebar* specific?
There are plenty of backup solutions available for Android, including such intended as front-end for ADB. So what is specific for *Adebar* that I wrote it, knowing of those other solutions?

The task I wrote *Adebar* for is to be able to quickly backup a device, and restore the backup again – e.g. when I need to factory-reset a device. That includes the case where I have to send a device to be serviced, and need to use a different device meanwhile: that would rule out a "complete restore" due to the side-effects system-apps might cause, especially when the second device is from a completely different manufacturer, and/or runs a different version of Android or even a completely different ROM. That's one of the reasons why *Adebar* creates one backup file per app (instead of one huge `backup.ab` holding them all) – while the other is to be able to select what to restore in general.

As a side-effect, *Adebar* generates a „report“ (or „short documentation“) on the device – including general device information (like model, Android version, device features, device status, configured accounts) as well as some details on installed apps (install source/date, last update, version, etc.).


## What kind of backup does *Adebar* create?
*Adebar* itself creates multiple files, including

* a [shell script](http://en.wikipedia.org/wiki/Shell_script "Wikipedia: Shell script") to create separate ADB backups for the apps you've installed yourself ("user-apps"), including their `.apk` files and their data
* a shell script to create ADB backups of system apps, only containing their data
* a shell script to create disk images of your device's partitions
* a shell script to download contents of your internal/external SDCards and Backups via Titanium Backup's built-in web server
* a shell script to disable (freeze) all apps you had disabled/frozen on your device
* it pulls the `wpa_supplicant.conf` from your device, which holds information on all WiFi APs you've configured (root required) – and also some more configuration files.
* it pulls the `packages.xml` from your device, which holds all information about apps installed on your device (with Android 4.1 and above, this again requires root)
* a shell script to disable all broadcast receivers (aka "auto-starts") which were disabled on the given device
* a [Markdown][2] file listing all user-installed apps with their sources you've installed them from (e.g. *Google Play*, *F-Droid*, *Aptoide*), date of first install/last update, installed version, and more (see [example `userApps.md` in the Wiki](https://github.com/IzzySoft/Adebar/wiki/example-userApps.md)).
* a [Markdown][2] file with some general device documentation (see above – and the [example `deviceInfo.md` in the wiki](https://github.com/IzzySoft/Adebar/wiki/example-deviceInfo.md)).

![Adebar-created files](https://github.com/IzzySoft/Adebar/wiki/AdebarFiles.png)

Optionally, if you have the PHP [CLI](http://en.wikipedia.org/wiki/Command-line_interface "Wikipedia: Command-line interface") available on your computer, you can parse the `packages.xml` with provided PHP scripts. The package also includes a shell script to convert ADB backup files into `.tar.gz` archives (requires `openssl`).

> **As *Adebar* is not yet tested on too many devices, there might be some errors/bugs here and there; if you encounter one, please file an issue at [the project's Github presence][1]. General feedback is also more than welcome if you're successfully using *Adebar* with your device, see [List of tested devices](https://github.com/IzzySoft/Adebar/issues/7).**


## Requirements
Most of them should already be obvious from above description. Nevertheless, all of them here in short:

* **ADB** installed (and configured for your device) on your computer. This can either be the [complete Android SDK](https://developer.android.com/sdk/index.html "Android SDK at Android Developers"), or a [minimal installation of ADB](http://android.stackexchange.com/q/42474/16575 "Android.SE: Is there a minimal installation of ADB?").
* **Bash** (version 4 or higher). As this is a very common shell environment, it's available by default on most Linux distributions. If you're a Windows user: sorry, the only windows I have are for light and fresh air.
* **Android 4.0+**: As the `adb backup` and `adb restore` commands have not been present before Android 4.0, *Adebar* will not be of much use with devices running older versions – except for, maybe, creating a „device documentation“ as outlined above.
* some features require root on the Android device


## More details
A documentation describing steps for installation, configuration, usage, and more can be found in [the project wiki][3].

[1]: https://github.com/IzzySoft/Adebar "Adebar at Github"
[2]: http://en.wikipedia.org/wiki/Markdown "Wikipedia: Markdown"
[3]: https://github.com/IzzySoft/Adebar/wiki "Adebar Wiki at Github"

