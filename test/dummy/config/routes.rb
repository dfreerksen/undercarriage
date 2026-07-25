# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  resources :hooks

  namespace :admin do
    resources :posts
  end

  get "/greetings", to: "greetings#show"
end
