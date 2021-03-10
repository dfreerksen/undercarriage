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
    # Usage
    #   # Model
    #   class Example < ApplicationRecord
    #     include Undercarriage::Models::PublishedConcern
    #
    #     ##
    #     # The name of the column is expected to be `published_at`. If that is not the case for you, uncomment the
    #     # following to change the column name
    #     #
    #     # self.published_column = :ready_at
    #
    #     ##
    #     # The following are useful helpers for the model. They are not part of the concern
    #     #
    #     scope :available, -> { published.where("#{published_column} <= ?", Time.current) }
    #
    #     def available?
    #       published? && self[published_column] <= Time.current
    #     end
    #
    #     scope :scheduled, -> { published.where("#{published_column} > ?", , Time.current) }
    #
    #     def scheduled?
    #       published? && self[published_column] > Time.current
    #     end
    #   end
    #
    #   # Controller
    #   class PagesController < AdminController
    #     def index
    #       @examples = Example.published
    #     end
    #   end
    #
    #   # View
    #   <% @examples.each do |example| %>
    #     Published?: <%= example.published? %>
    #   <% end %>
    #
    module PublishedConcern
      extend ActiveSupport::Concern

      included do
        class_attribute :published_column
        self.published_column = :published_at

        ##
        # Published scope
        #
        # Retrieve only published resources
        #
        # Usage
        #   class PagesController < AdminController
        #     def index
        #       @examples = Example.published
        #     end
        #   end
        #
        scope :published, -> { where.not(published_column => nil) }

        ##
        # Unpublished scope
        #
        # Retrieve only unpublished resources
        #
        # Usage
        #   class PagesController < AdminController
        #     def index
        #       @examples = Example.unpublished
        #     end
        #   end
        #
        scope :unpublished, -> { where(published_column => nil) }
      end

      ##
      # Published check
      #
      # Check if an item is published based on the presence of a value in the published column. This does not take into
      # account whether the item is not currently available (scheduled). See module documentation for more information
      #
      # Usage
      #   @example.published? => true
      #   @example.published? => false
      #
      # @return [Boolean] if resource is published
      #
      def published?
        self[self.class.published_column].present?
      end

      ##
      # Unpublished check
      #
      # Check if an item is unpublished based on the lack of presence of a value in the published column
      #
      # Usage
      #   @example.unpublished? => true
      #   @example.unpublished? => false
      #
      # @return [Boolean] if resource is unpublished
      #
      def unpublished?
        !published?
      end
    end
  end
end
