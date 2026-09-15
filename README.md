# CookAssist

CookAssist is a terminal application that allows users to organize and manage recipes and easily find recipes based on available ingredients and cooking time. Users can maintain a list of ingredients they have available and generate a shopping list for any recipe containing ingredients they are missing. 

### Installation instructions:
Verify ruby installation (4.0.6): 

``` bash
ruby -v
bundle -v
bundle install
```

### Running instructions:
```bash
ruby app.rb
```
Navigate to localhost link, Ctrl+C to stop

### Test/report instructions:
- RSpec tests were added to verify the main features implemented for the project. The tests focus on the acceptance criteria for the pre-loaded recipes, recipe name search, cook-time filtering, and ingredient filtering.
- The tests can be run using the command
```bash 
rspec -fd 
```
- These tests provide automated verification that the implemented features continue to work as expected when changes are made to the application.

### Main features:
- 4 Built-in, ready to make recipes
- Recipe creation, allowing users to save custom recipes/ingredients
- Search bar for recipes
- Filter based on the recipes and ingredients

### Limitations:
- No edit/delete recipe functionality yet
- Ingredient list is not case sensitive (ie: Bread & bread can both exist)
- Page reloads after every alteration

### Members: Wyatt Soper & Aditi Chidambara
