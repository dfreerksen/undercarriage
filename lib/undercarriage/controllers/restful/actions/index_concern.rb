# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module Actions
        ##
        # Index restful action
        #
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module IndexConcern
          extend ActiveSupport::Concern

          included do
            before_action :index_resources, only: %i[index]
          end

          ##
          # Index action
          #
          # Usage
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
          #
          def index
            respond_with(@index_resources) do |format|
              format.html { render layout: !request.xhr? }
              format.json { render layout: false }
            end
          end

          protected

          ##
          # Index restful action
          #
          # Usage
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
          #
          def resources_content
            resources_query = model_class.all

            instance_variable_set("@#{instances_name}", resources_query)
          end

          private

          def index_resources
            @index_resources ||= resources_content
          end
        end
      end
    end
  end
end
