module App.View.Components exposing (viewRemoteData, onClickPreventDefault)

import App.Model exposing (..)
import Html exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode
import Html.Attributes exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import Material.Spinner


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
    text term.name


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
    onWithOptions
        "click"
        { preventDefault = True
        , stopPropagation = False
        }
        (Json.Decode.succeed msg)
