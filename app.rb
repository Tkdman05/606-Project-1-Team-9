# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'fileutils'
require_relative 'models/recipe'

FileUtils.mkdir_p('data') unless File.directory?('data')

# Save Files
def save_recipes_to_file(recipes)
  recipes_data = recipes.map do |recipe|
    {
      'name' => recipe.name,
      'description' => recipe.description,
      'cook_time' => recipe.cook_time,
      'ingredients' => recipe.ingredients,
      'steps' => recipe.steps
    }
  end

  File.write('data/recipes.json', JSON.pretty_generate(recipes_data))
end

# Load Files
def load_recipes_from_file
  return [] unless File.exist?('data/recipes.json')

  begin
    data = JSON.parse(File.read('data/recipes.json'))
    data.map do |recipe_data|
      Recipe.new(
        recipe_data['name'],
        recipe_data['description'],
        recipe_data['cook_time'],
        recipe_data['ingredients'],
        recipe_data['steps']
      )
    end
  rescue JSON::ParserError => e
    puts "Error loading recipes: #{e.message}"
    []
  end
end

# Initialize Recipes
default_recipes = [
  Recipe.new(
    'Grilled Cheese Sandwich',
    'A crispy grilled cheese sandwich with melted cheddar cheese.',
    10,
    ['bread', 'cheddar cheese', 'butter'],
    [
      'Butter one side of each slice of bread.',
      'Place a skillet over medium heat.',
      'Place one slice of bread butter-side down in the skillet.',
      'Add cheddar cheese on top of the bread.',
      'Place the second slice of bread on top, butter-side up.',
      'Cook until the bottom is golden brown, then flip.',
      'Cook the other side until golden brown and the cheese is melted.',
      'Remove from the skillet, slice, and serve.'
    ]
  ),

  Recipe.new(
    'Garlic Pasta',
    'A simple pasta dish with garlic, butter, and parmesan.',
    20,
    ['pasta', 'garlic', 'butter', 'parmesan cheese'],
    [
      'Bring a pot of salted water to a boil.',
      'Cook the pasta according to the package instructions.',
      'While the pasta cooks, melt butter in a pan over medium heat.',
      'Add minced garlic and cook until fragrant.',
      'Drain the pasta, reserving a small amount of pasta water.',
      'Add the pasta to the pan with the garlic and butter.',
      'Toss everything together and add a little pasta water if needed.',
      'Top with parmesan cheese and serve.'
    ]
  ),

  Recipe.new(
    'Mac and Cheese',
    'Creamy and cheesy macaroni and cheese.',
    25,
    ['macaroni', 'cheddar cheese', 'milk', 'butter'],
    [
      'Bring a pot of salted water to a boil.',
      'Cook the macaroni according to the package instructions.',
      'Drain the macaroni and set it aside.',
      'Melt butter in a saucepan over medium heat.',
      'Add milk and stir until heated through.',
      'Add shredded cheddar cheese and stir until melted and smooth.',
      'Add the cooked macaroni to the cheese sauce.',
      'Stir until the macaroni is evenly coated.',
      'Serve warm.'
    ]
  ),

  Recipe.new(
    'Fried Rice',
    'Quick fried rice with vegetables, eggs, and soy sauce.',
    15,
    ['rice', 'eggs', 'carrots', 'peas', 'soy sauce'],
    [
      'Cook the rice and allow it to cool slightly.',
      'Heat a pan or wok over medium-high heat.',
      'Add the eggs and scramble until cooked.',
      'Add the carrots and peas and cook until tender.',
      'Add the cooked rice to the pan.',
      'Pour in the soy sauce and stir everything together.',
      'Cook for a few minutes until the rice is heated through.',
      'Serve warm.'
    ]
  )
]

# Load recipes from file or use default recipes
recipes = load_recipes_from_file
if recipes.empty?
  recipes = default_recipes
  save_recipes_to_file(recipes)
end

# Routes
get '/' do
  search = params[:search]
  selected_ingredients = params[:ingredients] || []
  max_time = params[:max_time]

  filtered_recipes = recipes

  # Filter by recipe name
  if search && !search.strip.empty?
    filtered_recipes = filtered_recipes.select do |recipe|
      recipe.name.downcase.include?(search.downcase.strip)
    end
  end

  # Filter by ingredients
  unless selected_ingredients.empty?
    filtered_recipes = filtered_recipes.select do |recipe|
      selected_ingredients.all? do |selected_ingredient|
        recipe.ingredients.any? do |recipe_ingredient|
          recipe_ingredient.downcase == selected_ingredient.downcase
        end
      end
    end
  end

  # Filter by maximum cooking time
  if max_time && !max_time.empty?
    filtered_recipes = filtered_recipes.select do |recipe|
      recipe.cook_time <= max_time.to_i
    end
  end

  all_ingredients = recipes.flat_map(&:ingredients).uniq.sort

  erb :index, locals: {
    recipes: filtered_recipes,
    all_ingredients: all_ingredients,
    selected_ingredients: selected_ingredients
  }
end

# Show all recipes
get '/recipes' do
  erb :recipes, locals: { recipes: recipes }
end

# Show a specific recipe or the new recipe form
get '/recipes/:name' do
  if params[:name] == 'new'
    erb :new_recipe
  else
    recipe = recipes.find do |r|
      r.name.downcase.gsub(' ', '-') == params[:name]
    end

    if recipe
      erb :recipe, locals: { recipe: recipe }
    else
      status 404
      'Recipe not found'
    end
  end
end

# Add a new recipe
post '/recipes' do
  # Check bad inputs
  if params[:name].nil? || params[:name].strip.empty? ||
     params[:description].nil? || params[:description].strip.empty? ||
     params[:cook_time].nil? || params[:cook_time].strip.empty? ||
     params[:ingredients].nil? || params[:ingredients].strip.empty? ||
     params[:steps].nil? || params[:steps].strip.empty?
    status 400
    return 'Invalid recipe data'
  end

  cook_time = params[:cook_time].to_i
  if cook_time <= 0
    status 400
    return 'Invalid recipe data'
  end

  ingredients = params[:ingredients].split(',').map(&:strip)
  steps = params[:steps].split("\n").map(&:strip).reject(&:empty?)

  new_recipe = Recipe.new(
    params[:name],
    params[:description],
    params[:cook_time].to_i,
    ingredients,
    steps
  )

  recipes << new_recipe

  # Save to file for persistence
  save_recipes_to_file(recipes)

  redirect "/recipes/#{new_recipe.name.downcase.gsub(' ', '-')}"
end

# Edit an existing recipe
get '/recipes/:name/edit' do
  recipe = recipes.find do |r|
    r.name.downcase.gsub(' ', '-') == params[:name]
  end

  if recipe
    erb :edit_recipe, locals: { recipe: recipe }
  else
    status 404
    'Recipe not found'
  end
end

# Update an existing recipe
post '/recipes/:name/update' do
  # check bad inputs
  if params[:new_name].nil? || params[:new_name].strip.empty? ||
     params[:description].nil? || params[:description].strip.empty? ||
     params[:cook_time].nil? || params[:cook_time].strip.empty? ||
     params[:ingredients].nil? || params[:ingredients].strip.empty? ||
     params[:steps].nil? || params[:steps].strip.empty?
    status 400
    return 'Invalid recipe data'
  end

  cook_time = params[:cook_time].to_i
  if cook_time <= 0
    status 400
    return 'Invalid recipe data'
  end

  recipe = recipes.find do |r|
    r.name.downcase.gsub(' ', '-') == params[:name]
  end

  if recipe
    recipe.name = params[:new_name]
    recipe.description = params[:description]
    recipe.cook_time = params[:cook_time].to_i
    recipe.ingredients = params[:ingredients].split(',').map(&:strip)
    recipe.steps = params[:steps].split("\n").map(&:strip).reject(&:empty?)

    # Save to file for persistence
    save_recipes_to_file(recipes)

    redirect "/recipes/#{recipe.name.downcase.gsub(' ', '-')}"
  else
    status 404
    'Recipe not found'
  end
end

# Delete an existing recipe
post '/recipes/:name/delete' do
  recipe = recipes.find do |r|
    r.name.downcase.gsub(' ', '-') == params[:name]
  end

  if recipe
    recipes.delete(recipe)

    # Save to file for persistence
    save_recipes_to_file(recipes)

    redirect '/'
  else
    status 404
    'Recipe not found'
  end
end
