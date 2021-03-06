# frozen_string_literal: true

require 'rails_helper'

# See spec/dummy/app/controllers/greetings_controller.rb
RSpec.describe 'Controller Undercarriage::Controllers::LocaleConcern', type: :system do
  let(:original_headers) do
    page.driver.options[:headers]
  end

  describe 'with unspecified headers' do
    before { visit '/greetings' }

    it 'shows the greeting in English' do
      expect(page).to have_content('Greeting: Hello')
    end

    it 'shows the lang as `en`' do
      expect(page).to have_content('Language: en')
    end

    it 'shows the dir as `ltr`' do
      expect(page).to have_content('Direction: ltr')
    end
  end

  describe 'with `en` header' do
    let(:headers) do
      { 'HTTP_ACCEPT_LANGUAGE' => 'en' }
    end

    before do
      original_headers

      page.driver.options[:headers] ||= {}
      page.driver.options[:headers].merge!(headers)

      visit '/greetings'
    end

    after do
      page.driver.options[:headers] = original_headers
    end

    it 'shows the greeting in English' do
      expect(page).to have_content('Greeting: Hello')
    end

    it 'shows the lang as `en`' do
      expect(page).to have_content('Language: en')
    end

    it 'shows the dir as `ltr`' do
      expect(page).to have_content('Direction: ltr')
    end
  end

  describe 'with `ar` headers' do
    let(:headers) do
      { 'HTTP_ACCEPT_LANGUAGE' => 'ar' }
    end

    before do
      original_headers

      page.driver.options[:headers] ||= {}
      page.driver.options[:headers].merge!(headers)

      visit '/greetings'
    end

    after do
      page.driver.options[:headers] = original_headers
    end

    it 'shows the greeting in Arabic' do
      expect(page).to have_content('تحية: مرحبا')
    end

    it 'shows the lang as `en`' do
      expect(page).to have_content('لغة: ar')
    end

    it 'shows the dir as `ltr`' do
      expect(page).to have_content('اتجاه: rtl')
    end
  end
end
