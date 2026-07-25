# frozen_string_literal: true

class Post < ApplicationRecord
  include Undercarriage::Models::PublishedConcern

  validates :title, presence: true
end
