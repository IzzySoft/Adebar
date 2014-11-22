# Adebar
***Adebar*** stands for <b>A</b>ndroid <b>De</b>vice <b>B</b>ackup <b>a</b>nd <b>R</b>eport. It is mainly based on [Bash](http://en.wikipedia.org/wiki/Bash_%28Unix_shell%29 "Wikipedia: Bash (Unix shell)") and [Adb](http://en.wikipedia.org/wiki/Android_Debug_Bridge "Wikipedia: Android Debug Bridge"), with additional (optional) parts written in [PHP](http://en.wikipedia.org/wiki/PHP "Wikipedia: PHP").


## What makes *Adebar* specific?
There are plenty of backup solutions available for Android, including such intended as front-end for ADB. So what is specific for *Adebar* that I wrote it, knowing of those other solutions?

The task I wrote *Adebar* for is to be able to quickly backup a device, and restore the backup again – e.g. when I need to factory-reset a device. That includes the case where I have to send a device to be serviced, and need to use a different device meanwhile: that would rule out a "complete restore" due to the side-effects system-apps might cause, especially when the second device is from a completely different manufacturer, and/or runs a different version of Android or even a completely different ROM. That's one of the reasons why *Adebar* creates one backup file per app (instead of one huge `backup.ab` holding them all) – while the other is to be able to select what to restore in general.

As a side-effect, *Adebar* generates a „report“ (or „short documentation“) on the device – including general device information (model, Android version, device features, configured accounts) as well as some details on installed apps (install source/date, last update, version, etc.).


## What kind of backup does *Adebar* create?
*Adebar* itself creates multiple files, including

* a [shell script](http://en.wikipedia.org/wiki/Shell_script "Wikipedia: Shell script") to create separate ADB backups for the apps you've installed yourself ("user-apps"), including their `.apk` files and their data
* a shell script to create ADB backups of system apps, only containing their data
* a shell script to download contents of your internal/external SDCards and Backups via Titanium Backup's built-in web server
* a shell script to disable (freeze) all apps you had disabled/frozen on your device
* it pulls the `wpa_supplicant.conf` from your device, which holds information on all WiFi APs you've configured (requires the ADB daemon to run in root mode)
* it pulls the `packages.xml` from your device, which holds all information about apps installed on your device (with Android 4.1 and above, this again requires the ADB daemon to run in root mode)
* a shell script to disable all broadcast receivers (aka "auto-starts") which were disabled on the given device
* a [Markdown][2] file listing all user-installed apps with their sources you've installed them from (e.g. *Google Play*, *F-Droid*, *Aptoide*), date of first install/last update, installed version, and more.
* a [Markdown][2] file with some general device documentation (model, Android version, device features, configured accounts)

Optionally, if you have the PHP [CLI](http://en.wikipedia.org/wiki/Command-line_interface "Wikipedia: Command-line interface") available on your computer, you can parse the `packages.xml` with provided PHP scripts. The package also includes a shell script to convert ADB backup files into `.tar.gz` archives (requires `openssl`).

> As *Adebar* still is in its early stage of development, and not tested on too many devices, there might be some errors/bugs here and there; if you encounter one, please file an issue at [the project's Github presence][1]. General feedback is also more than welcome if you're successfully using *Adebar* with your device.


## Requirements
Most of them should already be obvious from above description. Nevertheless, all of them here in short:

* **ADB** installed (and configured for your device) on your computer. This can either be the [complete Android SDK](https://developer.android.com/sdk/index.html "Android SDK at Android Developers"), or a [minimal installation of ADB](http://android.stackexchange.com/q/42474/16575 "Android.SE: Is there a minimal installation of ADB?").
* **Bash**. As this is a very common shell environment, it's available by default on most Linux distributions. If you're a Windows user: sorry, the only windows I have are for light and fresh air.
* **Android 4.0+**: As the `adb backup` and `adb restore` commands have not been present before Android 4.0, *Adebar* will not be of much use with devices running older versions – except for, maybe, creating a „device documentation“ as outlined above.


## Usage
As the command-line parameters are subject to change in the initial phase (i.e. more of them will probably be added), just basic hints here: run the executable (shell script) without parameters, it should tell you more. Basically, you need to pass it the "target directory" (where the output files should be placed in), and it will use defaults for everything else. To give an example:

1. Connect your device
1. Run `adb devices` to make sure it was recognized
1. Run the script, passing it the output directory name as argument
1. Adjust the created scripts to suit your needs (e.g. comment out/remove stuff you don't want to be backed up)
1. Run the (adjusted) scripts to create your backups/restores


## More details
More details and hints can be found in the `doc/` sub-directory of the project.

[1]: https://github.com/IzzySoft/Adebar "Adebar at Github"
[2]: http://en.wikipedia.org/wiki/Markdown "Wikipedia: Markdown"

