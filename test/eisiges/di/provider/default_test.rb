require 'test_helper'

class ServiceObject
	def get_status
		"status: green"
	end
end

class DiExample
	include Eisiges::DI::Core

	inject klasse: ServiceObject, as: :so

	def run_me
		@so.get_status
	end
end

class Eisiges::DI::Provider::DefaultTest < Minitest::Test
	def test_that_it_has_a_version_number
		refute_nil ::Eisiges::DI::Provider::Default::VERSION
	end

	def test_it_does_something_useful
		de = Eisiges::DI::Pool.get(DiExample)
		refute_nil de
		assert_equal 'status: green', de.run_me
	end
end
