module App.View.Organism exposing (recipesPerCategory)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

import App.View.Atom exposing (..)
import App.View.Molecule exposing (..)

recipesPerCategory : String -> List Recipe -> Html Msg
recipesPerCategory title recipes
  = div [] [
   recipesPerCategory title
    ]

