module App.PageType exposing (..)

import App.Difficulty exposing (..)


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
    | RecipesPerDifficultyPage Difficulty
    | RecipesShorterThanNMinutesPage Int
