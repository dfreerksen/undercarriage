# frozen_string_literal: true

require "rails_helper"

# UtilityConcern isn't independently unit-tested anywhere else - its behavior is only proven
# indirectly by the dummy app happening to work (PostsController's controller_name "posts"
# resolving to the Post model, etc.). This tests each derived value directly, including
# #model_class's constant resolution (using the real Post model) and #controller_name_singular_title
# with a multi-word controller name.
RSpec.describe Undercarriage::Controllers::Restful::UtilityConcern do
  subject(:instance) { dummy_class.new.tap { |i| i.controller_name = controller_name } }

  let(:dummy_class) do
    Class.new do
      include Undercarriage::Controllers::Restful::UtilityConcern

      attr_accessor :controller_name
    end
  end

  context "with a simple plural controller_name" do
    let(:controller_name) { "posts" }

    it "derives the singular controller name" do
      expect(instance.send(:controller_name_singular)).to eq("post")
    end

    it "derives the titleized singular name" do
      expect(instance.send(:controller_name_singular_title)).to eq("Post")
    end

    it "aliases controller_name_singular_human to controller_name_singular_title" do
      expect(instance.send(:controller_name_singular_human)).to eq("Post")
    end

    it "derives the model name" do
      expect(instance.send(:model_name)).to eq("post")
    end

    it "resolves the model class" do
      expect(instance.send(:model_class)).to eq(Post)
    end

    it "derives instances_name from controller_name" do
      expect(instance.send(:instances_name)).to eq("posts")
    end

    it "derives instance_name from model_name" do
      expect(instance.send(:instance_name)).to eq("post")
    end

    it "derives model_scope as a symbol" do
      expect(instance.send(:model_scope)).to eq(:post)
    end
  end

  context "with a multi-word plural controller_name" do
    let(:controller_name) { "blog_posts" }

    it "titleizes every word" do
      expect(instance.send(:controller_name_singular_title)).to eq("Blog Post")
    end
  end
end
