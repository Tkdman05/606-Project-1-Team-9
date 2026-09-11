### 1. As a home cook, I want to add my own recipes to the page so that I can keep my favorite recipes in one place
- Given I am a home cook
- And I am adding the recipe for mac & cheese
- When I enter the recipe information
- Then I should see the recipe appear on the recipe list

### 2. As a new cook, I want to have access to pre-loaded recipes so that I can start cooking without needing my own recipes
- Given I am a home cook
- And I am looking for a pre-loaded meal to cook
- When I open the application for the first time
- Then I should see a selection of recipes to make

### 3. As a home cook, I want to delete/edit my saved recipes so that I can keep my collection of recipes organized and relevant
- Given I am a home cook
- And I am changing one of my recipes
- When I click the recipe
- Then I should see options to delete/edit the recipe

### 4. As a home cook, I want to search for recipes by name so that I can quickly find a specific recipe I'm looking for
- Given I am a home cook
- And I am in the search bar on the application
- When I enter the recipe by name
- Then I should see recipes containing my search

### 5. As a busy student, I want to filter recipes by cook time so that I can find quick meals fast
- Given I am a busy student
- And I am looking at the search filters
- When I click to sort by cook time
- Then I see the shortest time-to-cook recipe first

### 6. As a cook on a diet, I want to search for recipes by specific ingredients so that I can cook with those foods
- Given I am a cook on a diet
- And I am looking at the search bar
- When I type in a certain ingredient
- Then I should see recipes containing that ingredient

### 7. As a home cook, I want to mark which ingredients I have at home so that I can know what I need to buy for recipes
- Given I am a home cook
- And I am looking at the ingredient list
- When I click on an ingredient
- Then the ingredient should be marked absent

### 8. As a home cook, I want to generate a shopping list for a specific recipe so that I can know exactly what to buy at the store
- Given I am a home cook
- And I am looking at a certain recipe
- When I click "make shopping list"
- Then I should see a list of ingredients I don't own

### 9. As a tester/developer, I want to receive clear error messages when entering invalid  data so that I can understand what went wrong
- Given I am a tester/developer
- And I am testing functionality
- When I encounter a sad path
- Then a clear error message appears
