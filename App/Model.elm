module App.Model exposing (..)

import App.PageType exposing (..)
import Http
import JsonApi


type Msg
    = RecipeLoaded (Result Http.Error JsonApi.Resource)
    | RecipesLoaded (Result Http.Error (List JsonApi.Resource))
    | GetRecipe String
    | GetRecipes
    | SetActivePage Page
    | SelectRecipe String


type alias Recipe =
    { id : String
    , title : String
    , difficulty : String
    , ingredients : List String
    , totalTime : Int
    , prepTime : Int
    , recipeInstruction : String
    , image : Maybe String
    }


type alias File =
    { uuid : String
    , url : String
    }


type alias Model =
    { recipes : Maybe (List Recipe)
    , selectedRecipe : Maybe String
    , currentPage : Page
    }
