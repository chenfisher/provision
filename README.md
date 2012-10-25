# Provision

The provision gem lets you hook a provision filter to a method. **ANY method**.

For example, 
Lets say we have an article website, where users can post articles.

We want to limit the number of articles a user can post to our website, based on a primium account. For example, if the user is using the free version he can post up to 5 articles, when a user that has paid and is using the pro account, can post up to 20 articles.

This is where 'provision' comes in. It makes it easy and dry to do provisions on your website.

The great thing about **provision** is that it can act on any level - model, controller or any other class you have.
Think of it as ActiveRecord's **validate** and Controller's **before_filter** combined and available on any class and method. 


## Installation

Add this line to your application's Gemfile:

    gem 'provision'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install provision

## Usage
When a method is provisioned, whenever it is called, the provision method comes into action.
If the provision method returns true then the original method will be called. If the provision returns false
then the method won't be called (and false will be returned)

### Provision using a method
	class SomeClass
		def a_method
			# do something
		end
		provision :a_method, :with => :provision_method

		private
			def provision_method
				# some condition (returns true or false)
			end
	end

**provision_method** can take optional ***args** which are the arguments passed to the original method:

	def provision_method(*args)
		# some condition using args
	end


### Provision using a proc (lambda)
	class SomeClass
		def a_method
			# do something
		end
		provision :a_method, :with => lambda{ [some condition] }
	end

**lambda** can take arguments like so:

	provision :a_method, :with => lambda{ |sender, *args| [some condition] }
where **sender** is the instance of SomeClass and ***args** are the arguments passed to the original method


### Provision using a class name
	class SomeClass
		def a_method
			# do something
		end
		provision :a_method, :with => ProvisionClass
	end

**NOTE**: provision will try to call `ProvisionClass.provision!` (a class method); if the class does not respond to provision! then
it will create an instance of ProvisionClass and then call `provision!` (mind the bang!)

	class ProvisionClass
		def self.provision!(sender, *args)
			# some condition using sender and *args
		end
	end

**sender** is the instance of SomeClass and ***args** are the arguments passed to the original method

### Provision using an instance of a class
when the **lambda** block return something other than *true* or *false* then provision assumes it returns an instance
of a class that responds to **provision!**

	provision :a_method, :with => lambda{ |sender, *args| ProvisionClass.new(sender, *args) }

**sender** and ***args** are optional

### Add a block to do something
You can add a block which will be called when the provision returns false.

	provision :a_method, :with => lambda{ some_condition } do |sender, *args|
		# do something for when the provision fails
		# for example: send a notification email to the user you just provisioned
	end

**sender** and ***args** are optional

### Provision more than one method at a time
You can pass any number of methods to be provisioned

	provision :a_method, :another_method, :with => lambda{ some_condition } do
		# do something
	end

### Use it in your controllers and models
You can use it in your controllers and models like you use before_filter and validations.
Lets provision a user on the number of posts they can post. We can do this on the controller level or on the model level:

#### Controller level example:
	class PostsController < ApplicationController
		include provision

		def create
			# create the post
		end

		provision :create, :with => UserProvision do |controller|
			controller.flash[:error] = "You have maxed out your posts"
			redirect_to some_url
		end
	end

	class UserProvision
		def self.provision!(controller)
			controller.current_user.post_count < MAX_POSTS
		end
	end

#### Model level example:
	class Post < ActiveRecord::Base
		include provision

		provision :save, :valid?, :with => lambda{ |post| post.user.post_count < MAX_COUNT } do |post|
			post.errors[:count] = "you have maxed out you post count"
			false
		end
	end

## GOTCHA!
`provision` call **must** come **after** your provisioned method definitions


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
