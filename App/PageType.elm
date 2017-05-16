module App.PageType exposing (..)


type alias RecipeId =
    String


type Page
    = RecipeList
    | RecipePage RecipeId
