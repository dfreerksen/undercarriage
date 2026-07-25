# frozen_string_literal: true

require "rails_helper"

# Undercarriage::Controllers::ActionConcern's predicates only depend on `action_name`, so this is
# tested in isolation against a bare class rather than through the dummy app's controllers/routes.
RSpec.describe Undercarriage::Controllers::ActionConcern do
  subject(:instance) { dummy_class.new }

  let(:dummy_class) do
    Class.new do
      def self.helper_method(*names)
        (@helper_methods ||= []).concat(names)
      end

      class << self
        attr_reader :helper_methods
      end

      include Undercarriage::Controllers::ActionConcern

      attr_writer :action_name

      attr_reader :action_name
    end
  end

  describe "included hook" do
    it "exposes every predicate as a helper_method" do
      expect(dummy_class.helper_methods).to contain_exactly(
        :action?, :collection_action?, :create_action?, :create_actions?, :destroy_action?, :edit_action?,
        :edit_actions?, :index_action?, :member_action?, :new_action?, :new_actions?, :show_action?,
        :update_action?, :update_actions?
      )
    end
  end

  describe "#action?" do
    before { instance.action_name = "show" }

    it "matches the current action by symbol" do
      expect(instance.action?(:show)).to be(true)
    end

    it "matches the current action by string" do
      expect(instance.action?("show")).to be(true)
    end

    it "does not match a different action" do
      expect(instance.action?(:index)).to be(false)
    end
  end

  # Truth table for every predicate across every REST action, plus a non-REST action name to prove
  # nothing matches by accident.
  {
    "index" => { index: true, show: false, new: false, create: false, edit: false, update: false, destroy: false,
                 collection: true, member: false, create_actions: false, update_actions: false },
    "show" => { index: false, show: true, new: false, create: false, edit: false, update: false, destroy: false,
                collection: false, member: true, create_actions: false, update_actions: false },
    "new" => { index: false, show: false, new: true, create: false, edit: false, update: false, destroy: false,
               collection: false, member: false, create_actions: true, update_actions: false },
    "create" => { index: false, show: false, new: false, create: true, edit: false, update: false, destroy: false,
                  collection: false, member: false, create_actions: true, update_actions: false },
    "edit" => { index: false, show: false, new: false, create: false, edit: true, update: false, destroy: false,
                collection: false, member: true, create_actions: false, update_actions: true },
    "update" => { index: false, show: false, new: false, create: false, edit: false, update: true, destroy: false,
                  collection: false, member: true, create_actions: false, update_actions: true },
    "destroy" => { index: false, show: false, new: false, create: false, edit: false, update: false, destroy: true,
                   collection: false, member: false, create_actions: false, update_actions: false },
    "publish" => { index: false, show: false, new: false, create: false, edit: false, update: false, destroy: false,
                   collection: false, member: false, create_actions: false, update_actions: false }
  }.each do |action_name, expected|
    context "when action_name is `#{action_name}`" do
      before { instance.action_name = action_name }

      it "reports every predicate correctly" do
        aggregate_failures do
          expect(instance.index_action?).to be(expected[:index])
          expect(instance.show_action?).to be(expected[:show])
          expect(instance.new_action?).to be(expected[:new])
          expect(instance.create_action?).to be(expected[:create])
          expect(instance.edit_action?).to be(expected[:edit])
          expect(instance.update_action?).to be(expected[:update])
          expect(instance.destroy_action?).to be(expected[:destroy])
          expect(instance.collection_action?).to be(expected[:collection])
          expect(instance.member_action?).to be(expected[:member])
          expect(instance.create_actions?).to be(expected[:create_actions])
          expect(instance.new_actions?).to be(expected[:create_actions])
          expect(instance.update_actions?).to be(expected[:update_actions])
          expect(instance.edit_actions?).to be(expected[:update_actions])
        end
      end
    end
  end
end
