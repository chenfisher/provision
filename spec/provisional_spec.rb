require 'spec_helper'
require 'provisional/sample'

describe Provisional do

	before :each do
		@sample = Sample.new
		@sample.stub(:a_method).and_return('hello')
		@meta = class << @sample; self; end
	end

	it "should call the method if provision returns true" do
		@sample.stub(:this_method).and_return(true)
		@meta.provision :a_method, :with => :this_method

		@sample.a_method.should eq 'hello'
	end

	it "should provision a method using a method name" do
		@sample.stub(:this_method).and_return(false)
		@meta.provision :a_method, :with => :this_method

		@sample.a_method.should_not eq 'hello'
	end

	it "should provision a method using a class name" do
		class ThisClass; 
			def provision!(sender)
				false
			end
		end
		
		@meta.provision :a_method, :with => ThisClass

		@sample.a_method.should_not eq 'hello'
	end

	it "should provision a method using a class name with class method provision!" do
		class ThisClass; 
			def self.provision!(sender)
				false
			end
		end
		
		@meta.provision :a_method, :with => ThisClass

		@sample.a_method.should_not eq 'hello'
	end

	it "should provision a method using an instance of a class" do
		class ThisClass; end
		@instance = ThisClass.new
		@instance.stub(:provision!).and_return false
		@instance.should_receive(:provision!)
		
		@meta.provision :a_method, :with => @instance

		@sample.a_method.should_not eq 'hello'
	end

	it "should provision a method using an instance of a class (from a proc)" do
		class ThisClass; end
		ThisClass.any_instance.stub(:provision!).and_return false
		ThisClass.any_instance.should_receive(:provision!)
		
		@meta.provision :a_method, :with => lambda{ ThisClass.new }

		@sample.a_method.should_not eq 'hello'
	end

	it "should provision a method using a proc" do
		@meta.provision :a_method, :with => lambda{ false }

		@sample.a_method.should_not eq 'hello'
	end

	it "should takea proc with arguments" do
		@meta.provision :a_method, :with => lambda{ |sender, p| sender === @sample && p == 'p' }

		@sample.a_method('p').should eq 'hello'
	end

	it "should take an array of methods to provision" do
		@sample.stub(:b_method).and_return('hello')
		@meta.provision :a_method, :b_method, :with => lambda{ false }

		@sample.a_method.should_not eq 'hello'
		@sample.b_method.should_not eq 'hello'
	end

	it "should take a block as an action when provision fails" do
		@meta.provision :a_method, :with => lambda{ false } do
			'hi there'
		end

		@sample.a_method.should eq 'hi there'
	end

end