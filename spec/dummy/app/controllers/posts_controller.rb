# frozen_string_literal: true

class PostsController < ApplicationController
  include Undercarriage::Controllers::KaminariConcern

  before_action :index_resources, only: %i[index]

  def index; end

  protected

  def index_resources
    @posts = Post.order(published_at: :desc)
                 .page(page_num).per(per_page)
  end
end
