module App.PageType exposing (..)


type alias RecipeId =
    String


type Page
    = Home
    | RecipeList
    | RecipePage RecipeId
