# frozen_string_literal: true

require "rails_helper"

# spec/requests/posts_spec.rb and spec/requests/admin/posts_spec.rb prove the common path (a single
# `permitted_attributes` shared by create/update, including the inherited-method regression test).
# This tests the pieces that aren't exercised anywhere else: the true no-`permitted_attributes`
# fallback (permits nothing), independently overridden `permitted_create_attributes`/
# `permitted_update_attributes`, #resource_new_params, and the underlying strong-params
# require/permit behavior (using real ActionController::Parameters, not a plain Hash).
RSpec.describe Undercarriage::Controllers::Restful::PermittedAttributesConcern do
  subject(:instance) { dummy_class.new }

  let(:dummy_class) do
    Class.new do
      include Undercarriage::Controllers::Restful::PermittedAttributesConcern

      attr_accessor :params, :action_name

      def model_scope
        :widget
      end
    end
  end

  describe "#permitted_attributes_fallback (via #create_resource_params/#update_resource_params)" do
    context "when the including class does not define permitted_attributes" do
      it "permits nothing" do
        instance.params = ActionController::Parameters.new(widget: { title: "x", secret: "y" })

        expect(instance.send(:create_resource_params).to_h).to eq({})
        expect(instance.send(:update_resource_params).to_h).to eq({})
      end
    end

    context "when the including class defines permitted_attributes" do
      let(:dummy_class) do
        Class.new do
          include Undercarriage::Controllers::Restful::PermittedAttributesConcern

          attr_accessor :params, :action_name

          def model_scope
            :widget
          end

          def permitted_attributes
            [:title]
          end
        end
      end

      it "permits the declared attributes for both create and update" do
        instance.params = ActionController::Parameters.new(widget: { title: "x", secret: "y" })

        expect(instance.send(:create_resource_params).to_h).to eq({ "title" => "x" })
        expect(instance.send(:update_resource_params).to_h).to eq({ "title" => "x" })
      end
    end
  end

  describe "independent create/update overrides" do
    let(:dummy_class) do
      Class.new do
        include Undercarriage::Controllers::Restful::PermittedAttributesConcern

        attr_accessor :params, :action_name

        def model_scope
          :widget
        end

        def permitted_create_attributes
          [:title]
        end

        def permitted_update_attributes
          [:body]
        end
      end
    end

    it "lets create and update permit different attributes" do
      instance.params = ActionController::Parameters.new(widget: { title: "t", body: "b" })

      expect(instance.send(:create_resource_params).to_h).to eq({ "title" => "t" })
      expect(instance.send(:update_resource_params).to_h).to eq({ "body" => "b" })
    end
  end

  describe "#resource_new_params" do
    let(:dummy_class) do
      Class.new do
        include Undercarriage::Controllers::Restful::PermittedAttributesConcern

        attr_accessor :params, :action_name

        def model_scope
          :widget
        end

        def permitted_attributes
          [:title]
        end
      end
    end

    it "is nil for the new action" do
      instance.action_name = "new"

      expect(instance.send(:resource_new_params)).to be_nil
    end

    it "is create_resource_params for any other action" do
      instance.action_name = "create"
      instance.params = ActionController::Parameters.new(widget: { title: "t" })

      expect(instance.send(:resource_new_params).to_h).to eq({ "title" => "t" })
    end
  end

  describe "#create_resource_params / #update_resource_params" do
    it "raise when the model_scope key is missing from params" do
      instance.params = ActionController::Parameters.new({})

      expect { instance.send(:create_resource_params) }.to raise_error(ActionController::ParameterMissing)
      expect { instance.send(:update_resource_params) }.to raise_error(ActionController::ParameterMissing)
    end
  end
end
