module PrivatePlease

  module Instrumentor

    def self.instrument_instance_methods_for_pp_observation(klass, methods_to_observe)
      class_instance_methods = klass.instance_methods.collect(&:to_sym)
      methods_to_observe = methods_to_observe.collect(&:to_sym)
      # reject invalid methods names
      methods_to_observe.reject! do |m|
        already_defined_instance_method = class_instance_methods.include?(m)
        invalid = !already_defined_instance_method
      end

      methods_to_observe.each do |method_name|
        candidate = Candidate.for_instance_method(klass, method_name)
        instrument_candidate_for_pp_observation(candidate, true) # end
      end
    end


    def self.instrument_candidate_for_pp_observation(candidate, check_for_dupe)
      instrument_instance_method_for_pp_observation(candidate, check_for_dupe) # end
    end



    def self.instrument_instance_method_for_pp_observation(candidate, check_for_dupe=true)
      klass, method_name =  candidate.klass, candidate.method_name
      if check_for_dupe
        # to avoid instrumenting the method we are dynamically redefining below
        return if PrivatePlease.already_instrumented?(candidate)
      end

      PrivatePlease.record_candidate(candidate)

      orig_method = klass.instance_method(method_name)
klass.class_eval <<RUBY
      define_method(method_name) do |*args, &blk|                           # def observed_method_i(..)
        set_trace_func(nil) #don't track activity while here                #
                                                                            #
        if PrivatePlease.active?                                            #
          candidate = PrivatePlease::Candidate.for_instance_method(self.class, method_name)
          LineChangeTracker.outside_call_detected?(self) ?                  #
              PrivatePlease.record_outside_call(candidate) :                #
              PrivatePlease.record_inside_call( candidate)                  #
        end                                                                 #
                                                                            #
        set_trace_func(LineChangeTracker::MY_TRACE_FUN)                     #
        # make the call :                                                   #
        orig_method.bind(self).call(*args, &blk)                            #   <call original method>
      end                                                                   # end
RUBY
    end
    private_class_method :instrument_instance_method_for_pp_observation

  end

end
