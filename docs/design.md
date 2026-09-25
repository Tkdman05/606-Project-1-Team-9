### 1. Overview
This application is built using Ruby and Sinatra with ERB templates for the user interface.
The main goal of the application is to provide a simple way for users to browse recipes, search by recipe name, filter recipes by ingredients and maximum cooking time, and eventually manage their own recipes and shopping lists.
The application is designed to be simple and easy to extend as additional features are implemented.

### 2. System Architecture
- Sinatra application (app.rb)
    The main application logic is handled in app.rb. It defines the routes and receives the user's search, filter requests, create, edit, and delete requests. It also processes the selected ingredients, recipe name, and cooking time before deciding which recipes should be displayed in addition to displaying the proper edit/add_recipe pages with proper functionality on request. Finally, a shopping list can be creted and viewed through processing related POST & get requests.

- Recipe model (models/recipe.rb)
    We created a separate Recipe class to represent each recipe. It stores the recipe name, description, cooking time, ingredients, and cooking steps. Keeping this information in a model makes the application easier to organize and gives us a place to add recipe-related functionality later.

- Ingredient model (models/ingredient.rb)
    The Ingredient class represents each ingredient and stores its name and whether the user currently has it available. Ingredients can be marked as available or missing, which allows the application to keep track of ingredients the user has at home.

- Persistent storage (data/)
    Recipe and ingredient information is stored in JSON files. The ingredient availability is saved so that the user's selections remain available after restarting the application.

- Views (views/)
    We use ERB views to display the information to the user. The main page handles searching and filtering, while the recipe page displays the details and steps for an individual recipe. The edit and add_recipe pages are used to gather user input as altered, or new recipe data.

- Shopping List
    The newly added shopping list utilizes a combination of these features, including the ingredient model to itemize what the user owns and placing them in a persistent shopping_list file. Additionally, views/shopping_list.erb and no_shopping_list.erb are used to display the shooping list (or lack thereof) 

- Styling (public/style.css)
    The CSS is kept separate from the application logic. It controls the layout, recipe cards, search area, filters, buttons, and responsive behavior. This makes it easier to change the appearance of the application without changing how the recipe filtering works.

- Tests (spec/)
    All _spec.rb files are used to test and generate a coverage report using existing application logic. These files are separated by similar functionality, connected by spec_helper to ensure a clean directory, and consistant coverage report.

- How the components work together
    When a user searches for a recipe or applies filters, the request is sent to Sinatra. The application starts with the available recipes and applies the selected conditions one by one. The filtered recipes are then passed to the ERB view, which displays the results to the user. When a user selects a recipe, Sinatra finds the corresponding Recipe object and displays its details. 

### 3. User Interface Design
The user interface is designed to make finding a recipe simple and straightforward. The main page has a search bar where users can search by recipe name, along with ingredient checkboxes and a maximum cooking time filter. These options are designed to work together, so users can combine different filters to narrow down their results. Matching recipes are displayed as cards with the recipe name, cooking time, description, and a link to view the full recipe. If no recipes match the selected criteria, the user receives a clear message and can change or clear the filters. Selecting View Recipe takes the user to a page showing the recipe's ingredients and cooking steps.

The My Ingredients page allows users to mark ingredients as either "Have" or "Missing." Users can then select "Use My Ingredients" on the main page to find recipes based on the ingredients they currently have. Matching recipes show how many required ingredients are available and which ingredients are missing. If all required ingredients are available, the recipe is marked "Ready to Cook."

### 4. Design Decisions and Tradeoffs
We chose Sinatra because it is lightweight and simple to work with for the size and scope of the application, allowing us to focus on the required features without adding unnecessary framework complexity. We also created a separate Recipe class to keep recipe information organized and make it easier to add features later. For the user interface, we decided to combine recipe search, ingredient filtering, and cooking-time filtering into one workflow because we wanted users to be able to narrow down recipes naturally instead of using separate search systems. The tradeoff is that combining multiple filters makes the application logic slightly more complex, but it provides a better user experience. We also opted to use sepatate pages for editing, displaying, and adding recipes for ease of use and testing with the tradeoff being less continuity between pages and having to switch pages often while in use. Finally, we start the application with built-in recipes so we could develop and test the core functionality before adding more advanced features such as user-created recipes and persistent storage.

For ingredient management, we decided to store ingredient availability separately from the recipes. This allows the same ingredient to be used across multiple recipes while keeping one saved availability status. We also chose JSON persistence instead of a database because it is simpler for the scope of this project while still allowing ingredient and recipe data to persist between sessions. Additionally, a JSON is used to maintain a user's shopping list, which utilizes these ingredients and their data (available) to determine what should be shown. This results in a dynamic shopping list that is updated when any ingredients are modified pertaining to the list.