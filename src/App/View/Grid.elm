module App.View.Grid exposing (grid4, grid2x2, grid1__2, grid1__1, grid1__, grid2__2)

import App.Model exposing (..)
import Html exposing (..)
import Material.Grid as Grid


grid4 : List (Html Msg) -> Html Msg
grid4 elements =
    Grid.grid [] <|
        List.map (\elem -> Grid.cell [ Grid.size Grid.All 3 ] [ elem ]) elements


grid2x2 : List (Html Msg) -> Html Msg
grid2x2 elements =
    Grid.grid [] <|
        List.map (\elem -> Grid.cell [ Grid.size Grid.All 6 ] [ elem ]) elements


grid2__2 : Html Msg -> Html Msg -> Html Msg -> Html Msg -> Html Msg
grid2__2 el1 el2 el3 el4 =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 6 ] [ el1 ]
        , Grid.cell [ Grid.size Grid.All 6 ] [ el2 ]
        , Grid.cell [ Grid.size Grid.All 6 ] [ el3 ]
        , Grid.cell [ Grid.size Grid.All 6 ] [ el4 ]
        ]


grid1__2 : Html Msg -> Html Msg -> Html Msg -> Html Msg
grid1__2 el1 el2 el3 =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 6 ] [ el1 ]
        , Grid.cell [ Grid.size Grid.All 3 ] [ el2 ]
        , Grid.cell [ Grid.size Grid.All 3 ] [ el3 ]
        ]


grid1__1 : Html Msg -> Html Msg -> Html Msg
grid1__1 el1 el2 =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 6 ] [ el1 ]
        , Grid.cell [ Grid.size Grid.All 6 ] [ el2 ]
        ]


grid1__ : Html Msg -> Html Msg
grid1__ el1 =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12 ] [ el1 ]
        ]
