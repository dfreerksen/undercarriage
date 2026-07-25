# frozen_string_literal: true

require "rails_helper"

# spec/requests/posts_spec.rb and spec/requests/admin/posts_spec.rb prove two tiers of the i18n
# fallback chain end-to-end (the hardcoded default, and the namespaced tier winning over it). This
# tests the full ordered chain directly, isolated from HTTP. Each example uses a distinct fake
# controller name to avoid cross-example key collisions, but the generic `flash.actions.*` tier
# isn't controller-scoped by design, so I18n.backend.reload! after every example discards anything
# store_translations added (resetting to the on-disk locale files) rather than letting it leak.
RSpec.describe Undercarriage::Controllers::Restful::FlashConcern do
  subject(:instance) do
    dummy_class.new.tap do |i|
      i.controller_name = controller_name
      i.resource_namespace = namespace
    end
  end

  after { I18n.backend.reload! }

  let(:dummy_class) do
    Class.new do
      include Undercarriage::Controllers::Restful::FlashConcern

      attr_accessor :controller_name, :resource_namespace

      def controller_name_singular
        controller_name.singularize
      end

      def controller_name_singular_title
        controller_name_singular.titleize
      end
    end
  end
  let(:namespace) { nil }

  describe "#flash_status_type" do
    it "defaults to :success" do
      expect(dummy_class.flash_status_type).to eq(:success)
    end

    it "is configurable per including class" do
      dummy_class.flash_status_type = :notice

      expect(dummy_class.flash_status_type).to eq(:notice)
    end
  end

  describe "the i18n fallback chain (via #flash_created_message)" do
    context "with no matching translation anywhere" do
      let(:controller_name) { "gadgets" }

      it "falls back to the hardcoded English default" do
        expect(instance.send(:flash_created_message)).to eq("Gadget was successfully created.")
      end
    end

    context "with only the generic flash.actions.create.success translation" do
      let(:controller_name) { "gizmos" }

      before { I18n.backend.store_translations(:en, flash: { actions: { create: { success: "Generic!" } } }) }

      it "uses the generic tier" do
        expect(instance.send(:flash_created_message)).to eq("Generic!")
      end
    end

    context "with both the generic and the controller-specific translation" do
      let(:controller_name) { "doodads" }

      before do
        I18n.backend.store_translations(:en, flash: {
                                          actions: { create: { success: "Generic!" } },
                                          doodads: { create: { success: "Doodad specific!" } }
                                        })
      end

      it "prefers the controller-specific tier over the generic one" do
        expect(instance.send(:flash_created_message)).to eq("Doodad specific!")
      end
    end

    context "with both the plain and the _html controller-specific translation" do
      let(:controller_name) { "widgets" }

      before do
        I18n.backend.store_translations(:en, flash: { widgets: {
                                          create: { success: "Plain widget!", success_html: "<b>Widget!</b>" }
                                        } })
      end

      it "prefers the _html tier over the plain one" do
        expect(instance.send(:flash_created_message)).to eq("<b>Widget!</b>")
      end
    end

    context "with both a namespaced and a non-namespaced controller-specific translation" do
      let(:controller_name) { "sprockets" }
      let(:namespace) { "admin" }

      before do
        I18n.backend.store_translations(:en, flash: {
                                          sprockets: { create: { success: "Top-level sprocket!" } },
                                          admin: { sprockets: { create: { success: "Admin sprocket!" } } }
                                        })
      end

      it "prefers the namespaced tier over the non-namespaced controller tier" do
        expect(instance.send(:flash_created_message)).to eq("Admin sprocket!")
      end
    end

    context "with both plain and _html namespaced translations" do
      let(:controller_name) { "trinkets" }
      let(:namespace) { "admin" }

      before do
        I18n.backend.store_translations(:en, flash: { admin: { trinkets: {
                                          create: { success: "Plain admin trinket!", success_html: "<b>Admin!</b>" }
                                        } } })
      end

      it "prefers the namespaced _html tier over every other tier" do
        expect(instance.send(:flash_created_message)).to eq("<b>Admin!</b>")
      end
    end
  end

  describe "#flash_updated_message / #flash_destroyed_message" do
    let(:controller_name) { "cogs" }

    it "builds the updated message with the right action word" do
      expect(instance.send(:flash_updated_message)).to eq("Cog was successfully updated.")
    end

    it "builds the destroyed message with the right action word" do
      expect(instance.send(:flash_destroyed_message)).to eq("Cog was successfully destroyed.")
    end
  end
end
