module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.Pages.Home
import App.Pages.Articles
import App.Pages.AboutUs
import App.Pages.RecipeDetailPage
import App.Pages.RecipesPerCategoryList
import Html exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (..)
import App.View.Organism exposing (viewHeader)
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

            RecipeDetailPage id ->
                App.Pages.RecipeDetailPage.view model

            RecipesPerCategoryList ->
                App.Pages.RecipesPerCategoryList.view model
          )
        ]


