# elm-jsonapi-http
HTTP negotiation with JSON API-compliant servers. Intended for use with [elm-jsonapi](https://github.com/noahzgordon/elm-jsonapi).

See the documentation at: http://package.elm-lang.org/packages/noahzgordon/elm-jsonapi-http/latest

## Usage

For a live usage example, see the `/example` directory in the project repo.

**Note: The example app requires you to run a Sinatra server, meaning you will need Ruby and Rack installed.**
1. Compile the elm file: `cd example && elm make Main.elm`
2. Open the resulting html file `[open|tee|firefox] index.html`
3. Run the sinatra server (and make sure it runs on port 9292 if that's not your default): `rackup -p 9292`


```elm
-- from `noahzgordon/elm-jsonapi`
import JsonApi.Resources
-- from `noahzgordon/elm-jsonapi-http`
import JsonApi.Http

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


getProtagonist : Cmd Message
getProtagonist =
    JsonApi.Http.getPrimaryResource "http://localhost:9292/luke"
        |> Task.perform ProtagonistFailedToLoad ProtagonistLoaded


update message model =
    case message of
        ProtagonistLoaded resource ->
            { model | protagonist = JsonApi.Resources.attributes characterDecoder resource |> Result.toMaybe } ! []

        ProtagonistFailedToLoad e ->
            Debug.log ("Remember to start the server on port 9292! " ++ toString e) (model ! [])

```
