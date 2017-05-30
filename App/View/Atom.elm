module App.View.Atom exposing (image, cardTags, cardTitle, moreLink, recipeCategoryTitle)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


image url =
    img [ src url ] []


cardTags : List String -> Html msg
cardTags tags =
    ul [] <| List.map (\tag -> li [] [ text tag ])


cardTitle string =
    h3 [] [ text string ]


moreLink : Html Msg
moreLink = div [] [text "more"]

recipesPerCategory: String -> Html msg
recipesPerCategory title = h2 [] [text title]