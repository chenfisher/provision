# Provisional

The provisional gem lets you hook a provisional filter to a method.

For example, 
Lets say we have an article website, where users can post articles.

We want to limit the number of articles a user can post to our website, based on a primium account. For example, if the user is using the free version he can post up to 5 articles, where a user that has paid and is using the pro account, can post up to 20 articles.

This is where 'provisional' comes in. It makes it easy and dry to do provisions on you website.

NOTE: You can use provisional on ANY class (including controller, models, etc.)


## Installation

Add this line to your application's Gemfile:

    gem 'provisional'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install provisional

## Usage

Lets say we want to provision a user with the number of articles he can post:




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
