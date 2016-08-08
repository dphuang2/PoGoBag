# PoGoBag

**Analyze** and **Share** your PokemonGo Inventory online!

Feel free to contribute and make pull request.

## To Setup:

#### Requirements

* Ruby
* Git
* Node.js
* Gems: rails, bundler

##### Windows:
1) Install Ruby 2.3.1 http://rubyinstaller.org/downloads/ <br>
2) Install Ruby DevKit http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe <br>
3) Install Node.js 4.4.7 https://nodejs.org/en/ <br>
4) Install Git https://git-scm.com/downloads <br>
5) Run these two commands in terminal: <br>
```
gem install rails
gem install bundler
```
##### Mac:
1) Install Ruby with RVM <br>
```
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.3.1
rvm use 2.3.1 --default
ruby -v
```
2) Install Node.js: "sudo apt-get install nodejs" <br>
3) Install Git: "sudo apt-get install git" <br>
4) Run these two commands: <br>
```
gem install rails
gem install bundler
```


#### Steps

1) Open terminal and change direcotry into whichever directory you want to place the project in: "cd ~" (for home directory) <br>
2) In that directory, clone the project "git clone https://github.com/dphuang2/PoGoBag.git" <br>
3) change directory into the project: "cd PoGoBag" <br>
4) Install all dependencies: "bundle install" <br>
5) Run database setup and start the server <br>
```
rake db:setup
rails s
```

6) Open your browser and navigate to http://localhost:3000 <br>
7) Login and browse your Pokemon!

![Imgur](http://i.imgur.com/Yzz5ouC.png)

#### How to access remotely (with ngrok):

1) Download ngrok from https://ngrok.com/download
2) Unzip and put ngrok inside of the same directory as PoGoBag
3) Run "rails s" as usual inside of the project directory
4) Open a new terminal or tab and cd into the project directory
5) Run "./ngrok http 3000"
6) Use the link under "Forwarding" to connect remotely
![Imgur](http://i.imgur.com/7k6Kii3.png)

## Screenshots:

![Imgur](http://i.imgur.com/SdEIGjF.png)
![Imgur](http://i.imgur.com/lPvCpYa.png)

## Credits:

[nabeelamjad](https://github.com/nabeelamjad/poke-api) - For the API
