# Adebar
***Adebar*** stands for <b>A</b>ndroid <b>De</b>vice <b>B</b>ackup <b>a</b>nd <b>R</b>estore. It is mainly based on [Bash](http://en.wikipedia.org/wiki/Bash_%28Unix_shell%29 "Wikipedia: Bash (Unix shell)") and [Adb](http://en.wikipedia.org/wiki/Android_Debug_Bridge "Wikipedia: Android Debug Bridge"), with additional (optional) parts written in [PHP](http://en.wikipedia.org/wiki/PHP "Wikipedia: PHP").


## What makes *Adebar* specific?
There are plenty of backup solutions available for Android, including such intended as front-end for ADB. So what is specific for *Adebar* that I wrote it, knowing of those other solutions?

The task I wrote *Adebar* for is to be able to quickly backup a device, and restore the backup again – e.g. when I need to factory-reset a device. That includes the case where I have to send a device to be serviced, and need to use a different device meanwhile: that would rule out a "complete restore" due to the side-effects system-apps might cause, especially when the second device is from a completely different manufacturer, and/or runs a different version of Android or even a completely different ROM.


## What kind of backup does *Adebar* create?
*Adebar* itself creates multiple files, including

* a [shell script](http://en.wikipedia.org/wiki/Shell_script "Wikipedia: Shell script") to create separate ADB backups for the apps you've installed yourself ("user-apps"), including their `.apk` files and their data
* a shell script to create ADB backups of system apps, only containing their data
* a shell script to disable (freeze) all apps you had disabled/frozen on your device
* it pulls the `wpa_supplicant.conf` from your device, which holds information on all WiFi APs you've configured
* it pulls the `packages.xml` from your device, which holds all information about apps installed on your device

Optionally, if you have the PHP [CLI](http://en.wikipedia.org/wiki/Command-line_interface "Wikipedia: Command-line interface") available on your computer, it parses the `packages.xml` and creates additional files:

* a shell script to disable all broadcast receivers (aka "auto-starts") which were disabled on the given device
* a [Markdown](http://en.wikipedia.org/wiki/Markdown "Wikipedia: Markdown") file listing all user-installed apps with their sources you've installed them from (e.g. *Google Play*, *F-Droid*, *Aptoide*)

As *Adebar* still is in its early stage of development, and not tested on too many devices, there might be some errors/bugs here and there. But there are also additional features to be expected lateron. One example for the latter is a GUI, which I plan to add as soon as all the basic stuff is working reliably.


## Requirements
Most of them should already be obvious from above description. Nevertheless, all of them here in short:

* **ADB** installed (and configured for your device) on your computer. This can either be the [complete Android SDK](https://developer.android.com/sdk/index.html "Android SDK at Android Developers"), or a [minimal installation of ADB](http://android.stackexchange.com/q/42474/16575 "Android.SE: Is there a minimal installation of ADB?").
* **Bash**. As this is a very common shell environment, it's available by default on most Linux distributions. If you're a Windows user: sorry, the only windows I have are for light and fresh air.
* **PHP CLI**: This is available in the repositories of all major Linux distributions. I've tested this with PHP 5.3 – but I see no reasons why it shouldn't work with newer versions.


## Usage
As the command-line parameters are subject to change in the initial phase (i.e. more of them will be added), just basic hints here: run the executable (shell script) without parameters, it should tell you more. Basically, you need to pass it the "target directory" (where the output files should be placed in), and it will use defaults for everything else. To give an example:

1. Connect your device
1. Run `adb devices` to make sure it was recognized
1. Run the script, passing it the output directory name as argument
