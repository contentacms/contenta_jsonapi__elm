module App.View.Components exposing (viewRemoteData)

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
