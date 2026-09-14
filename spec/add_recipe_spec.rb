require 'spec_helper'

describe 'Add Recipe' do
    # Tests for adding a new recipe

    # Delete test recipe after each test
    after(:each) do
        post '/recipes/test-recipe/delete'
    end

    it 'should create a new recipe and redirect to the recipe page' do
        post '/recipes', {
            name: 'Test Recipe',
            description: 'A test recipe',
            cook_time: '30',
            ingredients: 'ingredient1, ingredient2',
            steps: "Step 1\nStep 2"
        }

        follow_redirect!

        expect(last_response).to be_ok
        expect(last_response.body).to include('Test Recipe')
        expect(last_response.body).to include('A test recipe')
    end

    it 'check that the recipe contains the correct data' do
        post '/recipes', {
            name: 'Test Recipe',
            description: 'A test recipe',
            cook_time: '30',
            ingredients: 'ingredient1, ingredient2',
            steps: "Step 1\nStep 2"
        }

        follow_redirect!

        expect(last_response.body).to include('ingredient1')
        expect(last_response.body).to include('ingredient2')
        expect(last_response.body).to include('Step 1')
        expect(last_response.body).to include('Step 2')
    end

    it 'should check that the recipe and data is saved correctly to the file' do
        post '/recipes', {
            name: 'Test Recipe',
            description: 'A test recipe',
            cook_time: '30',
            ingredients: 'ingredient1, ingredient2',
            steps: "Step 1\nStep 2"
        }

        # Read the recipes.json file
        recipes_data = JSON.parse(File.read('data/recipes.json'))

        expect(recipes_data[4]['name']).to eq('Test Recipe')
        expect(recipes_data[4]['description']).to eq('A test recipe')
        expect(recipes_data[4]['cook_time']).to eq(30)
        expect(recipes_data[4]['ingredients']).to include('ingredient1', 'ingredient2')
        expect(recipes_data[4]['steps']).to include('Step 1', 'Step 2')
    end

    it 'should load the recipe from the file correctly' do
        post '/recipes', {
            name: 'Test Recipe',
            description: 'A test recipe',
            cook_time: '30',
            ingredients: 'ingredient1, ingredient2',
            steps: "Step 1\nStep 2"
        }

        # Load the recipes from the file
        recipes = load_recipes_from_file

        # Find the newly added recipe
        new_recipe = recipes.find { |r| r.name == 'Test Recipe' }

        expect(new_recipe).not_to be_nil
        expect(new_recipe.description).to eq('A test recipe')
        expect(new_recipe.cook_time).to eq(30)
        expect(new_recipe.ingredients).to include('ingredient1', 'ingredient2')
        expect(new_recipe.steps).to include('Step 1', 'Step 2')
    end

    it 'should return 404 for a non-existent recipe' do
        get '/recipes/non-existent-recipe'

        expect(last_response.status).to eq(404)
        expect(last_response.body).to include('Recipe not found')
    end

    it 'should return 400 for invalid recipe data' do
        post '/recipes', {
            name: '',
            description: '',
            cook_time: '-10',
            ingredients: '',
            steps: ''
        }

        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('Invalid recipe data')
    end

    it 'should check default recipe data exists' do
        get '/recipes'

        expect(last_response).to be_ok
        expect(last_response.body).to include('Grilled Cheese Sandwich')
        expect(last_response.body).to include('Garlic Pasta')
        expect(last_response.body).to include('Mac and Cheese')
        expect(last_response.body).to include('Fried Rice')
    end
end