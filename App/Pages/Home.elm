module App.Pages.Home exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (..)
import App.View.Molecule exposing (..)
import App.View.Grid exposing (grid4)
import Material.List as ML


view : Model -> Html Msg
view model =
    div []
        [ viewPromotedContent model
        , viewCurrentMonthIssue model
        , viewCookMenu model
        , viewRecipes model
        , viewFooterMenu model
        ]


viewPromotedContent : Model -> Html Msg
viewPromotedContent model =
    div [] []


viewCurrentMonthIssue : Model -> Html Msg
viewCurrentMonthIssue model =
    div [] []


viewCookMenu : Model -> Html Msg
viewCookMenu model =
    grid4
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
    div []
        [ h2 [] [ text "Recipes" ]
        , p [] [ text "Explore recipes across every type of occasion, ingredient and skill level" ]
        , viewRemoteData
            (\data -> grid4 <| List.map viewPromotedRecipe data)
            model.pages.home.promotedRecipes
        ]


viewPromotedRecipe : Recipe -> Html Msg
viewPromotedRecipe =
    recipeCard


viewFooterMenu : Model -> Html Msg
viewFooterMenu model =
    div []
        [ div []
            [ h3 [] [ text "Umami publications" ]
            , div [] [ text "Umami Publications are one of the tastiest UK publishers ..." ]
            ]
        , div []
            [ h3 [] [ text "The magazine" ]
            , ML.ul []
                [ ML.li [] [ text "Latest edition" ]
                , ML.li [] [ text "Where to buy" ]
                , ML.li [] [ text "Subscriptions" ]
                , ML.li [] [ text "Back issues" ]
                , ML.li [] [ text "Speak to us" ]
                ]
            ]
        , div []
            [ h3 [] [ text "About us" ]
            , ML.ul []
                [ ML.li [] [ text "About us" ]
                , ML.li [] [ text "Concat us" ]
                ]
            ]
        ]
