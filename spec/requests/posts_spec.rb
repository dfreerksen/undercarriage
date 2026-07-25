# frozen_string_literal: true

require "rails_helper"

# See test/dummy/app/controllers/posts_controller.rb
RSpec.describe "PostsController", type: :request do
  describe "GET /posts" do
    it "lists posts and identifies the action type" do
      Post.create!(title: "First")
      Post.create!(title: "Second")

      get "/posts"

      expect(response.body).to include("Index: true")
      expect(response.body).to include("Collection: true")
      expect(response.body).to include("First")
      expect(response.body).to include("Second")
    end

    it "paginates with Kaminari via the `per` and `page` params" do
      3.times { |n| Post.create!(title: "Post #{n}") }

      get "/posts", params: { per: 2, page: 1 }
      first_page_count = response.body.scan(/^Post: /).count

      get "/posts", params: { per: 2, page: 2 }
      second_page_count = response.body.scan(/^Post: /).count

      expect(first_page_count).to eq(2)
      expect(second_page_count).to eq(1)
    end
  end

  describe "GET /posts/:id" do
    it "shows a post and identifies the action type" do
      post_record = Post.create!(title: "Hello")

      get "/posts/#{post_record.id}"

      expect(response.body).to include("Show: true")
      expect(response.body).to include("Member: true")
      expect(response.body).to include("Hello")
    end
  end

  describe "GET /posts/new" do
    it "identifies the action type" do
      get "/posts/new"

      expect(response.body).to include("New: true")
      expect(response.body).to include("Create/New: true")
    end
  end

  describe "POST /posts" do
    context "with valid params" do
      it "creates the post, sets a flash message and redirects to it" do
        expect do
          post "/posts", params: { post: { title: "Created", body: "Body text" } }
        end.to change(Post, :count).by(1)

        created = Post.last
        expect(created.title).to eq("Created")
        expect(response).to redirect_to("/posts/#{created.id}")
        expect(flash[:success]).to eq("Post was successfully created.")
      end

      it "only assigns permitted attributes" do
        post "/posts", params: { post: { title: "Created", not_a_real_field: "nope" } }

        expect(Post.last.title).to eq("Created")
      end
    end

    context "with invalid params" do
      it "does not create a post and re-renders `new` with errors" do
        expect do
          post "/posts", params: { post: { title: "" } }
        end.not_to change(Post, :count)

        if Rails::VERSION::MAJOR >= 8
          expect(response).to have_http_status(:unprocessable_content)
        else
          # rubocop:disable RSpecRails/HttpStatusNameConsistency
          expect(response).to have_http_status(:unprocessable_entity)
          # rubocop:enable RSpecRails/HttpStatusNameConsistency
        end
        expect(response.body).to include("Errors: Title can&#39;t be blank")
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe "GET /posts/:id/edit" do
    it "identifies the action type" do
      post_record = Post.create!(title: "Editable")

      get "/posts/#{post_record.id}/edit"

      expect(response.body).to include("Edit: true")
      expect(response.body).to include("Update/Edit: true")
    end
  end

  describe "PATCH /posts/:id" do
    context "with valid params" do
      it "updates the post, sets a flash message and redirects to it" do
        post_record = Post.create!(title: "Original")

        patch "/posts/#{post_record.id}", params: { post: { title: "Updated" } }

        expect(post_record.reload.title).to eq("Updated")
        expect(response).to redirect_to("/posts/#{post_record.id}")
        expect(flash[:success]).to eq("Post was successfully updated.")
      end
    end

    context "with invalid params" do
      it "does not update the post and re-renders `edit` with errors" do
        post_record = Post.create!(title: "Original")

        patch "/posts/#{post_record.id}", params: { post: { title: "" } }

        expect(post_record.reload.title).to eq("Original")
        if Rails::VERSION::MAJOR >= 8
          expect(response).to have_http_status(:unprocessable_content)
        else
          # rubocop:disable RSpecRails/HttpStatusNameConsistency
          expect(response).to have_http_status(:unprocessable_entity)
          # rubocop:enable RSpecRails/HttpStatusNameConsistency
        end
        expect(response.body).to include("Errors: Title can&#39;t be blank")
      end
    end
  end

  describe "DELETE /posts/:id" do
    it "destroys the post, sets a flash message and redirects to the index" do
      post_record = Post.create!(title: "Doomed")

      expect do
        delete "/posts/#{post_record.id}"
      end.to change(Post, :count).by(-1)

      expect(response).to redirect_to("/posts")
      expect(flash[:success]).to eq("Post was successfully destroyed.")
    end
  end
end
