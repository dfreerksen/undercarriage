# frozen_string_literal: true

Rails.application.routes.draw do
  resources :places, only: %i[index show new edit]

  resources :posts, only: %i[index]

  get '/greetings', to: 'greetings#show'
end
