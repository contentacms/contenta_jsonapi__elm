module App.Model exposing (..)

import Http
import JsonApi

type Msg
    = RecipeLoaded (Result Http.Error (List JsonApi.Resource))
    | GetInitialModel

type alias Recipe =
    { title : String
    , field_total_time : Int
    }


type alias Model =
    { recipe : Maybe (List Recipe) }

