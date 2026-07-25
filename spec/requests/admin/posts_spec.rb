# frozen_string_literal: true

require "rails_helper"

# See test/dummy/app/controllers/admin/posts_controller.rb
# Covers Undercarriage::Controllers::Restful::NamespaceConcern and the namespaced tier of
# Undercarriage::Controllers::Restful::FlashConcern's i18n fallback chain.
RSpec.describe "Admin::PostsController", type: :request do
  describe "POST /admin/posts" do
    it "creates the post, redirects under the admin namespace, and prefers the namespaced flash message" do
      expect do
        post "/admin/posts", params: { post: { title: "Created" } }
      end.to change(Post, :count).by(1)

      created = Post.last
      # Admin::PostsController has no body of its own (see test/dummy/app/controllers/admin/posts_controller.rb)
      # and inherits `permitted_attributes` from ::PostsController rather than redefining it. This
      # also regression-tests Undercarriage::Controllers::Restful::PermittedAttributesConcern's
      # `permitted_attributes_fallback`, which used to check `instance_methods(false)` and silently
      # permit nothing for a subclass relying on an inherited `permitted_attributes`.
      expect(created.title).to eq("Created")
      expect(response).to redirect_to("/admin/posts/#{created.id}")
      # config/locales/en.yml defines flash.admin.posts.create.success, which takes priority
      # over the generic "Post was successfully created." default used by the non-namespaced
      # PostsController (see spec/requests/posts_spec.rb).
      expect(flash[:success]).to eq("Admin post created!")
    end
  end

  describe "DELETE /admin/posts/:id" do
    it "redirects to the admin index" do
      post_record = Post.create!(title: "Doomed")

      delete "/admin/posts/#{post_record.id}"

      expect(response).to redirect_to("/admin/posts")
    end
  end
end
