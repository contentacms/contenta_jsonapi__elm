module App.Pages.Home exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData, RemoteData, RemoteData(..))
import App.View.Atom exposing (viewRemoteData)
import App.View.Molecule exposing (..)
import App.View.Grid exposing (grid4, grid2x2, grid1__2, grid1__1, grid1__)
import Material.List as ML
import Material.Options as Options
import App.PageType exposing (..)
import List
import List.Extra


view : Model -> PageHomeModel -> Html Msg
view model pageModel =
    div []
        [ viewPromotedContent pageModel.promotedArticles pageModel.promotedRecipes
        , viewCurrentMonthIssue model
        , viewCookMenu model
        , viewRecipes pageModel.recipes
        ]


viewPromotedContent : WebData (List Article) -> WebData (List Recipe) -> Html Msg
viewPromotedContent promotedArticles promotedRecipes =
    --    let
    let
        mergedPromotedList =
            RemoteData.append promotedArticles promotedRecipes
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
                        grid1__ (Maybe.withDefault emptyDiv <| Maybe.map (viewSinglePromotedContent 0) <| List.head data)

                    2 ->
                        grid1__1
                            (Maybe.withDefault emptyDiv <| Maybe.map (viewSinglePromotedContent 0) <| List.Extra.getAt 0 data)
                            (Maybe.withDefault emptyDiv <| Maybe.map (viewSinglePromotedContent 1) <| List.Extra.getAt 1 data)

                    3 ->
                        grid1__2
                            (Maybe.withDefault emptyDiv <| Maybe.map (viewSinglePromotedContent 0) <| List.Extra.getAt 0 data)
                            (Maybe.withDefault emptyDiv <| Maybe.map (viewSinglePromotedContent 1) <| List.Extra.getAt 1 data)
                            (Maybe.withDefault emptyDiv <| Maybe.map (viewSinglePromotedContent 2) <| List.Extra.getAt 2 data)

                    _ ->
                        div [] [ text "this code should not be triggered!!!" ]
            )
        <|
            RemoteData.map (List.take 3) mergedPromotedList


viewSinglePromotedContent : Int -> ArticleOrRecipe -> Html Msg
viewSinglePromotedContent index articleOrRecipe =
    case articleOrRecipe of
        ArticleRef article ->
            articleCard article

        RecipeRef recipe ->
            if index == 0 then
                recipeCardWithReverse True recipe
            else
                recipeCard recipe


viewCurrentMonthIssue : Model -> Html Msg
viewCurrentMonthIssue model =
    div [] []


viewCookMenu : Model -> Html Msg
viewCookMenu model =
    grid4
        [ div [ onClick <| SetActivePage <| RecipesPerCategoryPage "Main course" ]
            [ h3 [] [ text "Dinners to impress" ]
            , h4 [] [ text "List recipes" ]
            ]
        , div [ onClick <| SetActivePage <| RecipesPerDifficultyPage "easy" ]
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


viewRecipes : WebData (List Recipe) -> Html Msg
viewRecipes recipes =
    div []
        [ h2 [] [ text "Recipes" ]
        , h3 [] [ text "Explore recipes across every type of occasion, ingredient and skill level" ]
        , viewRemoteData
            (\data -> grid2x2 <| List.map recipeCard data)
            recipes
        ]
