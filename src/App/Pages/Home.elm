module App.Pages.Home exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData, RemoteData, RemoteData(..))
import App.View.Components exposing (..)
import App.View.Molecule exposing (..)
import App.View.Grid exposing (grid4, grid2x2, grid1__2, grid1__1, grid1__)
import Material.List as ML
import Material.Options as Options
import List
import List.Extra


view : Model -> Html Msg
view model =
    div []
        [ viewPromotedContent model
        , viewCurrentMonthIssue model
        , viewCookMenu model
        , viewRecipes model
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
        emptyDiv =
            div [] []
    in
        viewRemoteData
            (\data ->
                case List.length data of
                    0 ->
                        div [] []

                    1 ->
                        grid1__ (Maybe.withDefault emptyDiv <| Maybe.map viewSinglePromotedContent <| List.head data)

                    2 ->
                        grid1__1
                            (Maybe.withDefault emptyDiv <| Maybe.map viewSinglePromotedContent <| List.Extra.getAt 0 data)
                            (Maybe.withDefault emptyDiv <| Maybe.map viewSinglePromotedContent <| List.Extra.getAt 1 data)

                    3 ->
                        grid1__2
                            (Maybe.withDefault emptyDiv <| Maybe.map viewSinglePromotedContent <| List.Extra.getAt 0 data)
                            (Maybe.withDefault emptyDiv <| Maybe.map viewSinglePromotedContent <| List.Extra.getAt 1 data)
                            (Maybe.withDefault emptyDiv <| Maybe.map viewSinglePromotedContent <| List.Extra.getAt 2 data)

                    _ ->
                        div [] [ text "this code should not be triggered!!!" ]
            )
        <|
            RemoteData.map (List.take 3) mergedPromotedList


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
    grid4
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
        , h3 [] [ text "Explore recipes across every type of occasion, ingredient and skill level" ]
        , viewRemoteData
            (\data -> grid2x2 <| List.map recipeCard data)
            model.pages.home.recipes
        ]
