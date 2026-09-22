# frozen_string_literal: true

require_relative '../models/ingredient'

RSpec.describe Ingredient do

  describe '#initialize' do
    it 'creates an ingredient as unavailable by default' do
      ingredient = Ingredient.new('bread')

      expect(ingredient.name).to eq('bread')
      expect(ingredient.available).to be false
    end

    it 'can create an available ingredient' do
      ingredient = Ingredient.new('bread', true)

      expect(ingredient.available).to be true
    end
  end

  describe '#toggle' do
    it 'changes an unavailable ingredient to available' do
      ingredient = Ingredient.new('bread', false)

      ingredient.toggle

      expect(ingredient.available).to be true
    end

    it 'changes an available ingredient to unavailable' do
      ingredient = Ingredient.new('bread', true)

      ingredient.toggle

      expect(ingredient.available).to be false
    end
  end

end