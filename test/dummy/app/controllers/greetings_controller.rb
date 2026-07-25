# frozen_string_literal: true

class GreetingsController < ApplicationController
  include Undercarriage::Controllers::LocaleConcern

  def show
    render plain: "lang=#{html_lang} dir=#{html_dir}"
  end
end
