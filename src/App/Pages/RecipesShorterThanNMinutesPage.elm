module App.Pages.RecipesShorterThanNMinutesPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData, RemoteData, RemoteData(..))
import App.View.Atom exposing (viewRemoteDataWithTitle)
import App.View.Molecule exposing (recipeCard)
import App.View.Grid exposing (grid4)
import App.View.Organism exposing (..)


view : Model -> PageRecipesShorterThanModel -> Html Msg
view model ( minutes, recipes ) =
    viewRemoteDataWithTitle
        recipesGrid
        recipes
        ("Quicker than " ++ (toString minutes) ++ " minutes")
