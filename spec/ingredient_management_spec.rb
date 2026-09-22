# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../app'

RSpec.describe 'Ingredient Management' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /ingredients' do
    it 'loads the ingredient management page' do
      get '/ingredients'

      expect(last_response).to be_ok
      expect(last_response.body).to include('My Ingredients')
    end

    it 'displays recipe ingredients' do
      get '/ingredients'

      expect(last_response.body).to include('bread')
      expect(last_response.body).to include('butter')
      expect(last_response.body).to include('cheddar cheese')
    end
  end

  describe 'POST /ingredients/toggle' do
    it 'toggles an ingredient availability' do
      post '/ingredients/toggle', name: 'bread'

      get '/ingredients'

      expect(last_response).to be_ok
      expect(last_response.body).to include('bread')
    end

    it 'redirects back to the ingredients page after toggling' do
      post '/ingredients/toggle', name: 'butter'

      expect(last_response).to be_redirect
      expect(last_response.location).to include('/ingredients')
    end
  end

  describe 'ingredient availability' do
    it 'changes the displayed availability when an ingredient is clicked' do
      get '/ingredients'

      initial_page = last_response.body

      post '/ingredients/toggle', name: 'bread'
      follow_redirect!

      updated_page = last_response.body

      expect(updated_page).not_to eq(initial_page)
    end
  end

  describe 'filtering recipes by ingredients' do
    it 'shows recipes that match at least one selected ingredient' do
      get '/', ingredients: ['butter', 'cheddar cheese']

      expect(last_response).to be_ok
      expect(last_response.body).to include('Grilled Cheese Sandwich')
      expect(last_response.body).to include('Mac and Cheese')
      expect(last_response.body).to include('Garlic Pasta')
    end

    it 'does not show recipes with zero matching ingredients' do
      get '/', ingredients: ['butter', 'cheddar cheese']

      expect(last_response.body).not_to include('Fried Rice')
    end

    it 'shows how many ingredients match' do
      get '/', ingredients: ['butter', 'cheddar cheese']

      expect(last_response.body).to include('You have')
      expect(last_response.body).to include('2')
      expect(last_response.body).to include('3')
    end

    it 'shows missing ingredients' do
      get '/', ingredients: ['butter', 'cheddar cheese']

      expect(last_response.body).to include('Missing:')
      expect(last_response.body).to include('bread')
    end
  end

  describe 'using saved ingredients' do
    it 'filters recipes using ingredients marked as available' do
      post '/ingredients/toggle', name: 'bread'
      post '/ingredients/toggle', name: 'cheddar cheese'
      post '/ingredients/toggle', name: 'butter'

      get '/', use_my_ingredients: 'true'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Grilled Cheese Sandwich')
    end

    it 'shows Ready to Cook when all recipe ingredients are available' do
      get '/', ingredients: [
        'bread',
        'cheddar cheese',
        'butter'
      ]

      expect(last_response).to be_ok
      expect(last_response.body).to include('Grilled Cheese Sandwich')
      expect(last_response.body).to include('Ready to Cook')
    end
  end
end