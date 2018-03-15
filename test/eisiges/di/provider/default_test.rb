require 'test_helper'

class ServiceObject
	shareable :my_scope

	def get_status
		"status: green"
	end
end

class DiExample
	#include Eisiges::DI::Core #covered by automatic mixin

	inject klasse: ServiceObject, as: :so

	def run_me
		@so.get_status
	end
end

class ThirdPartyLib
	def initialize(so)
		@so = so
	end
end

class ThirdPartyWithHash
	def initialize(di_example:, third_party:)
		@di_example = di_example
		@third_party = third_party
	end
end

class Providers
	# provider method which accepts a hash
	provides ThirdPartyLib, dependencies: {so: ServiceObject} do |so:|
		ThirdPartyLib.new(so)
	end

	# constructor which accepts a hash
	provides ThirdPartyWithHash, dependencies: {di_example: DiExample, third_party: ThirdPartyLib}
end


class Eisiges::DI::Provider::DefaultTest < Minitest::Test
	def test__that_it_has_a_version_number
		refute_nil ::Eisiges::DI::Provider::Default::VERSION
	end

	def test__it_does_something_useful
		de = Eisiges::DI::Pool.get(DiExample)
		refute_nil de
		assert_equal 'status: green', de.run_me
	end

	def test__it_can_use_providers
		thirdPartyWithHash = Eisiges::DI::Pool.get(ThirdPartyWithHash)
		refute_nil thirdPartyWithHash

		thirdParty = Eisiges::DI::Pool.get(ThirdPartyLib)
		refute_nil thirdParty
	end
end

