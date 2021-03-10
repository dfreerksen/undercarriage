# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      ##
      # Namespace
      #
      # Usage
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::Restful::NamespaceConcern
      #   end
      #
      module NamespaceConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Resource namespace
        #
        # Best guess for namespace. Take `controller_path` and if there is more than one segment, assume the first is
        # the namespace. When there is one segment, the namespace is `nil`
        #
        # Example
        #   # Override method that builds namespace
        #   def resource_namespace
        #     :admin
        #   end
        #
        def resource_namespace
          segments = controller_path.split('/')

          segments.length > 1 ? segments.first : nil
        end
      end
    end
  end
end
