module App.View.Components exposing (viewRecipe, viewRemoteData)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData exposing (WebData, RemoteData(..))


viewRemoteData : WebData a -> (a -> Html msg) -> Html msg
viewRemoteData webdata innerView =
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
