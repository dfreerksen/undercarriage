# frozen_string_literal: true

require "rails_helper"

# spec/requests/admin/posts_spec.rb proves the single-namespace case (`admin/posts`) end-to-end.
# This tests #resource_namespace's segment-parsing directly, including a deeper-nested path that
# isn't exercised by any dummy app route.
RSpec.describe Undercarriage::Controllers::Restful::NamespaceConcern do
  subject(:instance) { dummy_class.new.tap { |i| i.controller_path = controller_path } }

  let(:dummy_class) do
    Class.new do
      include Undercarriage::Controllers::Restful::NamespaceConcern

      attr_accessor :controller_path
    end
  end

  describe "#resource_namespace" do
    context "with a single-segment controller_path" do
      let(:controller_path) { "posts" }

      it "is nil" do
        expect(instance.send(:resource_namespace)).to be_nil
      end
    end

    context "with a namespaced controller_path" do
      let(:controller_path) { "admin/posts" }

      it "returns the first segment" do
        expect(instance.send(:resource_namespace)).to eq("admin")
      end
    end

    context "with a deeply nested controller_path" do
      let(:controller_path) { "admin/reports/posts" }

      it "returns only the first segment" do
        expect(instance.send(:resource_namespace)).to eq("admin")
      end
    end
  end
end
