# frozen_string_literal: true

require "rails_helper"

# PostsController (the only index-capable controller in test/dummy) always overrides
# #resources_content for Kaminari pagination, so IndexConcern's own default implementation is never
# exercised by any request spec. This tests it directly against the real Post model.
RSpec.describe Undercarriage::Controllers::Restful::Actions::IndexConcern do
  subject(:instance) { dummy_class.new }

  let(:dummy_class) do
    Class.new do
      def self.before_action(*); end

      include Undercarriage::Controllers::Restful::Actions::IndexConcern

      define_method(:model_class) { Post }
      define_method(:instances_name) { "posts" }
    end
  end

  describe "#resources_content" do
    it "queries model_class.all and sets @<instances_name>" do
      post_a = Post.create!(title: "A")
      post_b = Post.create!(title: "B")

      result = instance.send(:resources_content)

      expect(result).to contain_exactly(post_a, post_b)
      expect(instance.instance_variable_get(:@posts)).to contain_exactly(post_a, post_b)
    end
  end
end
