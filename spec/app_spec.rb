# frozen_string_literal: true

require_relative 'spec_helper'

describe 'CookAssist application' do
  describe 'Story #2: Pre-loaded recipes' do
    it 'shows pre-loaded recipes when the application is opened' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Grilled Cheese Sandwich')
      expect(last_response.body).to include('Garlic Pasta')
      expect(last_response.body).to include('Mac and Cheese')
      expect(last_response.body).to include('Fried Rice')
    end
  end

  describe 'Story #4: Search recipes by name' do
    it 'shows recipes that match the search term' do
      get '/', search: 'Pasta'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Garlic Pasta')
      expect(last_response.body).not_to include('Grilled Cheese Sandwich')
      expect(last_response.body).not_to include('Mac and Cheese')
      expect(last_response.body).not_to include('Fried Rice')
    end
  end

  describe 'Story #5: Filter recipes by cook time' do
    it 'shows recipes that can be cooked within the selected time' do
      get '/', max_time: '15'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Grilled Cheese Sandwich')
      expect(last_response.body).to include('Fried Rice')
      expect(last_response.body).not_to include('Garlic Pasta')
      expect(last_response.body).not_to include('Mac and Cheese')
    end
  end

  describe 'Story #6: Search recipes by ingredient' do
    it 'shows recipes containing the selected ingredient' do
      get '/', ingredients: ['garlic']
      expect(last_response).to be_ok
      expect(last_response.body).to include('Garlic Pasta')
      expect(last_response.body).not_to include('Grilled Cheese Sandwich')
      expect(last_response.body).not_to include('Mac and Cheese')
      expect(last_response.body).not_to include('Fried Rice')
    end
  end
end
