# frozen_string_literal: true

require "rails_helper"

# See test/dummy/app/controllers/hooks_controller.rb
# Covers the nested_resource_pre_build/nested_resource_build/after_create_action/after_update_action
# hook-timing contract documented in
# lib/undercarriage/controllers/restful/actions/base_concern.rb, shared by NewConcern, EditConcern,
# CreateConcern, and UpdateConcern.
RSpec.describe "HooksController", type: :request do
  before { HooksController.hook_calls = [] }

  describe "GET /hooks/new" do
    it "calls nested_resource_pre_build then nested_resource_build" do
      get "/hooks/new"

      expect(HooksController.hook_calls).to eq(%i[nested_resource_pre_build nested_resource_build])
    end
  end

  describe "GET /hooks/:id/edit" do
    it "calls nested_resource_pre_build then nested_resource_build" do
      post_record = Post.create!(title: "Editable")

      get "/hooks/#{post_record.id}/edit"

      expect(HooksController.hook_calls).to eq(%i[nested_resource_pre_build nested_resource_build])
    end
  end

  describe "POST /hooks" do
    it "calls nested_resource_pre_build and after_create_action, but not nested_resource_build, on success" do
      post "/hooks", params: { post: { title: "Created" } }

      expect(HooksController.hook_calls).to eq(%i[nested_resource_pre_build after_create_action])
    end

    it "calls nested_resource_pre_build and nested_resource_build, but not after_create_action, on failure" do
      post "/hooks", params: { post: { title: "" } }

      expect(HooksController.hook_calls).to eq(%i[nested_resource_pre_build nested_resource_build])
    end
  end

  describe "PATCH /hooks/:id" do
    it "calls nested_resource_pre_build and after_update_action, but not nested_resource_build, on success" do
      post_record = Post.create!(title: "Original")

      patch "/hooks/#{post_record.id}", params: { post: { title: "Updated" } }

      expect(HooksController.hook_calls).to eq(%i[nested_resource_pre_build after_update_action])
    end

    it "calls nested_resource_pre_build and nested_resource_build, but not after_update_action, on failure" do
      post_record = Post.create!(title: "Original")

      patch "/hooks/#{post_record.id}", params: { post: { title: "" } }

      expect(HooksController.hook_calls).to eq(%i[nested_resource_pre_build nested_resource_build])
    end
  end
end
