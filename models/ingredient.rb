# frozen_string_literal: true

# ingredient.rb
class Ingredient
  attr_accessor :name, :available

  def initialize(name, available = false)
    @name = name
    @available = available
  end

  def toggle
    @available = !@available
  end
end
