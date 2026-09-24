# frozen_string_literal: true

require 'spec_helper'

describe 'Story 3: Edit and Delete Recipe' do
  before(:each) do
    # Make sure old test recipes do not exist
    post '/recipes/test-recipe/delete'
    post '/recipes/updated-recipe/delete'

    # Add a fresh recipe for each test
    post '/recipes', {
      name: 'Test Recipe',
      description: 'A test recipe',
      cook_time: '30',
      ingredients: 'ingredient1, ingredient2',
      steps: "Step 1\nStep 2"
    }
  end

  after(:each) do
    # Clean up both possible names
    post '/recipes/test-recipe/delete'
    post '/recipes/updated-recipe/delete'
  end

  it 'should edit an existing recipe with correct details' do
    post '/recipes/test-recipe/update', {
      new_name: 'Updated Recipe',
      description: 'An updated test recipe',
      cook_time: '45',
      ingredients: 'ingredient3, ingredient4',
      steps: "Updated Step 1\nUpdated Step 2"
    }

    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Updated Recipe')
    expect(last_response.body).to include('An updated test recipe')
    expect(last_response.body).to include('45')
    expect(last_response.body).to include('ingredient3')
    expect(last_response.body).to include('ingredient4')
    expect(last_response.body).to include('Updated Step 1')
    expect(last_response.body).to include('Updated Step 2')
  end

  it 'should delete an existing recipe' do
    post '/recipes/test-recipe/delete'

    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_response.body).not_to include('Test Recipe')
  end

  it 'should return 404 when trying to edit a non-existent recipe' do
    post '/recipes/non-existent-recipe/update', {
      new_name: 'Non-existent Recipe',
      description: 'This recipe does not exist',
      cook_time: '60',
      ingredients: 'ingredient5, ingredient6',
      steps: "Step 1\nStep 2"
    }

    expect(last_response.status).to eq(404)
    expect(last_response.body).to include('Recipe not found')
  end

  it 'should return 404 when trying to delete a non-existent recipe' do
    post '/recipes/non-existent-recipe/delete'

    expect(last_response.status).to eq(404)
    expect(last_response.body).to include('Recipe not found')
  end

  it 'should check that the edited recipe and data is saved correctly to the file' do
    post '/recipes/test-recipe/update', {
      new_name: 'Updated Recipe',
      description: 'An updated test recipe',
      cook_time: '45',
      ingredients: 'ingredient3, ingredient4',
      steps: "Updated Step 1\nUpdated Step 2"
    }

    recipes_data = JSON.parse(File.read('data/recipes.json'))

    updated_recipe = recipes_data.find do |recipe|
      recipe['name'] == 'Updated Recipe'
    end

    expect(updated_recipe).not_to be_nil
    expect(updated_recipe['description']).to eq('An updated test recipe')
    expect(updated_recipe['cook_time']).to eq(45)
    expect(updated_recipe['ingredients']).to include('ingredient3', 'ingredient4')
    expect(updated_recipe['steps']).to include('Updated Step 1', 'Updated Step 2')
  end

  it 'should check that the deleted recipe is removed from the file' do
    # Delete the temporary recipe instead of a default recipe
    post '/recipes/test-recipe/delete'

    recipes_data = JSON.parse(File.read('data/recipes.json'))

    expect(
      recipes_data.any? { |recipe| recipe['name'] == 'Test Recipe' }
    ).to be false
  end

  it 'should return 400 for invalid recipe data when editing' do
    post '/recipes/test-recipe/update', {
      new_name: '',
      description: '',
      cook_time: '-10',
      ingredients: '',
      steps: ''
    }

    expect(last_response.status).to eq(400)
    expect(last_response.body).to include('Invalid recipe data')
  end
end
