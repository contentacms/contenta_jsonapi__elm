module App.Model exposing (..)

import App.PageType exposing (..)
import Http
import JsonApi


type Msg
    = RecipesLoaded (Result Http.Error (List JsonApi.Resource))
    | GetInitialModel
    | SetActivePage Page


type alias Recipe =
    { title : String
    , field_total_time : Int
    }


type alias Model =
    { recipe : Maybe (List Recipe)
    , currentPage : Page
    }
