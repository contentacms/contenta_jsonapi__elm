module App.View.Components exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode
import App.PageType exposing (Page(..))
import Html.Attributes exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import Material.Spinner
import Material.Progress as Progress
import Material.Layout as Layout
import Material.Options as Options


{--This are all things which shouldn't belong here --}


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
    onWithOptions
        "click"
        { preventDefault = True
        , stopPropagation = True
        }
        (Json.Decode.succeed msg)
