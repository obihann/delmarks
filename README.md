#Delmarks
A node based command line tool for managing your [delicious](https://delicious.com/obihann) bookmarks.

##Installation

You can install us through npm

    npm install delmarks -g

##Usage

Connect your account:

    delmarks connect USERNAME PASSWORD

List bookmarks:

    delmarks ls

Add bookmark:

    delmarks add http://github.com/

Remove bookmark:

    delmarks remove http://github.com/

Help:

    delmarks -h

##ToDo
* Add export to HTML/JSON/XML feature
* Add taggiing
* Auto generate tags similar to delicious.com functionality
* Add update description / note
* Investigate securing conncetion with Delicious as currently very unsecure
* Investigate securing the user config file that contains the username and password (JSON is great but unsecure for plain text passwords)
* Restructure code
* Look into cool social features like shareing link to twitter or facebook
* Some other stuff...

##Credits
* [ajlopez](https://github.com/ajlopez) - Creator of [NodeDelicious](https://github.com/ajlopez/NodeDelicious)

##License
[GNU General Public License v2](http://www.gnu.org/licenses/gpl-2.0.html).

Copyright [Jeffrey Hann](http://jeffreyhann.ca/) 2013
