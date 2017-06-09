module App.Pages.Home exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData, RemoteData(..))
import App.View.Components exposing (..)
import App.View.Molecule exposing (..)
import List


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
    --    let
    let
        mergedPromotedList =
            RemoteData.append model.pages.home.promotedArticles model.pages.home.promotedRecipes
                |> RemoteData.map (uncurry (\articles recipes -> List.append (List.map ArticleRef articles) (List.map RecipeRef recipes)))

        --        mergedPromotedList =
        --            List.concat [ List.map ArticleRef model.pages.home.promotedArticles, List.map RecipeRef model.pages.home.promotedRecipes ]
    in
        viewRemoteData
            (\data ->
                case List.length data of
                    0 ->
                        div [] []

                    1 ->
                        div [] <| List.map viewSinglePromotedContent <| List.take 1 data

                    2 ->
                        div [] <| List.map viewSinglePromotedContent <| List.take 2 data

                    -- Provide a better way to extract promoted stuff.
                    _ ->
                        div [] <| List.map viewSinglePromotedContent <| List.take 3 data
            )
            mergedPromotedList


viewSinglePromotedContent : ArticleOrRecipe -> Html Msg
viewSinglePromotedContent articleOrRecipe =
    case articleOrRecipe of
        ArticleRef article ->
            articleCard article

        RecipeRef recipe ->
            recipeCard recipe


viewCurrentMonthIssue : Model -> Html Msg
viewCurrentMonthIssue model =
    div [] []


viewCookMenu : Model -> Html Msg
viewCookMenu model =
    div []
        [ div []
            [ h3 [] [ text "Dinners to impress" ]
            , h4 [] [ text "List recipes" ]
            ]
        , div []
            [ h3 [] [ text "Learn to cook" ]
            , h4 [] [ text "Recipes for beginner" ]
            ]
        , div []
            [ h3 [] [ text "Backed up" ]
            , h4 [] [ text "Delicious cake and bakes" ]
            ]
        , div []
            [ h3 [] [ text "Quick and Easy" ]
            , h4 [] [ text "20 minutes or less" ]
            ]
        ]


viewRecipes : Model -> Html Msg
viewRecipes model =
    div []
        [ h2 [] [ text "Recipes" ]
        , p [] [ text "Explore recipes across every type of occasion, ingredient and skill level" ]
        , viewRemoteData
            (\data -> div [] <| List.map recipeCard data)
            model.pages.home.promotedRecipes
        ]


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
