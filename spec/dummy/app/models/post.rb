# frozen_string_literal: true

class Post < ApplicationRecord
  validates :body, allow_blank: true, presence: true
  validates :title, presence: true
end
