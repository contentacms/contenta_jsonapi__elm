module App.PageType exposing (..)


type alias RecipeId =
    String


type Page
    = Home
    | AboutUs
    | RecipeList
    | RecipeSelectionPage
    | RecipeDetailPage String
