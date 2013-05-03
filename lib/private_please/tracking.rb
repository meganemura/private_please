require 'private_please/tracking/line_change_tracker'
module PrivatePlease
  module Tracking

    class << self

      def after_instance_method_call(method_name, zelf_class)
        store_call_to_tracked_method(
          candidate       = PrivatePlease::Candidate.for_instance_method(zelf_class, method_name), 
          is_outside_call = (caller_class != zelf_class)
        )
      end
    
      def after_singleton_method_call(method_name, zelf_class)
        store_call_to_tracked_method(
          candidate       = PrivatePlease::Candidate.for_class_method(zelf_class, method_name), 
          is_outside_call = (caller_class != zelf_class)
        )
      end

    private      

      def caller_class
        call_initiator = LineChangeTracker.call_initiator
        if call_initiator.nil?
          #TODO : investigate why and how this happens
        end
        (caller_is_class_method = call_initiator.is_a?(Class)) ?
            call_initiator :
            call_initiator.class
      end

      def store_call_to_tracked_method(candidate, is_outside_call)
        is_outside_call ?
            PrivatePlease.calls_store.store_outside_call(candidate) :
            PrivatePlease.calls_store.store_inside_call( candidate)
      end
      
    end

  end 
end

require 'private_please/tracking/utils'
require 'private_please/tracking/instrumentor'
require 'private_please/tracking/extension'
require 'private_please/tracking/instruments_all_methods_below'
require 'private_please/tracking/instruments_automatically_all_methods_in_all_classes'