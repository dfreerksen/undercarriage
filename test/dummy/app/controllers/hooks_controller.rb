# frozen_string_literal: true

# Subclasses PostsController (inheriting its permitted_attributes, resources_content, and views via
# Rails' controller view-lookup prefix chain) solely to record the order/conditions under which
# Undercarriage::Controllers::Restful::Actions::BaseConcern's override hooks fire. See
# spec/requests/hooks_spec.rb.
class HooksController < PostsController
  class_attribute :hook_calls
  self.hook_calls = []

  protected

  # HooksController's own controller_name is "hooks" (unlike Admin::PostsController, whose
  # controller_name is still "posts" since Rails strips the namespace), so the UtilityConcern
  # defaults would look for a `Hook` model, a `hook` strong-params scope, and @hook/@hooks ivars the
  # inherited posts/* views don't know about. model_class/instance_name/resource_scope all derive
  # from model_name, so overriding it alone fixes all three; instances_name is derived straight from
  # controller_name and needs its own override.
  def model_name
    "post"
  end

  def instances_name
    "posts"
  end

  def nested_resource_pre_build
    self.class.hook_calls += [:nested_resource_pre_build]
  end

  def nested_resource_build
    self.class.hook_calls += [:nested_resource_build]
  end

  def after_create_action
    self.class.hook_calls += [:after_create_action]
  end

  def after_update_action
    self.class.hook_calls += [:after_update_action]
  end
end
