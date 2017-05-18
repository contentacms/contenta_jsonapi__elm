module Main exposing (main)

import Html
import Html.App
import Http
import Task
import Html.Events exposing (onClick)
import Platform.Cmd exposing ((!))
import Platform.Sub exposing (Sub)
import Json.Decode exposing ((:=))
import JsonApi
import JsonApi.Resources
import JsonApi.Http
import Debug


main =
    Html.App.program
        { init = initialModel ! []
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type Message
    = GetInitialModel
    | ProtagonistLoaded JsonApi.Resource
    | ProtagonistFailedToLoad Http.Error


view model =
    Html.div []
        [ Html.p [] [ Html.text "A long time ago in a galaxy far, far away..." ]
        , renderProtagonist model
        ]


renderProtagonist model =
    case model.protagonist of
        Nothing ->
            Html.button [ Html.Events.onClick GetInitialModel ] [ Html.text "Get Initial Model" ]

        Just character ->
            Html.p [] [ Html.text (character.firstName ++ " " ++ character.lastName) ]


update message model =
    case message of
        GetInitialModel ->
            model ! [ getProtagonist ]

        ProtagonistLoaded resource ->
            { model | protagonist = JsonApi.Resources.attributes characterDecoder resource |> Result.toMaybe } ! []

        ProtagonistFailedToLoad e ->
            Debug.log ("Remember to start the server on port 9292! " ++ toString e) (model ! [])


type alias Model =
    { protagonist : Maybe Character
    }


type alias Character =
    { firstName : String
    , lastName : String
    }


characterDecoder : Json.Decode.Decoder Character
characterDecoder =
    Json.Decode.object2 Character
        ("first-name" := Json.Decode.string)
        ("last-name" := Json.Decode.string)


initialModel =
    { protagonist = Nothing
    }


getProtagonist : Cmd Message
getProtagonist =
    JsonApi.Http.getPrimaryResource "http://localhost:9292/luke"
        |> Task.perform ProtagonistFailedToLoad ProtagonistLoaded
