require "eisiges/di/provider/default/version"

module Eisiges
	module DI
		module Provider
			module Default
				def self.get(klasse, current_pool={})
					current_pool[klasse] = create_instance(klasse, current_pool) if current_pool[klasse].nil?
					return perform_injection(current_pool[klasse], current_pool)
				end

				def self.create_instance(klasse, current_pool={})
					return klasse.new unless klasse.has_provider?
					
					depList = {}
					#iterate over providers
					klasse.provider[:dependencies].each do |varName, klasse|
							depList[varName.to_sym] = get(klasse, current_pool)
					end

					return klasse.new(depList) if klasse.provider[:block].nil?

					return klasse.provider[:block].call(depList)
				end

				# Perform injection on an instance of a class first using the current_pool which has been provided
				def self.perform_injection(instance, current_pool={})
					return instance if (defined? instance.class.dependencies) == nil
					instance.class.dependencies&.each do |varName, klasse|
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

