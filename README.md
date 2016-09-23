***PoGoBag Server Installer for Windows***
-----------------------------------------------

**This is an auto installer that can setup PoGoBag on Windows platform with just one click.**

 - -Also apply fixes for bug of sqlite3 gem of *RubyForWindows.*-

***Extra Features***

1.easy-to-use PoGoBag Launcher from Desktop

2.One Click Automatic Updater(Automatically download update from https://github.com/dphuang2/PoGoBag)

**About the source code:**

 - This installer was made with "Nullsoft Scriptable Install
   System"(NSIS)
   
 - To compile the setup file, you must include the plugins that are used
   in "pogobag.nsi".
 - In regard of some incompatible issues with some old NSIS plugins,
   most of the command-line execution steps are replaced with few
   precompiled console binaries to avoid most problems.

 

 - Source codes of each precompiled binaries can be found under the
   /source folder, they're  written with C++. Source codes contains Code::Blocks project files(.cbp) which contains some compile settings can be opened with Code::Blocks. They're just very very simple
   codes which can complete all the tasks.
 - In the beginning, I separated every execution steps into different
   binaries for better debugging purpose. I'll merge them into one
   executable to reduce the size of installer once I have time to do
   this.

**About the installer:**

 - The installer downloads newest PoGoBag and poke-api from Git during
   the installation, they do not come with the installer. As a result,
   an Internet connection is necessary during the installation.
    - Packages listed below are included in this installer:

     -*RubyInstaller for Windows   (http://rubyinstaller.org/)*

     -*Ruby Development Kit         (http://rubyinstaller.org/)*

     -*Git                                      (https://git-scm.com/)*

     -*Node.js                                (https://nodejs.org/)*

     -*Sqlite3 Source&Binaries    (https://www.sqlite.org/)*

**About the Launcher:**

 - It's just an easy-to-use function that can help you launch PoGoBag
   server with one click from desktop. 
   

 - Default running port is 80. Some version of Windows does come with IIS server startup by default. The Launcher will show a message and abort the load of PoGoBag if IIS is detected running.

 

 - Adding the binary PoGoBag_Launcher.exe  to srartup registry can let  
   you start PoGoBag whenever your remote Windows Server boots up.
 
**About the Updater:**
 - An easy-to-use function that can update your PoGoBag with the latest
   version from Github.

   



**Other 3rd Party distribution are included to make this installer:**
**Icons:* 
_____________________________________________________________________________________
http://www.flaticon.com/authors/roundicons-freebies

Pokemon Egg icon made by roundicons.com under license (CC BY 3.0)

Hatching Pokemon Egg icon made by roundicons.com under license (CC BY 3.0)
______________________________________________________________________________________
https://www.iconfinder.com/GeoGavilanes

Blastoise icon By Geovanny Gavilanes under license (CC BY 2.5)

Lapras icon By Geovanny Gavilanes under license (CC BY 2.5)
______________________________________________________________________________________








2016/09/23
enjoy,
evilhawk00 =)

