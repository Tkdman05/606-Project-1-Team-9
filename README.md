# CookAssist
CookAssist is a terminal application that allows users to organize and manage recipes and easily find recipes based on available ingredients and cooking time. Users can maintain a list of ingredients they have available and generate a shopping list for any recipe containing ingredients they are missing. 

### Installation instructions:
Verify ruby installation (3.0.0 +): 

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
- RSpec tests were added to verify the main features implemented for the project. The tests focus on the acceptance criteria for the 6 completed stories
- The tests and coverage report can be run using the command
```bash 
rspec
```
- For more details on tests
```bash
rspec -fd
```
- To test individual functionality: 
``` bash
brspec spc/<filename_spec>.rb
```
- coverage/index.html to see the coverage report

### Main features:
- 4 Built-in, ready-to-make recipes
- Recipe creation, allowing users to save custom recipes/ingredients
- Search bar for recipes
- Filter based on the recipes, ingredients and cook time

### Limitations:
- Ingredient list is not case-sensitive (ie: Bread & bread can both exist)
- Page reloads after every alteration
- Functionality of ingredient selection and shopping list not implemented

### Members: Wyatt Soper & Aditi Chidambara
