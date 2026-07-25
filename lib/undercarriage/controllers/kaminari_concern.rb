# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    ##
    # Kaminari pagination
    #
    # Helpers for Kaminari style pagination. Note that the Kaminari gem is not loaded with dependency. It must be added
    # to your own Gemfile
    #
    # @example Controller
    #   class ExamplesController < ApplicationController
    #     include Undercarriage::Controllers::KaminariConcern
    #
    #     def index
    #       @examples = Examples.page(page_num).per(per_page)
    #     end
    #   end
    module KaminariConcern
      extend ActiveSupport::Concern

      included do
        helper_method :page_num, :per_page
      end

      ##
      # Items per page
      #
      # The number of items to return in pagination. Will use the Kaminari config `default_per_page` (typically `25`)
      # for the count and will look for `per` in the URL paramaters to override.
      #
      # This is asseccible from the View as `per_page`
      #
      # @return [Integer] the number of items per page
      #
      # @example Request
      #   # GET /examples?per=100 # Return 100 items per page
      #   # GET /examples?per=10&page=3 # Return page 3 of items with 10 items per page
      def per_page
        params.fetch(per_page_key, per_page_default).to_i
      end

      ##
      # Page number
      #
      # Will look for the Kaminari config `param_name` (typically `page`) in the URL paramaters.
      #
      # This is asseccible from the View as `page_num`
      #
      # @return [Integer] the page number
      #
      # @example Request
      #   # GET /examples?page=5 # Return page 5 of items
      #   # GET /examples?per=10&page=3 # Return page 3 of items with 10 items per page
      def page_num
        params.fetch(page_num_key, page_num_default).to_i
      end

      protected

      ##
      # Items per page key
      #
      # Query param to be used to identify count to be returned
      #
      # @return [Integer] per page count
      def per_page_key
        :per
      end

      ##
      # Page numberkey
      #
      # Query param to be used to identify page offset
      #
      # @return [String,Symbol] page number key
      def page_num_key
        Kaminari.config.param_name
      end

      private

      ##
      # Items per page default
      #
      # Fallback used when the `per` query param is absent.
      #
      # @return [Integer] default per page count
      def per_page_default
        Kaminari.config.default_per_page
      end

      ##
      # Page number default
      #
      # Fallback used when the page query param is absent.
      #
      # @return [Integer] default page number
      def page_num_default
        1
      end
    end
  end
end
