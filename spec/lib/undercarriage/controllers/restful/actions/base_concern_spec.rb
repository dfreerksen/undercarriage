# frozen_string_literal: true

require "rails_helper"

# spec/requests/posts_spec.rb (and friends) cover the CRUD behavior every action concern builds on
# top of BaseConcern. spec/requests/hooks_spec.rb covers the nested_resource_pre_build/
# nested_resource_build/after_create_action/after_update_action timing contract, which needs a real
# controller to observe. This tests BaseConcern's own standalone logic in isolation:
# resource_content's lookup, the per-action *_content hooks that delegate to it (and that overriding
# resource_content in the includer is honored by all four), the no-op hook defaults, and
# unprocessable_status's Rails-version branching.
RSpec.describe Undercarriage::Controllers::Restful::Actions::BaseConcern do
  subject(:instance) { dummy_class.new }

  let(:fake_model_class) do
    Class.new do
      def self.find(id)
        "record-#{id}"
      end
    end
  end

  let(:dummy_class) do
    model_class = fake_model_class

    Class.new do
      include Undercarriage::Controllers::Restful::Actions::BaseConcern

      attr_accessor :action_name, :params

      define_method(:model_class) { model_class }
      define_method(:instance_name) { "widget" }
    end
  end

  describe "#resource_content" do
    it "finds the record by params[:id]" do
      instance.params = { id: 42 }

      result = instance.send(:resource_content)

      expect(result).to eq("record-42")
    end
  end

  describe "#destroy_content" do
    it "finds the record by params[:id]" do
      instance.params = { id: 42 }

      result = instance.send(:destroy_content)

      expect(result).to eq("record-42")
    end
  end

  describe "#edit_content" do
    it "finds the record by params[:id]" do
      instance.params = { id: 42 }

      result = instance.send(:edit_content)

      expect(result).to eq("record-42")
    end
  end

  describe "#show_content" do
    it "finds the record by params[:id]" do
      instance.params = { id: 42 }

      result = instance.send(:show_content)

      expect(result).to eq("record-42")
    end
  end

  describe "#update_content" do
    it "finds the record by params[:id]" do
      instance.params = { id: 42 }

      result = instance.send(:update_content)

      expect(result).to eq("record-42")
    end
  end

  describe "overriding #resource_content" do
    subject(:instance) { dummy_subclass.new }

    let(:dummy_subclass) do
      Class.new(dummy_class) do
        def resource_content
          "overridden"
        end
      end
    end

    it "is honored by destroy_content, edit_content, show_content and update_content" do
      expect(instance.send(:destroy_content)).to eq("overridden")
      expect(instance.send(:edit_content)).to eq("overridden")
      expect(instance.send(:show_content)).to eq("overridden")
      expect(instance.send(:update_content)).to eq("overridden")
    end
  end

  describe "override hooks" do
    it "are callable no-ops by default" do
      expect(instance.send(:nested_resource_pre_build)).to be_nil
      expect(instance.send(:nested_resource_build)).to be_nil
      expect(instance.send(:after_create_action)).to be_nil
      expect(instance.send(:after_update_action)).to be_nil
    end
  end

  describe "#unprocessable_status" do
    it "is :unprocessable_content on Rails 8+" do
      stub_const("Rails::VERSION::MAJOR", 8)

      expect(instance.send(:unprocessable_status)).to eq(:unprocessable_content)
    end

    it "is :unprocessable_entity before Rails 8" do
      stub_const("Rails::VERSION::MAJOR", 7)

      expect(instance.send(:unprocessable_status)).to eq(:unprocessable_entity)
    end
  end
end
