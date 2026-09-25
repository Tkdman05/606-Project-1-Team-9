# frozen_string_literal: true

require 'spec_helper'

describe 'Story 8: Shopping List' do
  # Tests for shopping list functionality

  # Clean up shopping list file after each test
  after(:each) do
    File.delete('shopping_list.json') if File.exist?('shopping_list.json')
  end

  # Set up test recipes before tests
  before(:all) do
    # Create test recipes if they don't exist
    post '/recipes', {
      name: 'Test Pasta',
      description: 'A test pasta recipe',
      cook_time: '20',
      ingredients: 'pasta, garlic, olive oil, parmesan',
      steps: "Boil pasta\nAdd garlic"
    }

    post '/recipes', {
      name: 'Test Salad',
      description: 'A test salad recipe',
      cook_time: '10',
      ingredients: 'lettuce, tomato, cucumber, olive oil',
      steps: "Mix vegetables\nAdd dressing"
    }
  end

  # Clean up test recipes after all tests
  after(:all) do
    post '/recipes/test-pasta/delete'
    post '/recipes/test-salad/delete'
  end

  # Test 1: Create a shopping list
  it 'should create a shopping list with selected recipes' do
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta', 'Test Salad']
    }

    expect(last_response).to be_ok
    expect(last_response.body).to include('Shopping List')
    expect(last_response.body).to include('Test Pasta')
    expect(last_response.body).to include('Test Salad')
  end

  # Test 2: Verify shopping list contents
  it 'should contain all ingredients from selected recipes' do
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta', 'Test Salad']
    }

    # Check that all ingredients are included
    expect(last_response.body).to include('pasta')
    expect(last_response.body).to include('garlic')
    expect(last_response.body).to include('olive oil')
    expect(last_response.body).to include('parmesan')
    expect(last_response.body).to include('lettuce')
    expect(last_response.body).to include('tomato')
    expect(last_response.body).to include('cucumber')
  end

  # Test 3: Save shopping list to file
  it 'should save shopping list to JSON file correctly' do
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta', 'Test Salad']
    }

    # Check file exists
    expect(File.exist?('data/shopping_list.json')).to be true

    # Read and parse the file
    shopping_list_data = JSON.parse(File.read('data/shopping_list.json'))

    # Verify file contents
    expect(shopping_list_data['selected_recipes']).to eq(['Test Pasta', 'Test Salad'])
    expect(shopping_list_data['all_needed_ingredients']).to include('pasta')
    expect(shopping_list_data['all_needed_ingredients']).to include('garlic')
    expect(shopping_list_data['all_needed_ingredients']).to include('lettuce')
    expect(shopping_list_data['all_needed_ingredients']).to include('tomato')
    expect(shopping_list_data['created_at']).not_to be_nil
  end

  # Test 4: Load shopping list from file
  it 'should load saved shopping list from file' do
    # First create and save a shopping list
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta']
    }

    # Verify it was saved
    expect(File.exist?('data/shopping_list.json')).to be true

    # Now load it with GET request
    get '/shopping-list'

    expect(last_response).to be_ok
    expect(last_response.body).to include('Shopping List')
    expect(last_response.body).to include('Test Pasta')
    expect(last_response.body).to include('pasta')
    expect(last_response.body).to include('garlic')
    expect(last_response.body).to include('olive oil')
    expect(last_response.body).to include('parmesan')
  end

  # Test 5: Verify shopping list removes duplicate ingredients
  it 'should remove duplicate ingredients from multiple recipes' do
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta', 'Test Salad']
    }

    # Read the saved file
    shopping_list_data = JSON.parse(File.read('data/shopping_list.json'))

    # Both recipes have 'olive oil' but it should appear only once
    olive_oil_count = shopping_list_data['all_needed_ingredients'].count('olive oil')
    expect(olive_oil_count).to eq(1)

    # Verify all unique ingredients are present
    expect(shopping_list_data['all_needed_ingredients'].uniq).to eq(shopping_list_data['all_needed_ingredients'])
  end

  # Test 6: Verify ingredients are sorted alphabetically
  it 'should sort ingredients alphabetically in shopping list' do
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta', 'Test Salad']
    }

    # Read the saved file
    shopping_list_data = JSON.parse(File.read('data/shopping_list.json'))
    ingredients = shopping_list_data['all_needed_ingredients']

    # Check that ingredients are sorted
    expect(ingredients).to eq(ingredients.sort)
  end

  # Test 7: Handle loading when no file exists
  it 'should handle viewing shopping list when no file exists' do
    # Make sure no shopping list file exists
    File.delete('data/shopping_list.json') if File.exist?('data/shopping_list.json')

    get '/shopping-list'

    expect(last_response).to be_ok
    expect(last_response.body).to include('No Shopping List Found')
  end

  # Test 8: Verify persistence through app restart
  it 'should persist shopping list data in file' do
    # Create a shopping list
    post '/shopping-list', {
      'selected_recipes' => ['Test Pasta', 'Test Salad']
    }

    # Read file directly (simulating app restart)
    saved_data = JSON.parse(File.read('data/shopping_list.json'))

    # Verify all data is preserved
    expect(saved_data['selected_recipes']).to eq(['Test Pasta', 'Test Salad'])
    expect(saved_data['all_needed_ingredients']).not_to be_empty
    expect(saved_data['missing_ingredients']).not_to be_nil
    expect(saved_data['created_at']).not_to be_nil

    # Load through route (after simulated restart)
    get '/shopping-list'

    expect(last_response).to be_ok
    expect(last_response.body).to include('Test Pasta')
    expect(last_response.body).to include('Test Salad')
  end
end
