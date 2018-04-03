require 'test_helper'

class Eisiges::DI::Provider::DefaultTest < Minitest::Test
	def test__that_it_has_a_version_number
		refute_nil ::Eisiges::DI::Provider::Default::VERSION
	end

	def test__it_does_something_useful
		de = Eisiges::DI::Pool.get(DiExample)
		refute_nil de
		assert_equal 'status: green', de.run_me
	end

	def test__perform_injection
		de = DiExample.new
		Eisiges::DI::Pool.perform_injection(de)
		assert_equal 'status: green', de.run_me
	end

	def test__it_can_use_providers
		thirdPartyWithHash = Eisiges::DI::Pool.get(ThirdPartyWithHash)
		refute_nil thirdPartyWithHash

		thirdParty = Eisiges::DI::Pool.get(ThirdPartyLib)
		refute_nil thirdParty
	end
end

