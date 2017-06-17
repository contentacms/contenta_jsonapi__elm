module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.Pages.Home
import App.Pages.Articles
import App.Pages.AboutUs
import App.Pages.RecipeDetailPage
import App.Pages.RecipesPerCategoryList
import App.Pages.ContactPage
import Html exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (..)
import App.View.Organism exposing (viewHeader, viewFooter)
import Material.Layout as Layout
import List
import List.Extra
import Material as M


withMaterial : Html Msg -> Html Msg
withMaterial html =
    div [] <|
        {- Trick from Peter Damoc to load CSS outside of <head>.
           https://github.com/pdamoc/elm-mdl/blob/master/src/Mdl.elm#L63
        -}
        [ node "style"
            [ type_ "text/css" ]
            [ Html.text "@import url(\"/css/material.blue_grey-blue.min.css\")" ]
        , html
        ]


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

            ContactPage ->
                App.Pages.ContactPage.view model
          )
        , (viewFooter model)
        ]
        |> withMaterial



{- conflicts with debugger right now -}
--view : Model -> Html Msg
--view model =
--    Layout.render Mdl
--        model.mdl
--        [ Layout.fixedDrawer
--        ]
--        { header = [ text "" ]
--        , drawer = viewDrawer
--        , tabs = ( [], [] )
--        , main =
--            [ (viewHeader model)
--            , (case model.currentPage of
--                Home ->
--                    App.Pages.Home.view model
--
--                AboutUs ->
--                    App.Pages.AboutUs.view model
--
--                ArticleList ->
--                    App.Pages.Articles.view model
--
--                RecipeDetailPage id ->
--                    App.Pages.RecipeDetailPage.view model
--
--                RecipesPerCategoryList ->
--                    App.Pages.RecipesPerCategoryList.view model
--
--                ContactPage ->
--                    App.Pages.ContactPage.view model
--              )
--            , (viewFooter model)
--            ]
--        }
--        |> withMaterial
