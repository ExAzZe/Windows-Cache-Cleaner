# Windows Cache Cleaner

Hey there! Welcome to my Windows Cache Cleaner repository. 

I wrote this simple batch script because I was tired of manually digging through hidden Windows folders to clean out temporary junk files. This script automates the whole process, asks for Admin rights automatically, cleans everything quietly, and tells you when it's done. 

## What does this script actually clean?

If you are used to pressing `Windows + R` (the Run dialog) to manually clean your PC, you'll recognize these steps. Here is exactly what the script does for you in the background:

* **User Temp Folder (`%temp%`)**
    If you press `Win + R` and type `%temp%`, you'll find where your daily applications dump their temporary data. Apps often "forget" to delete these files when you close them. This script wipes them out.

* **Windows Temp Folder (`temp`)**
    If you press `Win + R` and type `temp`, it opens the system's temporary folder (`C:\Windows\Temp`). Windows uses this for system-level tasks and installations. We clean this up too.

* **Prefetch Folder (`prefetch`)**
    By typing `prefetch` in the `Win + R` window, you access a folder where Windows stores data to launch your applications faster. Over time, it gets cluttered with traces of uninstalled or rarely used apps. Flushing it out gives your system a fresh start.

* **Windows Update Cache (`C:\Windows\SoftwareDistribution\Download`)**
    Whenever Windows downloads an update, it stores the installation files here. Once the update is installed, these files just sit there eating up gigabytes of space. The script safely empties this folder.

* **DNS Resolver Cache**
    *(Not a folder, but a background process)*. The script runs `ipconfig /flushdns` to clear your old internet connection records. It's great for fixing weird network glitches and loading errors in your browser.

## How to use it

1. Download the `WindowsCacheCleaner.bat` file.
2. Double-click it!
3. Windows will ask if you want to run it as Administrator (it needs these rights to access system folders like Prefetch). Click **Yes**.
4. Watch it clean everything in seconds, and press any key to close the window when it's done.

---
*Note: Some files might be in use by Windows while the script is running and won't be deleted. This is totally normal and safe!*
