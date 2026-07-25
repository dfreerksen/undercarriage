# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Index restful action
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::IndexConcern
        #   end
        module IndexConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :index_resources, only: %i[index]
          end

          ##
          # Index action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@index_resources` or `@examples`
          #     #
          #     # def index
          #     #   ...
          #     # end
          #   end
          def index; end

          protected

          ##
          # Index restful action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@examples`
          #     #
          #     # def resources_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def resources_content
          #     #   super
          #     #
          #     #   authorize @examples
          #     # end
          #   end
          def resources_content
            resources_query = resource_scope.all

            instance_variable_set("@#{instances_name}", resources_query)
          end

          private

          ##
          # Index resources before_action callback
          #
          # Memoizes the resource collection into `@index_resources` ahead of the `index` action.
          #
          # @return [Object] the resource collection
          def index_resources
            @index_resources ||= resources_content
          end
        end
      end
    end
  end
end
