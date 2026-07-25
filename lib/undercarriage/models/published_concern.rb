# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Models
    ##
    # Published
    #
    # Based on the presence of a datetime in the `published_at` column (configurable) in the database. If there is a
    # datetime in the column, it is considered published. You need to do your own validation to ensure the value is a
    # datetime value
    #
    # @example Model
    #   class Example < ApplicationRecord
    #     include Undercarriage::Models::PublishedConcern
    #
    #     ##
    #     # The name of the column is expected to be `published_at`. If that is not the case for you, uncomment the
    #     # following to change the column name
    #     # self.published_column = :ready_at
    #
    #     ##
    #     # The following are useful helpers for the model. They are not part of the concern
    #     scope :available, -> { published.where("#{published_column} <= ?", Time.current) }
    #
    #     def available?
    #       published? && self[published_column] <= Time.current
    #     end
    #
    #     scope :scheduled, -> { published.where("#{published_column} > ?", Time.current) }
    #
    #     def scheduled?
    #       published? && self[published_column] > Time.current
    #     end
    #   end
    #
    # @example Controller
    #   class ExamplesController < ApplicationController
    #     def index
    #       @examples = Example.published
    #     end
    #   end
    #
    # @example View
    #   # <% @examples.each do |example| %>
    #   #   Published?: <%= example.published? %>
    #   # <% end %>
    module PublishedConcern
      extend ActiveSupport::Concern

      ##
      # @!method self.published
      #   Published scope
      #
      #   Retrieve only published resources
      #
      #   @return [ActiveRecord::Relation] published resources
      #
      #   @example Controller
      #     class ExamplesController < ApplicationController
      #       def index
      #         @examples = Example.published
      #       end
      #     end

      ##
      # @!method self.unpublished
      #   Unpublished scope
      #
      #   Retrieve only unpublished resources
      #
      #   @return [ActiveRecord::Relation] unpublished resources
      #
      #   @example Controller
      #     class ExamplesController < ApplicationController
      #       def index
      #         @examples = Example.unpublished
      #       end
      #     end
      included do
        class_attribute :published_column
        self.published_column = :published_at

        scope :published, -> { where.not(published_column => nil) }
        scope :unpublished, -> { where(published_column => nil) }
      end

      ##
      # Published check
      #
      # Check if an item is published based on the presence of a value in the published column. This does not take into
      # account whether the item is not currently available (scheduled). See module documentation for more information
      #
      # @return [Boolean] if resource is published
      #
      # @example Controller or View
      #   @example.published? => true
      #   @example.published? => false
      def published?
        self[self.class.published_column].present?
      end

      ##
      # Unpublished check
      #
      # Check if an item is unpublished based on the lack of presence of a value in the published column
      #
      # @return [Boolean] if resource is unpublished
      #
      # @example Controller or View
      #   @example.unpublished? => true
      #   @example.unpublished? => false
      def unpublished?
        !published?
      end
    end
  end
end
