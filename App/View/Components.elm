module App.View.Components exposing (viewRecipe, viewRemoteData, viewTags)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData exposing (WebData, RemoteData(..))


viewRemoteData : (a -> Html msg) -> WebData a -> Html msg
viewRemoteData innerView webdata =
    case webdata of
        NotAsked ->
            text "Initialisting"

        Loading ->
            text "Loading"

        Failure err ->
            text ("Error: " ++ toString err)

        Success a ->
            innerView a


viewRecipe : Recipe -> Html Msg
viewRecipe recipe =
    div []
        [ h3 [] [ text "Title" ]
        , p [] [ text (toString recipe.title) ]
        , h3 [] [ text "Image" ]
        , Maybe.map (\url -> (img [ src url ] [])) recipe.image
            |> Maybe.withDefault (p [] [ text "No image" ])
        , h3 [] [ text "Difficulty" ]
        , p [] [ text (toString recipe.difficulty) ]
        , h3 [] [ text "Ingredients" ]
        , ul [] (List.map (\inc -> li [] [ text inc ]) recipe.ingredients)
        , h3 [] [ text "Preparation time" ]
        , p [] [ text (toString recipe.prepTime) ]
        , h3 [] [ text "Total time" ]
        , p [] [ text (toString recipe.totalTime) ]
        , h3 [] [ text "Instruction" ]
        , p [] [ text (toString recipe.recipeInstruction) ]
        ]


viewTags : List Term -> Html Msg
viewTags terms =
    ul []
        (List.map
            (\tag ->
                li [] [ viewTag tag ]
            )
            terms
        )


viewTag : Term -> Html Msg
viewTag term =
    text term.name
