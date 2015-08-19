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