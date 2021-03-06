# frozen_string_literal: true

require 'rails_helper'

# See spec/dummy/app/controllers/posts_controller.rb
RSpec.describe 'Controller Undercarriage::Controllers::KaminariConcern', type: :system do
  before do
    ('A'..'Z').each { |letter| create(:post, :published, title: "Post #{letter} Title") }
  end

  describe 'without query params' do
    before { visit '/posts' }

    it 'does not return records from second page of results' do
      expect(page).not_to have_content('Page Z Title')
    end

    it 'loads 25 (Kaminari default) results per page' do
      article_count = page.all('article.article').count

      expect(article_count).to eq(25)
    end
  end

  describe 'with `?page=X` query param' do
    it 'does not return records from the first page of results' do
      visit '/posts?page=2'

      expect(page).not_to have_content('Page M Title')
    end

    it 'does not return records when page is out of scope' do
      visit '/posts?page=999'

      article_count = page.all('article.article').count

      expect(article_count).to eq(0)
    end
  end

  describe 'with `?per=X` query param' do
    it 'returns the correct number of records' do
      visit '/posts?per=3'

      article_count = page.all('article.article').count

      expect(article_count).to eq(3)
    end
  end

  describe 'with `?per=X&page=Y` query params' do
    before { visit '/posts?page=2&per=6' }

    it 'does not return records from the first page of results' do
      expect(page).not_to have_content('Page F Title')
    end

    it 'returns the correct number of records' do
      article_count = page.all('article.article').count

      expect(article_count).to eq(6)
    end

    it 'does not return records from the third page of results' do
      expect(page).not_to have_content('Page M Title')
    end
  end
end
