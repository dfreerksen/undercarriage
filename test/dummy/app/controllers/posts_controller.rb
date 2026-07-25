# frozen_string_literal: true

class PostsController < ApplicationController
  include Undercarriage::Controllers::RestfulConcern
  include Undercarriage::Controllers::KaminariConcern
  include Undercarriage::Controllers::ActionConcern

  protected

  def resources_content
    resources_query = Post.order(created_at: :desc).page(page_num).per(per_page)

    instance_variable_set("@#{instances_name}", resources_query)
  end

  def permitted_attributes
    %i[title body published_at]
  end
end
