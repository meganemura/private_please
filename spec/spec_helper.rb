# This file was (originally) generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

module PrivatePlease
  def self.reset_before_new_test
    PrivatePlease .reset_before_new_test
  end
end


def assert_instance_methods_candidates(expected)
  cs = PrivatePlease.storage.candidates_db.instance_methods
  cs.each_pair { |k, v| cs[k] = v.to_a.sort_by(&:to_s) }
  cs.should == expected
end

def assert_class_methods_candidates(expected)
  cs = PrivatePlease.storage.candidates_db.class_methods
  cs.each_pair { |k, v| cs[k] = v.to_a.sort_by(&:to_s) }
  cs.should == expected
end

def assert_calls_detected(expected)
  calls_db = PrivatePlease.storage.calls_log
  { :inside    => calls_db.internal_calls,
    :inside_c  => calls_db.class_internal_calls,
    :outside   => calls_db.external_calls,
    :outside_c => calls_db.class_external_calls
  }.should == expected
end

NO_CALLS_OBSERVED = {}

def assert_no_calls_detected
  assert_calls_detected :inside   => NO_CALLS_OBSERVED, :outside   => NO_CALLS_OBSERVED,
                        :inside_c => NO_CALLS_OBSERVED, :outside_c => NO_CALLS_OBSERVED
end

def mnames_for(args)
  PrivatePlease::MethodsNames.new(Array(args))
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:each) do
    PrivatePlease.reset_before_new_test
  end
end

require File.dirname(__FILE__) + '/../lib/private_please'
