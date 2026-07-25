# frozen_string_literal: true

# :nodoc:
module Undercarriage
  # :nodoc:
  module Controllers
    ##
    # Action helpers
    #
    # Helpers for the controller or view to help identify the action
    #
    # @example Controller
    #   class ExamplesController < ApplicationController
    #     include Undercarriage::Controllers::ActionConcern
    #   end
    module ActionConcern
      extend ActiveSupport::Concern

      included do
        helper_method :action?,
                      :collection_action?,
                      :create_action?,
                      :create_actions?,
                      :destroy_action?,
                      :edit_action?,
                      :edit_actions?,
                      :index_action?,
                      :member_action?,
                      :new_action?,
                      :new_actions?,
                      :show_action?,
                      :update_action?,
                      :update_actions?
      end

      ##
      # Check action
      #
      # Check if action is a certain action type
      #
      # @param action_method [String, Symbol] the action to test
      # @return [Boolean] if action matches
      #
      # @example View
      #   action?(:show) # true
      #   action?("show") # true
      #   action?(:index) # false
      def action?(action_method)
        action == action_method.to_sym
      end

      ##
      # Check if index
      #
      # Check if action is the index action type. The check will pass if it is an `index` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   index_action? # true
      #   index_action? # false
      def index_action?
        action?("index")
      end

      ##
      # Check if show
      #
      # Check if action is the show action type. The check will pass if it is a `show` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   show_action? # true
      #   show_action? # false
      def show_action?
        action?("show")
      end

      ##
      # Check if new
      #
      # Check if action is the new action type. The check will pass if it is a `new` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   new_action? # true
      #   new_action? # false
      def new_action?
        action?("new")
      end

      ##
      # Check if create
      #
      # Check if action is the create action type. The check will pass if it is a `create` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   create_action? # true
      #   create_action? # false
      def create_action?
        action?("create")
      end

      ##
      # Check if edit
      #
      # Check if action is the edit action type. The check will pass if it is an `edit` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   edit_action? # true
      #   edit_action? # false
      def edit_action?
        action?("edit")
      end

      ##
      # Check if update
      #
      # Check if action is the update action type. The check will pass if it is an `update` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   update_action? # true
      #   update_action? # false
      def update_action?
        action?("update")
      end

      ##
      # Check if destroy
      #
      # Check if action is the destroy action type. The check will pass if it is a `destroy` action
      #
      # @return [Boolean] if action is action type
      #
      # @example View
      #   destroy_action? # true
      #   destroy_action? # false
      def destroy_action?
        action?("destroy")
      end

      ##
      # Check if collection
      #
      # Check if action is a collection action type. An action is a collection type if it is the `index` action
      #
      # @return [Boolean] if action is collection type
      #
      # @example View
      #   collection_action? # true
      #   collection_action? # false
      def collection_action?
        collection_actions.include?(action)
      end

      ##
      # Check if create or new
      #
      # Check if action is a create or new action type. The check will pass if it is a `create` or `new` action
      #
      # @return [Boolean] if action is actions type
      #
      # @example View create
      #   create_actions? # true
      #   create_actions? # false
      # @example View new
      #   new_actions? # true
      #   new_actions? # false
      def create_actions?
        create_actions.include?(action)
      end
      alias new_actions? create_actions?

      ##
      # Check if member
      #
      # Check if action is a member action type. An action is a member type if it is the `edit`, `show`, or `update`
      # action
      #
      # @return [Boolean] if action is member type
      #
      # @example View
      #   member_action? # true
      #   member_action? # false
      def member_action?
        member_actions.include?(action)
      end

      ##
      # Check if edit or update
      #
      # Check if action is an edit or update action type. The check will pass if it is an `edit` or `update` action
      #
      # @return [Boolean] if action is actions type
      #
      # @example View update
      #   update_actions? # true
      #   update_actions? # false
      # @example View edit
      #   edit_actions? # true
      #   edit_actions? # false
      def update_actions?
        update_actions.include?(action)
      end
      alias edit_actions? update_actions?

      protected

      ##
      # Action symbol
      #
      # Take `action_name` (string) and turn it into a symbol
      #
      # @return [Symbol] action_name as a symbol
      def action
        action_name.to_sym
      end

      ##
      # Collection actions
      #
      # @return [Array] collection actions
      def collection_actions
        %i[index]
      end

      ##
      # Member actions
      #
      # @return [Array] member actions
      def member_actions
        %i[edit show update]
      end

      ##
      # Create actions
      #
      # @return [Array] create actions
      def create_actions
        %i[create new]
      end

      ##
      # Update actions
      #
      # @return [Array] update actions
      def update_actions
        %i[edit update]
      end
    end
  end
end
