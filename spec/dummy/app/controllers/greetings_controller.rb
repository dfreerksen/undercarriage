# frozen_string_literal: true

class GreetingsController < ApplicationController
  include Undercarriage::Controllers::LocaleConcern

  def show; end
end
