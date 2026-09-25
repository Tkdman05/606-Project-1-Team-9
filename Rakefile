# frozen_string_literal: true

# Rakefile

require 'json'
require 'fileutils'

desc 'Reset all data files to default state'
task :reset_data do
  puts 'Resetting data files...'

  # Default recipes
  default_recipes = [
    {
      name: 'Grilled Cheese Sandwich',
      description: 'A crispy grilled cheese sandwich with melted cheddar cheese.',
      cook_time: 10,
      ingredients: ['bread', 'butter', 'cheddar cheese'],
      steps: [
        'Butter one side of each slice of bread.',
        'Place a skillet over medium heat.',
        'Place one slice of bread butter-side down in the skillet.',
        'Add cheddar cheese on top of the bread.',
        'Place the second slice of bread on top, butter-side up.',
        'Cook until the bottom is golden brown, then flip.',
        'Cook the other side until golden brown and the cheese is melted.',
        'Remove from the skillet, slice, and serve.'
      ]
    },
    {
      name: 'Garlic Pasta',
      description: 'A simple pasta dish with garlic, butter, and parmesan.',
      cook_time: 20,
      ingredients: ['pasta', 'garlic', 'butter', 'parmesan cheese'],
      steps: [
        'Bring a pot of salted water to a boil.',
        'Cook the pasta according to the package instructions.',
        'While the pasta cooks, melt butter in a pan over medium heat.',
        'Add minced garlic and cook until fragrant.',
        'Drain the pasta, reserving a small amount of pasta water.',
        'Add the pasta to the pan with the garlic and butter.',
        'Toss everything together and add a little pasta water if needed.',
        'Top with parmesan cheese and serve.'
      ]
    },
    {
      name: 'Mac and Cheese',
      description: 'Creamy and cheesy macaroni and cheese.',
      cook_time: 25,
      ingredients: ['macaroni', 'cheddar cheese', 'milk', 'butter'],
      steps: [
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
    },
    {
      name: 'Fried Rice',
      description: 'Quick fried rice with vegetables, eggs, and soy sauce.',
      cook_time: 15,
      ingredients: ['rice', 'soy sauce', 'eggs', 'carrots', 'peas'],
      steps: [
        'Cook the rice and allow it to cool slightly.',
        'Heat a pan or wok over medium-high heat.',
        'Add the eggs and scramble until cooked.',
        'Add the carrots and peas and cook until tender.',
        'Add the cooked rice to the pan.',
        'Pour in the soy sauce and stir everything together.',
        'Cook for a few minutes until the rice is heated through.',
        'Serve warm.'
      ]
    }
  ]

  # Default ingredients (all set to unavailable initially)
  all_ingredients = default_recipes.flat_map { |r| r[:ingredients] }.uniq.sort
  default_ingredients = all_ingredients.map do |ingredient|
    { name: ingredient, available: false }
  end

  # Create data directory if it doesn't exist
  FileUtils.mkdir_p('data')

  # Write default recipes
  File.write('data/recipes.json', JSON.pretty_generate(default_recipes))
  puts '✓ Reset recipes.json'

  # Write default ingredients
  File.write('data/ingredients.json', JSON.pretty_generate(default_ingredients))
  puts '✓ Reset ingredients.json'

  # Remove shopping list file
  if File.exist?('data/shopping_list.json')
    File.delete('data/shopping_list.json')
    puts '✓ Removed shopping_list.json'
  else
    puts '✓ No shopping_list.json to remove'
  end

  # Remove any backup files
  Dir.glob('data/*.bak').each do |file|
    File.delete(file)
    puts "✓ Removed backup file: #{File.basename(file)}"
  end

  puts "\n✅ All data files have been reset to default state!"
end

desc 'Run tests'
task :test do
  exec 'rspec'
end

desc 'Run tests then reset data'
task :test_and_reset do
  system('rspec')
  Rake::Task['reset_data'].invoke
end

desc 'Clean all generated files'
task clean: :reset_data

# Default task
task default: :test
