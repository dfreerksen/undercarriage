# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    ##
    # Restful actions
    #
    # Usage
    #   class ExamplesController < ApplicationController
    #     include Undercarriage::Controllers::RestfulConcern
    #   end
    #
    module RestfulConcern
      extend ActiveSupport::Concern

      included do
        include Undercarriage::Controllers::Restful::LocationAfterConcern
        include Undercarriage::Controllers::Restful::NamespaceConcern
        include Undercarriage::Controllers::Restful::PermittedAttributesConcern
        include Undercarriage::Controllers::Restful::UtilityConcern
        include Undercarriage::Controllers::Restful::Actions::BaseConcern
        include Undercarriage::Controllers::Restful::Actions::IndexConcern
        include Undercarriage::Controllers::Restful::Actions::ShowConcern
        include Undercarriage::Controllers::Restful::Actions::NewConcern
        include Undercarriage::Controllers::Restful::Actions::CreateConcern
        include Undercarriage::Controllers::Restful::Actions::EditConcern
        include Undercarriage::Controllers::Restful::Actions::UpdateConcern
        include Undercarriage::Controllers::Restful::Actions::DestroyConcern
      end
    end
  end
end
