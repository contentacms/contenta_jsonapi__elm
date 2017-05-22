module App.Pages.Frontpage exposing (view)

import App.Model exposing (..)
import Html exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ viewPromotedArticles model
        , viewCurrentMonthIssue model
        , viewCookMenu model
        , viewRecipes model
        , viewFooterMenu
        ]


viewPromotedArticles : Model -> Html Msg
viewPromotedArticles model =
    div [] []


viewCurrentMonthIssue : Model -> Html Msg
viewCurrentMonthIssue model =
    div [] []


viewCookMenu : Model -> Html Msg
viewCookMenu model =
    div []
        [ div []
            [ h3 [] [ text "Inspired to cook" ]
            , h4 [] [ text "What's the occasion?" ]
            ]
        , div []
            [ h3 [] [ text "Learn to cook" ]
            , h4 [] [ text "Articles for the kitchen shy" ]
            ]
        , div []
            [ h3 [] [ text "Backed up" ]
            , h4 [] [ text "Cake, cake, cake" ]
            ]
        , div []
            [ h3 [] [ text "Health & lifestyle" ]
            , h4 [] [ text "Breaking down the carbs" ]
            ]
        ]


viewRecipes : Model -> Html Msg
viewRecipes model =
    div [] []


viewFooterMenu : Model -> Html Msg
viewFooterMenu model =
    div []
        [ div []
            [ h3 [] [ text "Umami publications" ]
            , div [] [ text "Umami Publications are one of the tastiest UK publishers ..." ]
            ]
        , div []
            [ h3 [] [ text "The magazine" ]
            , ul []
                [ li [] [ text "Latest edition" ]
                , li [] [ text "Where to buy" ]
                , li [] [ text "Subscriptions" ]
                , li [] [ text "Back issues" ]
                , li [] [ text "Speak to us" ]
                ]
            ]
        , div []
            [ h3 [] [ text "About us" ]
            , ul []
                [ li [] [ text "About us" ]
                , li [] [ text "Concat us" ]
                ]
            ]
        ]
