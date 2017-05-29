module App.PageType exposing (..)


type alias RecipeId =
    String


type Page
    = Home
    | AboutUs
    | RecipesPerCategoryList
    | ArticleList
    | RecipeSelectionPage
    | RecipeDetailPage String
