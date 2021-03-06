# frozen_string_literal: true

class PlacesController < ApplicationController
  include Undercarriage::Controllers::ActionConcern

  def index
    render :show
  end

  def show
    render :show
  end

  def new
    render :show
  end

  def edit
    render :show
  end
end
