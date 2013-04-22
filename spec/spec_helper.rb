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

module MarkingTest    ; end
module ReportingTest  ; end
module CallingTest    ; end
module ConfigTest     ; end

def assert_candidates(expected)
  PrivatePlease.storage.candidates.should == expected
end

def assert_calls_detected(expected)
  { :inside   => PrivatePlease.storage.inside_called_candidates,
    :outside  => PrivatePlease.storage.outside_called_candidates
  }.should == expected
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
