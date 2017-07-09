module App.Pages.RecipesPerDifficultyPage exposing (view)

import App.Model exposing (..)
import App.Difficulty exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData, RemoteData, RemoteData(..))
import App.View.Atom exposing (viewRemoteDataWithTitle)
import App.View.Molecule exposing (recipeCard)
import App.View.Grid exposing (grid4)
import App.View.Organism exposing (..)


view : Model -> PageRecipesPerDifficultyModel -> Html Msg
view model ( difficulty, recipes ) =
    viewRemoteDataWithTitle
        recipesGrid
        recipes
    <|
        case difficulty of
            Easy ->
                "Easy"

            Medium ->
                "Middle"

            Hard ->
                "Hard"
