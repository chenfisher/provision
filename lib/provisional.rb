require "provisional/version"

module Provisional
	module ClassMethods

		##
		# 
		def provision(*args, &block)
			options = args.last.is_a?(::Hash) ? args.pop : {}

			hook(*args, :before => options[:with], &block)
		end

		##
		# hooks the specified array of methods to a method specified with the :before hook
		# calls the original method only if the hooked method returns true
		# usage:
		# 	hook :method1, :method2, :before => :method_name
		def hook(*args, &block)
			hooks = args.last.is_a?(::Hash) ? args.pop : {}

			args.each do |method|
				original_method = self.instance_method(method)

				self.send(:define_method, method) do |*a|
					return original_method.bind(self).call(*a) if 
						case
						when hooks[:before].is_a?(Symbol)
							hook_method(hooks[:before], *a)
						when hooks[:before].is_a?(Class)
							hook_class(hooks[:before], *a)
						when hooks[:before].is_a?(Proc)
							hook_proc(hooks[:before], *a)
						when hooks[:before].instance_of?(hooks[:before].class)
							hook_instance(hooks[:before], *a)
						end

 					if block_given?
						if block.arity == 0
							return yield
						else
							return yield(self, *a)
						end
					end

					false
				end
			end
		end

		private :hook
	end
	
	module InstanceMethods
		def hook_method(h, *a)
			self.send(h, *a)
		end

		def hook_class(h, *a)
			if h.respond_to? :provision!
				h.provision!(self, *a)
			else
				h.new.provision!(self, *a)
			end
		end

		def hook_instance(h, *a)
			h.provision!(self, *a)
		end

		def hook_proc(h, *a)
			# call the proc
			if h.arity == 0
				result = h.call
			else
				result = h.call(self, *a)
			end

			# if proc returns true or false then return the result
			return result if result == true || result == false
			
			# if proc returns an instance of an object then call provision! on it
			result.provision!(*a)
		end

		private :hook_method, :hook_class, :hook_instance, :hook_proc
		
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end