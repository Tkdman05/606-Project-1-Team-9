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
- To test individual functionality: 
``` bash
bundle exec rspec spac/<filename_spec>.rb
```
- To test suite: 
``` bash
bundle exec rspec
```
- coverage/index.html to see coverage report

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
