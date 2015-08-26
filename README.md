# README #


### Getting Started ###

### Kaishi ###

Run [Kaishi](http://icalialabs.github.io/kaishi/) - bash script that contains all the relevant packages for the API.

### Git ###
We'll be using homebrew as a package manager for Mac OS.
```sh
$ brew install git
```
In case you're using Linux: 
```sh
$ sudo apt-get install git
```

### Ruby ###

**Mac OS**:
```sh
$ rbenv install 2.1.2
$ rbenv global 2.1.2
$ rbenv rehash
```

For **Linux**, the first step is to set up some dependencies for Ruby.
```sh
$ sudo apt-get update
$ sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev \
                            libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                            libxml2-dev libxslt1-dev libcurl4-openssl-dev \
                            python-software-properties
```

Next, install Ruby.
```sh
$ cd
$ git clone git://github.com/sstephenson/rbenv.git .rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
$ echo 'eval "$(rbenv init -)"' >> ~/.profile
$ exec $SHELL

$ git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
$ echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.profile
$ exec $SHELL

$ rbenv install 2.1.2
$ rbenv global 2.1.2
```

### Gems, Rails & Missing libraries ###
Update the gems.
```sh
$ gem update --system
```

On **Mac OS**, it may be required to install additional libraries.
```sh
$ brew install libtool libxslt libksba openssl
```

Install the necessary gems.
```sh
$ printf 'gem: --no-document' >> ~/.gemrc
$ gem install bundler
$ gem install foreman
$ gem install rails -v 4.0
```

### Database ###

For now, we'll be using **SQlite**, which MacOS has installed by default. However, if you're running on Linux:
```sh
$ sudo apt-get install libxslt-dev libxml2-dev libsqlite3-dev
```

### Pow or Prax ###
If you are running on **MacOS**, you need to install **Pow** - replace */Work/estudent/* with the folder in which you have set up your application.
```sh
$ curl get.pow.cx | sh
$ cd ~/.pow
$ ln -s ~/Work/estudent/estudent_api/
```
At this point, you can access the application in your browser, by using this link: [http://estudent_api.dev](http://estudent_api.dev)

For **Linux** users, you need **Prax**. If you have any trouble with this tool, please check out the [README](https://github.com/ysbaddaden/prax/blob/master/README.rdoc) file on the github repository.

```sh
$ sudo git clone git://github.com/ysbaddaden/prax.git /opt/prax
$ cd /opt/prax/
$ ./bin/prax install  
$ cd ~/Work/estudent/estudent_api/
$ prax link
$ prax start
```
When using prax, you have to specify the port for the URL, in this case [http://estudent_api.dev:3000](http://estudent_api.dev:3000)

### Almost there ###
Once you have this configuration set up, it is time to run:
```sh
$ bundle install
Fetching source index for https://rubygems.org/
.
.
.
```

Then run the migration, and prepare the test db:
```sh
$ rake db:migrate
```

```sh
$ rake db:test:prepare
```