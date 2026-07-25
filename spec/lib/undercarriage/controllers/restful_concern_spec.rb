# frozen_string_literal: true

require "rails_helper"

# RestfulConcern itself has no logic beyond wiring together the 13 Restful::* sub-concerns (see
# lib/undercarriage/controllers/restful_concern.rb) - what each of those sub-concerns actually does
# is covered elsewhere (spec/requests/posts_spec.rb, spec/requests/admin/posts_spec.rb, and each
# concern's own spec file). This tests the wiring itself: that including RestfulConcern pulls in
# every sub-concern, and that their own `included do` hooks (before_action registration,
# class_attribute defaults) actually cascade and fire.
RSpec.describe Undercarriage::Controllers::RestfulConcern do
  let(:dummy_class) do
    Class.new do
      def self.before_action(*args, **kwargs)
        (@before_actions ||= []) << [args, kwargs]
      end

      class << self
        attr_reader :before_actions
      end

      include Undercarriage::Controllers::RestfulConcern
    end
  end

  it "includes every Restful sub-concern" do
    expect(dummy_class.ancestors).to include(
      Undercarriage::Controllers::Restful::Actions::IndexConcern,
      Undercarriage::Controllers::Restful::Actions::ShowConcern,
      Undercarriage::Controllers::Restful::Actions::NewConcern,
      Undercarriage::Controllers::Restful::Actions::CreateConcern,
      Undercarriage::Controllers::Restful::Actions::EditConcern,
      Undercarriage::Controllers::Restful::Actions::UpdateConcern,
      Undercarriage::Controllers::Restful::Actions::DestroyConcern
    )
  end

  it "defines every CRUD action method" do
    expect(dummy_class.instance_methods).to include(:index, :show, :new, :create, :edit, :update, :destroy)
  end

  it "registers a before_action for every CRUD action via the nested included hooks" do
    expect(dummy_class.before_actions).to contain_exactly(
      [[:index_resources], { only: [:index] }],
      [[:show_resource], { only: [:show] }],
      [[:new_resource], { only: [:new] }],
      [[:create_resource], { only: [:create] }],
      [[:edit_resource], { only: [:edit] }],
      [[:update_resource], { only: [:update] }],
      [[:destroy_resource], { only: [:destroy] }]
    )
  end

  it "applies FlashConcern's class_attribute default via the nested included hook" do
    expect(dummy_class.flash_status_type).to eq(:success)
  end
end
