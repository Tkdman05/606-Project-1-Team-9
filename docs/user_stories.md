1. As a home cook, I want to add my own recipes so that I can keep my favorite recipes in one place\
Acceptance criteria:
- User can enter recipe name, description, cooking time, and ingredients list
- Recipe is saved and appears in the recipe collection

2. As a new cook, I want to have access to pre-loaded recipes so that I can start cooking without needing my own recipes\
Acceptance criteria:
- Built-in recipes are available upon first app launch
- Built-in recipes appear in browse and search results

3. As a user, I want to delete/edit my saved recipes so that I can keep my collection of recipes organized and relevant\
Acceptance criteria:
- User can select a recipe to delete/edit
- User can modify any field (name, description, time, ingredients)
- System asks for confirmation before deletion
- Recipe is removed from the collection after confirmation
- Changes are saved and reflected immediately

4. As a cook, I want to search for recipes by name so that I can quickly find a specific recipe I'm looking for\
Acceptance criteria:
- User can enter partial or full recipe name
- System displays matching recipes

5. As a busy student, I want to filter recipes by cook time so that I can find quick meals fast\
Acceptance criteria:
- User can specify filtering by fastest cook time
- System displays all recipes in order of fastest to slowest cook time

6. As a user on a diet, I want to search for recipes by specific ingredients so that I can avoid those foods\
Acceptance criteria:
- User can enter one or more ingredient names
- System displays recipes containing those ingredients
- System can alternatively display recipes not containing those ingredients

7. As an organized cook, I want to mark which ingredients I have at home so that I can know what I need to buy for recipes\
Acceptance criteria:
- User can mark ingredients as available/unavailable
- System remembers ingredient availability between sessions
- User can view list of currently available ingredients

8. As an organized cook, I want to generate a shopping list for a specific recipe so that I can know exactly what to buy at the store\
Acceptance criteria:
- User can select a recipe to generate shopping list
- System identifies missing ingredients (not marked as available)
- Shopping list displays only missing ingredients
