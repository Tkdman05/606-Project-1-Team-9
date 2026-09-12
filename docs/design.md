## 1. Overview
CookAssist is a recipe management application designed to help users find, view, and manage recipes. The application is built using Ruby and Sinatra with ERB templates for the user interface.
The main goal of the application is to provide a simple way for users to browse recipes, search by recipe name, filter recipes by ingredients and maximum cooking time, and eventually manage their own recipes and shopping lists.
The application is designed to be simple and easy to extend as additional features are implemented.

## 2. System Architecture
>    Sinatra application (app.rb)
    The main application logic is handled in app.rb. It defines the routes and receives the user's search and filter requests. It also processes the selected ingredients, recipe name, and cooking time before deciding which recipes should be displayed.
>    Recipe model (models/recipe.rb)
    We created a separate Recipe class to represent each recipe. It stores the recipe name, description, cooking time, ingredients, and cooking steps. Keeping this information in a model makes the application easier to organize and gives us a place to add recipe-related functionality later.
>    Views (views/)
    We use ERB views to display the information to the user. The main page handles searching and filtering, while the recipe page displays the details and steps for an individual recipe.
>    Styling (public/style.css)
    The CSS is kept separate from the application logic. It controls the layout, recipe cards, search area, filters, buttons, and responsive behavior. This makes it easier to change the appearance of the application without changing how the recipe filtering works.
>    How the components work together
    When a user searches for a recipe or applies filters, the request is sent to Sinatra. The application starts with the available recipes and applies the selected conditions one by one. The filtered recipes are then passed to the ERB view, which displays the results to the user. When a user selects a recipe, Sinatra finds the corresponding Recipe object and displays its details.

## 3. User Interface Design
The CookAssist interface is designed to make finding a recipe simple and straightforward. The main page has a search bar where users can search by recipe name, along with ingredient checkboxes and a maximum cooking time filter. These options are designed to work together, so users can combine different filters to narrow down their results. Matching recipes are displayed as cards with the recipe name, cooking time, description, and a link to view the full recipe. If no recipes match the selected criteria, the user receives a clear message and can change or clear the filters. Selecting View Recipe takes the user to a page showing the recipe's ingredients and cooking steps.

## 4. Design Decisions and Tradeoffs
We chose Sinatra because it is lightweight and simple to work with for the size and scope of CookAssist, allowing us to focus on the required features without adding unnecessary framework complexity. We also created a separate Recipe class to keep recipe information organized and make it easier to add features later. For the user interface, we decided to combine recipe search, ingredient filtering, and cooking-time filtering into one workflow because we wanted users to be able to narrow down recipes naturally instead of using separate search systems. The tradeoff is that combining multiple filters makes the application logic slightly more complex, but it provides a better user experience. We also started with built-in recipes so we could develop and test the core functionality before adding more advanced features such as user-created recipes and persistent storage.