require "eisiges/di/provider/default/version"

module Eisiges
	module DI
		module Provider
			module Default
				#@@instances: {}

				#just do :global injection for now since the rest will be rails specific. Maybe just introduce rails provider?
				def self.register_object(klasse, instance=nil)
					return if instance.nil?
					return if klasse.shareable?.nil?
					return if klasse.shareable? == :once
					return if klasse.shareable? == :never

					unless klasse.shareable? == false
						(@@instances ||= {})[klasse] = instance
					end
				end

				def self.get(klasse, current_pool={})
					current_pool[klasse] = klasse.new if current_pool[klasse].nil?
					return perform_injection(current_pool[klasse], current_pool)
				end

				# Perform injection on an instance of a class first using the current_pool which has been provided
				def self.perform_injection(instance, current_pool={})
					return instance if (defined? instance.class.dependencies) == nil
					instance.class.dependencies.each do |varName, klasse|
						injection_subject = get(klasse, current_pool)

						instance.instance_variable_set("@#{varName}", injection_subject) # actual moment that injection occurs
					end

					return instance
					#register instance to resolve circular dependencies?
				end
			end
		end
	end
end

Eisiges::DI::Pool = Eisiges::DI::Provider::Default

