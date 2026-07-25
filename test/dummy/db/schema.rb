# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table :posts, force: :cascade do |t|
    t.string :title
    t.text :body
    t.datetime :published_at
    t.datetime :ready_at
    t.timestamps
  end
end
