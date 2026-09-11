require 'sinatra'
require_relative 'models/recipe'

recipes = [
  Recipe.new(
    "Grilled Cheese Sandwich",
    "A crispy grilled cheese sandwich with melted cheddar cheese.",
    10,
    ["bread", "cheddar cheese", "butter"],
    [
      "Butter one side of each slice of bread.",
      "Place a skillet over medium heat.",
      "Place one slice of bread butter-side down in the skillet.",
      "Add cheddar cheese on top of the bread.",
      "Place the second slice of bread on top, butter-side up.",
      "Cook until the bottom is golden brown, then flip.",
      "Cook the other side until golden brown and the cheese is melted.",
      "Remove from the skillet, slice, and serve."
    ]
  ),

  Recipe.new(
    "Garlic Pasta",
    "A simple pasta dish with garlic, butter, and parmesan.",
    20,
    ["pasta", "garlic", "butter", "parmesan cheese"],
    [
      "Bring a pot of salted water to a boil.",
      "Cook the pasta according to the package instructions.",
      "While the pasta cooks, melt butter in a pan over medium heat.",
      "Add minced garlic and cook until fragrant.",
      "Drain the pasta, reserving a small amount of pasta water.",
      "Add the pasta to the pan with the garlic and butter.",
      "Toss everything together and add a little pasta water if needed.",
      "Top with parmesan cheese and serve."
    ]
  ),

  Recipe.new(
    "Mac and Cheese",
    "Creamy and cheesy macaroni and cheese.",
    25,
    ["macaroni", "cheddar cheese", "milk", "butter"],
    [
      "Bring a pot of salted water to a boil.",
      "Cook the macaroni according to the package instructions.",
      "Drain the macaroni and set it aside.",
      "Melt butter in a saucepan over medium heat.",
      "Add milk and stir until heated through.",
      "Add shredded cheddar cheese and stir until melted and smooth.",
      "Add the cooked macaroni to the cheese sauce.",
      "Stir until the macaroni is evenly coated.",
      "Serve warm."
    ]
  ),

  Recipe.new(
    "Fried Rice",
    "Quick fried rice with vegetables, eggs, and soy sauce.",
    15,
    ["rice", "eggs", "carrots", "peas", "soy sauce"],
    [
      "Cook the rice and allow it to cool slightly.",
      "Heat a pan or wok over medium-high heat.",
      "Add the eggs and scramble until cooked.",
      "Add the carrots and peas and cook until tender.",
      "Add the cooked rice to the pan.",
      "Pour in the soy sauce and stir everything together.",
      "Cook for a few minutes until the rice is heated through.",
      "Serve warm."
    ]
  )
]

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

get '/recipes/:name' do
  recipe = recipes.find do |r|
    r.name.downcase.gsub(" ", "-") == params[:name]
  end

  if recipe
    erb :recipe, locals: { recipe: recipe }
  else
    status 404
    "Recipe not found"
  end
end

get '/recipes' do
  erb :recipes, locals: { recipes: recipes }
end