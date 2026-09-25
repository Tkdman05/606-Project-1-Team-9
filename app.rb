# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'fileutils'

require_relative 'models/recipe'
require_relative 'models/ingredient'

FileUtils.mkdir_p('data') unless File.directory?('data')

# --------------------------------------------------
# RECIPE PERSISTENCE
# --------------------------------------------------

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

# --------------------------------------------------
# INGREDIENT PERSISTENCE
# --------------------------------------------------

def save_ingredients_to_file(ingredients)
  ingredients_data = ingredients.map do |ingredient|
    {
      'name' => ingredient.name,
      'available' => ingredient.available
    }
  end

  File.write(
    'data/ingredients.json',
    JSON.pretty_generate(ingredients_data)
  )
end

def load_ingredients_from_file
  return [] unless File.exist?('data/ingredients.json')

  begin
    data = JSON.parse(File.read('data/ingredients.json'))

    data.map do |ingredient_data|
      Ingredient.new(
        ingredient_data['name'],
        ingredient_data['available']
      )
    end
  rescue JSON::ParserError => e
    puts "Error loading ingredients: #{e.message}"
    []
  end
end

# --------------------------------------------------
# DEFAULT RECIPES
# --------------------------------------------------

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

# --------------------------------------------------
# INITIALIZE RECIPES
# --------------------------------------------------

recipes = load_recipes_from_file

if recipes.empty?
  recipes = default_recipes
  save_recipes_to_file(recipes)
end

# --------------------------------------------------
# INITIALIZE INGREDIENTS
# --------------------------------------------------

ingredients = load_ingredients_from_file

recipe_ingredient_names =
  recipes.flat_map(&:ingredients).uniq.sort

recipe_ingredient_names.each do |name|
  next if ingredients.any? do |ingredient|
    ingredient.name.downcase == name.downcase
  end

  ingredients << Ingredient.new(name, false)
end

save_ingredients_to_file(ingredients)

# --------------------------------------------------
# ROUTES
# --------------------------------------------------

get '/' do
  search = params[:search]

  selected_ingredients =
    params[:ingredients] || []

  max_time = params[:max_time]

  use_my_ingredients =
    params[:use_my_ingredients] == 'true'

  filtered_recipes = recipes

  recipe_matches = {}

  # ------------------------------------------------
  # SEARCH BY RECIPE NAME
  # ------------------------------------------------

  if search && !search.strip.empty?

    filtered_recipes =
      filtered_recipes.select do |recipe|
        recipe.name
              .downcase
              .include?(search.downcase.strip)
      end

  end

  # ------------------------------------------------
  # DETERMINE WHICH INGREDIENTS TO USE
  # ------------------------------------------------

  ingredients_being_used = []

  if use_my_ingredients

    # Use ingredients marked "Have" in My Ingredients
    ingredients_being_used =
      ingredients
      .select(&:available)
      .map(&:name)

  elsif !selected_ingredients.empty?

    # Use ingredients manually selected in the filter
    ingredients_being_used =
      selected_ingredients

  end

  # ------------------------------------------------
  # MATCH RECIPES WITH AVAILABLE INGREDIENTS
  # ------------------------------------------------

  unless ingredients_being_used.empty?

    available_names =
      ingredients_being_used.map(&:downcase)

    filtered_recipes.each do |recipe|
      matching_ingredients =
        recipe.ingredients.select do |recipe_ingredient|
          available_names.include?(
            recipe_ingredient.downcase
          )
        end

      missing_ingredients =
        recipe.ingredients.reject do |recipe_ingredient|
          available_names.include?(
            recipe_ingredient.downcase
          )
        end

      recipe_matches[recipe.name] = {

        matching_count:
          matching_ingredients.length,

        total_count:
          recipe.ingredients.length,

        missing:
          missing_ingredients

      }
    end

    # Remove recipes where none of the ingredients match
    filtered_recipes =
      filtered_recipes.select do |recipe|
        recipe_matches[
          recipe.name
        ][:matching_count].positive?
      end

    # Show recipes with the most matching ingredients first
    filtered_recipes =
      filtered_recipes.sort_by do |recipe|
        match =
          recipe_matches[recipe.name]

        [
          -match[:matching_count],
          match[:missing].length
        ]
      end

  end

  # ------------------------------------------------
  # FILTER BY MAXIMUM COOKING TIME
  # ------------------------------------------------

  if max_time && !max_time.empty?

    filtered_recipes =
      filtered_recipes.select do |recipe|
        recipe.cook_time <= max_time.to_i
      end

  end

  all_ingredients =
    recipes.flat_map(&:ingredients).uniq.sort

  erb :index,
      locals: {

        recipes:
          filtered_recipes,

        all_ingredients:
          all_ingredients,

        selected_ingredients:
          selected_ingredients,

        use_my_ingredients:
          use_my_ingredients,

        recipe_matches:
          recipe_matches
      }
end

# --------------------------------------------------
# SHOW ALL RECIPES
# --------------------------------------------------

get '/recipes' do
  erb :recipes,
      locals: {
        recipes: recipes
      }
end

# --------------------------------------------------
# SHOW SPECIFIC RECIPE
# --------------------------------------------------

get '/recipes/:name' do
  if params[:name] == 'new'

    erb :new_recipe

  else

    recipe =
      recipes.find do |r|
        r.name
         .downcase
         .gsub(' ', '-') ==
          params[:name]
      end

    if recipe

      erb :recipe,
          locals: {

            recipe:
              recipe,

            ingredients:
              ingredients
          }

    else

      status 404
      'Recipe not found'

    end

  end
end

# --------------------------------------------------
# ADD NEW RECIPE
# --------------------------------------------------

post '/recipes' do
  if params[:name].nil? ||
     params[:name].strip.empty? ||

     params[:description].nil? ||
     params[:description].strip.empty? ||

     params[:cook_time].nil? ||
     params[:cook_time].strip.empty? ||

     params[:ingredients].nil? ||
     params[:ingredients].strip.empty? ||

     params[:steps].nil? ||
     params[:steps].strip.empty?

    status 400
    return 'Invalid recipe data'

  end

  cook_time =
    params[:cook_time].to_i

  if cook_time <= 0

    status 400
    return 'Invalid recipe data'

  end

  recipe_ingredients =
    params[:ingredients]
    .split(',')
    .map(&:strip)

  steps =
    params[:steps]
    .split("\n")
    .map(&:strip)
    .reject(&:empty?)

  new_recipe =
    Recipe.new(
      params[:name],
      params[:description],
      cook_time,
      recipe_ingredients,
      steps
    )

  recipes << new_recipe

  # Add new recipe ingredients to My Ingredients
  recipe_ingredients.each do |name|
    next if ingredients.any? do |ingredient|
      ingredient.name.downcase ==
      name.downcase
    end

    ingredients <<
      Ingredient.new(name, false)
  end

  save_recipes_to_file(recipes)

  save_ingredients_to_file(ingredients)

  redirect(
    "/recipes/#{
      new_recipe.name
                .downcase
                .gsub(' ', '-')
    }"
  )
end

# --------------------------------------------------
# EDIT RECIPE PAGE
# --------------------------------------------------

get '/recipes/:name/edit' do
  recipe =
    recipes.find do |r|
      r.name
       .downcase
       .gsub(' ', '-') ==
        params[:name]
    end

  if recipe

    erb :edit_recipe,
        locals: {
          recipe: recipe
        }

  else

    status 404
    'Recipe not found'

  end
end

# --------------------------------------------------
# UPDATE RECIPE
# --------------------------------------------------

post '/recipes/:name/update' do
  if params[:new_name].nil? ||
     params[:new_name].strip.empty? ||

     params[:description].nil? ||
     params[:description].strip.empty? ||

     params[:cook_time].nil? ||
     params[:cook_time].strip.empty? ||

     params[:ingredients].nil? ||
     params[:ingredients].strip.empty? ||

     params[:steps].nil? ||
     params[:steps].strip.empty?

    status 400
    return 'Invalid recipe data'

  end

  cook_time =
    params[:cook_time].to_i

  if cook_time <= 0

    status 400
    return 'Invalid recipe data'

  end

  recipe =
    recipes.find do |r|
      r.name
       .downcase
       .gsub(' ', '-') ==
        params[:name]
    end

  if recipe

    recipe.name =
      params[:new_name]

    recipe.description =
      params[:description]

    recipe.cook_time =
      cook_time

    recipe.ingredients =
      params[:ingredients]
      .split(',')
      .map(&:strip)

    recipe.steps =
      params[:steps]
      .split("\n")
      .map(&:strip)
      .reject(&:empty?)

    # Add any new ingredients to My Ingredients
    recipe.ingredients.each do |name|
      next if ingredients.any? do |ingredient|
        ingredient.name.downcase ==
        name.downcase
      end

      ingredients <<
        Ingredient.new(name, false)
    end

    save_recipes_to_file(recipes)

    save_ingredients_to_file(ingredients)

    redirect(
      "/recipes/#{
        recipe.name
              .downcase
              .gsub(' ', '-')
      }"
    )

  else

    status 404
    'Recipe not found'

  end
end

# --------------------------------------------------
# DELETE RECIPE
# --------------------------------------------------

post '/recipes/:name/delete' do
  recipe =
    recipes.find do |r|
      r.name
       .downcase
       .gsub(' ', '-') ==
        params[:name]
    end

  if recipe

    recipes.delete(recipe)

    save_recipes_to_file(recipes)

    redirect '/'

  else

    status 404
    'Recipe not found'

  end
end

# --------------------------------------------------
# INGREDIENT MANAGER
# --------------------------------------------------

get '/ingredients' do
  erb :ingredients,
      locals: {
        ingredients: ingredients
      }
end

# --------------------------------------------------
# TOGGLE INGREDIENT AVAILABILITY
# --------------------------------------------------

post '/ingredients/toggle' do
  ingredient =
    ingredients.find do |item|
      item.name.downcase ==
        params[:name].downcase
    end

  if ingredient

    ingredient.toggle

    save_ingredients_to_file(
      ingredients
    )

    if File.exist?('data/shopping_list.json')

      shopping_list_data = JSON.parse(File.read('data/shopping_list.json'))

      available_ingredient_names = ingredients
                                   .select(&:available)
                                   .map { |i| i.name.downcase }

      shopping_list_data['missing_ingredients'] = shopping_list_data['all_needed_ingredients'].reject do |ing|
        available_ingredient_names.include?(ing.downcase)
      end

      shopping_list_data['last_updated'] = Time.now.to_s

      File.write('data/shopping_list.json', JSON.pretty_generate(shopping_list_data))
    end

  end

  if params[:from_shopping_list] == 'true'
    redirect '/shopping-list'
  else
    redirect '/ingredients'
  end
end

# --------------------------------------------------
# GENERATE SHOPPING LIST
# --------------------------------------------------

post '/shopping-list' do
  selected_recipe_names = params[:selected_recipes] || []

  if selected_recipe_names.empty?
    return "<h1>No recipes selected</h1>
            <p>Please go back and select at least one recipe.</p>
            <a href='/'>Back to Home</a>"
  end

  # Find the selected recipes
  selected_recipes = recipes.select do |recipe|
    selected_recipe_names.include?(recipe.name)
  end

  # Get all ingredients needed for selected recipes
  all_needed_ingredients = []
  selected_recipes.each do |recipe|
    all_needed_ingredients.concat(recipe.ingredients)
  end

  # Remove duplicates and sort
  all_needed_ingredients = all_needed_ingredients.map(&:downcase).uniq.sort

  # Get available ingredients (marked as "Have" in the system)
  available_ingredient_names = ingredients
                               .select(&:available)
                               .map { |i| i.name.downcase }

  # Find missing ingredients (needed but not available)
  missing_ingredients = all_needed_ingredients.reject do |ingredient|
    available_ingredient_names.include?(ingredient.downcase)
  end

  # Save shopping list to file
  shopping_list_data = {
    selected_recipes: selected_recipes.map(&:name),
    missing_ingredients: missing_ingredients,
    all_needed_ingredients: all_needed_ingredients,
    created_at: Time.now.to_s
  }

  File.write('data/shopping_list.json', JSON.pretty_generate(shopping_list_data))

  erb :shopping_list, locals: {
    selected_recipes: selected_recipes,
    missing_ingredients: missing_ingredients,
    all_needed_ingredients: all_needed_ingredients,
    available_ingredient_names: available_ingredient_names
  }
end

# --------------------------------------------------
# VIEW SAVED SHOPPING LIST
# --------------------------------------------------

get '/shopping-list' do
  # Check if shopping list file exists
  if File.exist?('data/shopping_list.json')
    # Load saved shopping list
    shopping_list_data = JSON.parse(File.read('data/shopping_list.json'))

    # Find the selected recipes
    selected_recipes = recipes.select do |recipe|
      shopping_list_data['selected_recipes'].include?(recipe.name)
    end

    # Get current available ingredients
    available_ingredient_names = ingredients
                                 .select(&:available)
                                 .map { |i| i.name.downcase }

    erb :shopping_list, locals: {
      selected_recipes: selected_recipes,
      missing_ingredients: shopping_list_data['missing_ingredients'],
      all_needed_ingredients: shopping_list_data['all_needed_ingredients'],
      available_ingredient_names: available_ingredient_names
    }
  else
    # No saved shopping list
    erb :no_shopping_list
  end
end
