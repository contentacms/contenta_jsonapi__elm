module App.View.Atom exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.PageType exposing (..)


image url =
    img [ src url ] []


imageInCard url =
    img [ width 200, height 300, src url ] []


imageBig url =
    img [ width 300, height 400, src url ] []


imageWithAlt url altString =
    img [ src url, alt altString ] []


pageTitle : String -> Html Msg
pageTitle title =
    h2 [] [ text title ]


sectionTitle : String -> Html Msg
sectionTitle =
    pageTitle


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


recipeDetailItem : String -> String -> Html Msg
recipeDetailItem title itemText =
    div []
        [ span [] [ b [] [ text title ] ]
        , span [] [ text itemText ]
        ]


recipeLink : Recipe -> List (Html Msg) -> Html Msg
recipeLink recipe children =
    a [ onClick <| SetActivePage <| RecipeDetailPage recipe.id ] children
