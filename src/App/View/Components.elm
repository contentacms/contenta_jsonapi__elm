module App.View.Components exposing (viewRemoteData, onClickPreventDefault)

import App.Model exposing (..)
import Html exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode
import App.PageType exposing (Page(..))
import Html.Attributes exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import Material.Spinner
import Material.Layout as Layout
import Material.Options as Options


viewRemoteData : (a -> Html msg) -> WebData a -> Html msg
viewRemoteData innerView webdata =
    case webdata of
        NotAsked ->
            text "Initialisting"

        Loading ->
            Material.Spinner.spinner []

        Failure err ->
            text ("Error: " ++ toString err)

        Success a ->
            innerView a


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
    a [ onClickPreventDefault (SetActivePage <| RecipesPerTagPage term.name) ] [ text term.name ]


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
    onWithOptions
        "click"
        { preventDefault = True
        , stopPropagation = True
        }
        (Json.Decode.succeed msg)
