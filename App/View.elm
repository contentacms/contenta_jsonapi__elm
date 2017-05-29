module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.Pages.Home
import App.Pages.Articles
import App.Pages.AboutUs
import App.Pages.RecipeSelectionPage
import App.Pages.RecipeDetailPage
import App.Pages.RecipesPerCategoryList
import Html exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (..)
import App.View.Components exposing (viewRecipe)
import List
import List.Extra


view : Model -> Html Msg
view model =
    div []
        [ (viewHeader model)
        , (case model.currentPage of
            Home ->
                App.Pages.Home.view model

            AboutUs ->
                App.Pages.AboutUs.view model

            ArticleList ->
                App.Pages.Articles.view model

            RecipeSelectionPage ->
                App.Pages.RecipeSelectionPage.view model

            RecipeDetailPage id ->
                App.Pages.RecipeDetailPage.view model

            RecipesPerCategoryList ->
                App.Pages.RecipesPerCategoryList.view model
          )
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div []
        [ div []
            []
          --            [ text "Search"
          --            ]
        , h1 [] [ text "Umami, food magazine" ]
        , ul []
            [ li [] [ a [ href "#", onClick (SetActivePage Home) ] [ text "Home" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage ArticleList) ] [ text "Features" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage RecipesPerCategoryList) ] [ text "Recipes" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage (RecipeSelectionPage)) ] [ text "Recipe select" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage AboutUs) ] [ text "About us" ] ]
            ]
        ]
