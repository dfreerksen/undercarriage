# frozen_string_literal: true

require 'rails_helper'

# See spec/dummy/app/controllers/places_controller.rb
RSpec.describe 'Controller Undercarriage::Controllers::LocaleConcern', type: :system do
  describe 'with `#index` action' do
    before { visit '/places' }

    it 'knows it is a `collection` action' do
      expect(page).to have_content('Collection: true')
    end

    it 'knows it is an `index` action' do
      expect(page).to have_content('Index: true')
    end

    it 'knows it is not a `member` action' do
      expect(page).to have_content('Member: false')
    end

    it 'knows it is not a `show` action' do
      expect(page).to have_content('Show: false')
    end

    it 'knows it is not a `new` or `create` action' do
      expect(page).to have_content('New/Create: false')
    end

    it 'knows it is not a `create` or `new` action' do
      expect(page).to have_content('Create/New: false')
    end

    it 'knows it is not a `new` action' do
      expect(page).to have_content('New: false')
    end

    it 'knows it is not a `create` action' do
      expect(page).to have_content('Create: false')
    end

    it 'knows it is not a `edit` or `update` action' do
      expect(page).to have_content('Edit/Update: false')
    end

    it 'knows it is not a `update` or `edit` action' do
      expect(page).to have_content('Update/Edit: false')
    end

    it 'knows it is not a `edit` action' do
      expect(page).to have_content('Edit: false')
    end

    it 'knows it is not a `update` action' do
      expect(page).to have_content('Update: false')
    end

    it 'knows it is not a `destroy` action' do
      expect(page).to have_content('Destroy: false')
    end
  end

  describe 'with `#show` action' do
    before { visit '/places/1' }

    it 'knows it is not a `collection` action' do
      expect(page).to have_content('Collection: false')
    end

    it 'knows it is not an `index` action' do
      expect(page).to have_content('Index: false')
    end

    it 'knows it is a `member` action' do
      expect(page).to have_content('Member: true')
    end

    it 'knows it is a `show` action' do
      expect(page).to have_content('Show: true')
    end

    it 'knows it is not a `new` or `create` action' do
      expect(page).to have_content('New/Create: false')
    end

    it 'knows it is not a `create` or `new` action' do
      expect(page).to have_content('Create/New: false')
    end

    it 'knows it is not a `new` action' do
      expect(page).to have_content('New: false')
    end

    it 'knows it is not a `create` action' do
      expect(page).to have_content('Create: false')
    end

    it 'knows it is not a `edit` or `update` action' do
      expect(page).to have_content('Edit/Update: false')
    end

    it 'knows it is not a `update` or `edit` action' do
      expect(page).to have_content('Update/Edit: false')
    end

    it 'knows it is not a `edit` action' do
      expect(page).to have_content('Edit: false')
    end

    it 'knows it is not a `update` action' do
      expect(page).to have_content('Update: false')
    end

    it 'knows it is not a `destroy` action' do
      expect(page).to have_content('Destroy: false')
    end
  end

  describe 'with `#new` action' do
    before { visit '/places/new' }

    it 'knows it is not a `collection` action' do
      expect(page).to have_content('Collection: false')
    end

    it 'knows it is not an `index` action' do
      expect(page).to have_content('Index: false')
    end

    it 'knows it is not a `member` action' do
      expect(page).to have_content('Member: false')
    end

    it 'knows it is not a `show` action' do
      expect(page).to have_content('Show: false')
    end

    it 'knows it is a `new` or `create` action' do
      expect(page).to have_content('New/Create: true')
    end

    it 'knows it is a `create` or `new` action' do
      expect(page).to have_content('Create/New: true')
    end

    it 'knows it is a `new` action' do
      expect(page).to have_content('New: true')
    end

    it 'knows it is not a `create` action' do
      expect(page).to have_content('Create: false')
    end

    it 'knows it is not a `edit` or `update` action' do
      expect(page).to have_content('Edit/Update: false')
    end

    it 'knows it is not a `update` or `edit` action' do
      expect(page).to have_content('Update/Edit: false')
    end

    it 'knows it is not a `edit` action' do
      expect(page).to have_content('Edit: false')
    end

    it 'knows it is not a `update` action' do
      expect(page).to have_content('Update: false')
    end

    it 'knows it is not a `destroy` action' do
      expect(page).to have_content('Destroy: false')
    end
  end

  describe 'with `#edit` action' do
    before { visit '/places/1/edit' }

    it 'knows it is not a `collection` action' do
      expect(page).to have_content('Collection: false')
    end

    it 'knows it is not an `index` action' do
      expect(page).to have_content('Index: false')
    end

    it 'knows it is a `member` action' do
      expect(page).to have_content('Member: true')
    end

    it 'knows it is not a `show` action' do
      expect(page).to have_content('Show: false')
    end

    it 'knows it is not a `new` or `create` action' do
      expect(page).to have_content('New/Create: false')
    end

    it 'knows it is not a `create` or `new` action' do
      expect(page).to have_content('Create/New: false')
    end

    it 'knows it is not a `new` action' do
      expect(page).to have_content('New: false')
    end

    it 'knows it is not a `create` action' do
      expect(page).to have_content('Create: false')
    end

    it 'knows it is a `edit` or `update` action' do
      expect(page).to have_content('Edit/Update: true')
    end

    it 'knows it is a `update` or `edit` action' do
      expect(page).to have_content('Update/Edit: true')
    end

    it 'knows it is a `edit` action' do
      expect(page).to have_content('Edit: true')
    end

    it 'knows it is not a `update` action' do
      expect(page).to have_content('Update: false')
    end

    it 'knows it is not a `destroy` action' do
      expect(page).to have_content('Destroy: false')
    end
  end
end
