module App.View.Atom exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


image url =
    img [ src url ] []


imageInCard url =
    img [ width 200, height 300, src url ] []


imageWithAlt url altString =
    img [ src url, alt altString ] []


blockTitle : String -> Html Msg
blockTitle title =
    h3 [] [ text title ]


cardTags : List String -> Html msg
cardTags tags =
    ul [] <| List.map (\tag -> li [] [ text tag ]) tags


cardTitle string =
    h3 [] [ text string ]


moreLink : Html Msg
moreLink =
    div [] [ text "more" ]


recipeCategoryTitle : String -> Html msg
recipeCategoryTitle title =
    h2 [] [ text title ]
