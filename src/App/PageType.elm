module App.PageType exposing (..)


type alias RecipeId =
    String


type Page
    = Home
    | AboutUs
    | RecipesPerCategoryList
    | ArticleList
    | RecipeDetailPage String
    | ContactPage
    | RecipesPerTagPage String
      {--Ensure it actually works --}
    | RecipesPerCategoryPage String
    | RecipesPerDifficultyPage String
    | RecipesShorterThanNMinutesPage Int
