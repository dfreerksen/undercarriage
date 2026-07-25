# frozen_string_literal: true

require "rails_helper"

# spec/requests/posts_spec.rb and spec/requests/admin/posts_spec.rb prove the redirects end-to-end
# through real controller actions. This tests LocationAfterConcern's own route-name construction
# directly, using Rails.application.routes.url_helpers (reflecting test/dummy/config/routes.rb) so
# `resource_path`/`resources_path`'s `send("#{name}_path", ...)`/`polymorphic_path` calls resolve
# against real routes rather than needing a full controller/HTTP request.
RSpec.describe Undercarriage::Controllers::Restful::LocationAfterConcern do
  subject(:instance) do
    dummy_class.new.tap do |i|
      i.controller_name = "posts"
      i.controller_name_singular = "post"
      i.resource_namespace = namespace
    end
  end

  let(:dummy_class) do
    Class.new do
      include Rails.application.routes.url_helpers
      include Undercarriage::Controllers::Restful::LocationAfterConcern

      attr_accessor :resource_namespace, :controller_name, :controller_name_singular
      attr_writer :create_resource, :update_resource
    end
  end
  let(:namespace) { nil }
  let(:post_record) { Post.create!(title: "Location test") }

  describe "#location_after_create" do
    it "returns the show path for @create_resource" do
      instance.create_resource = post_record

      expect(instance.send(:location_after_create)).to eq("/posts/#{post_record.id}")
    end

    context "with a namespace" do
      let(:namespace) { "admin" }

      it "returns the namespaced show path" do
        instance.create_resource = post_record

        expect(instance.send(:location_after_create)).to eq("/admin/posts/#{post_record.id}")
      end
    end
  end

  describe "#location_after_update" do
    it "returns the show path for @update_resource" do
      instance.update_resource = post_record

      expect(instance.send(:location_after_update)).to eq("/posts/#{post_record.id}")
    end
  end

  describe "#location_after_destroy" do
    it "returns the index path" do
      expect(instance.send(:location_after_destroy)).to eq("/posts")
    end

    context "with a namespace" do
      let(:namespace) { "admin" }

      it "returns the namespaced index path" do
        expect(instance.send(:location_after_destroy)).to eq("/admin/posts")
      end
    end
  end

  describe "#location_after_save" do
    it "returns the index path" do
      expect(instance.send(:location_after_save)).to eq("/posts")
    end
  end
end
