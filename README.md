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
1) Install Ruby 2.2.5 http://rubyinstaller.org/downloads/ <br>
<i>x64 for 64-bit system and regular install for 32-bit system</i> <br>
2) Install Ruby DevKit http://rubyinstaller.org/downloads/ <br>
<i>Same link but at the bottom. Follow same logic for x64 as the above step</i> <br>
2a) Create a new directory to extract the Ruby DevKit into <RubyDev Path>
2b) Run these commands:
```
cd <RubyDev Path>
ruby dk.rb init
ruby dk.rb install
```
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
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew -v
brew doctor
\curl -L https://get.rvm.io | bash -s stable
rvm install 2.3.1
rvm use 2.3.1 --default
ruby -v
```
2) Install Node.js: "brew install node" <br>
3) Install Git: "brew install git" <br>
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

#### How to setup auto refresh:

1) Run "whenever -w" inside of the project directory

#### How to access remotely (with ngrok):

1) Download ngrok from https://ngrok.com/download <br>
2) Unzip and put ngrok inside of the same directory as PoGoBag <br>
3) Run "rails s" as usual inside of the project directory <br>
4) Open a new terminal or tab and cd into the project directory <br>
5) Run "./ngrok http 3000" <br>
6) Use the link under "Forwarding" to connect remotely <br>
![Imgur](http://i.imgur.com/7k6Kii3.png)

## Screenshots:

![Imgur](http://i.imgur.com/SdEIGjF.png)
![Imgur](http://i.imgur.com/lPvCpYa.png)

## Credits:

[nabeelamjad](https://github.com/nabeelamjad/poke-api) - For the API
