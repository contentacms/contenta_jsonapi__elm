module App.View.Grid exposing (grid4)

import App.Model exposing (..)
import Html exposing (..)
import Material.Grid as MGrid


grid4 : List (Html Msg) -> Html Msg
grid4 elements =
    MGrid.grid [] <|
        List.map (\elem -> MGrid.cell [ MGrid.size MGrid.All 4 ] [ elem ]) elements

--grid2x2 : List (Html Msg) -> Html Msg