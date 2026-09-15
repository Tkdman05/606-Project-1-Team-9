# frozen_string_literal: true

# recipe.rb
class Recipe
  attr_accessor :name, :description, :cook_time, :ingredients, :steps

  def initialize(name, description, cook_time, ingredients, steps)
    @name = name
    @description = description
    @cook_time = cook_time
    @ingredients = ingredients
    @steps = steps
  end
end
