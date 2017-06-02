module App.View.Molecule exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import App.View.Atom exposing (..)


recipeCard : Recipe -> Html Msg
recipeCard recipe =
    div []
        [ imageInCard <| Maybe.withDefault "http://placekitten.com/g/200/300" recipe.image
        , cardTags <| List.map (.name) recipe.tags
        , cardTitle recipe.title
        ]


articleCard : Article -> Html Msg
articleCard article =
    div []
        [ image <| Maybe.withDefault "http://placekitten.com/g/200/300" article.image
        , cardTags [ "No article tags yet?" ]
        , cardTitle article.title
        ]


featureImage : String -> Html Msg
featureImage =
    image


authorBlock : String -> String -> String -> String -> Html Msg
authorBlock title authorName authorImage authorText =
    div []
        [ blockTitle title
        , div []
            [ image authorImage
            , h4 [] [ text authorName ]
            ]
        , p [] [ text authorText ]
        ]


moreFeaturedArticlesBlock : List Article -> Html Msg
moreFeaturedArticlesBlock articles =
    div
        []
        [ blockTitle "More featured article"
        ]
