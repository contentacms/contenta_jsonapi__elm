module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.Pages.Home
import App.Pages.Articles
import App.Pages.AboutUs
import App.Pages.RecipeDetailPage
import App.Pages.RecipesPerCategoryList
import App.Pages.ContactPage
import App.Pages.RecipePerTagPage
import App.Pages.RecipesPerCategory
import Html exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (..)
import App.View.Organism exposing (viewHeader, viewFooter)
import App.View.Organism exposing (..)
import Material.Layout as Layout
import Material.Options as Options
import List
import List.Extra
import Material as M
import Material.Layout as Layout


withMaterial : Html Msg -> Html Msg
withMaterial html =
    div [] <|
        {- Trick from Peter Damoc to load CSS outside of <head>.
           https://github.com/pdamoc/elm-mdl/blob/master/src/Mdl.elm#L63
        -}
        [ node "style"
            [ type_ "text/css" ]
            [ Html.text "@import url(\"/css/material.light_green-amber.min.css\")" ]
          {- This fixes a problem with materalized and the debugger -}
        , node "style" [] [ text ".elm-overlay { z-index: 999;" ]
        , html
        ]


view : Model -> Html Msg
view model =
    let
        main =
            (case model.currentPage of
                Home ->
                    App.Pages.Home.view model model.pageHome

                AboutUs ->
                    App.Pages.AboutUs.view model model.pageAboutUs

                ArticleList ->
                    App.Pages.Articles.view model model.pageArticles

                RecipeDetailPage _ ->
                    App.Pages.RecipeDetailPage.view model model.pageRecipeDetail

                RecipesPerTagPage tag ->
                    App.Pages.RecipePerTagPage.view model model.pageRecipesPerTag

                RecipesPerCategoryList ->
                    App.Pages.RecipesPerCategoryList.view model model.pageRecipes

                RecipesPerCategoryPage category ->
                    App.Pages.RecipesPerCategory.view model model.pageRecipesPerCategory

                ContactPage ->
                    App.Pages.ContactPage.view model model.pageContact
            )
    in
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = viewMdlHeader
            , drawer = viewDrawer
            , tabs = ( viewTabs, [] )
            , main =
                [ {- (viewHeader model) -}
                  div
                    [ style [ ( "max-width", "1024px" ), ( "margin", "0 auto" ), ( "padding", "10px" ) ]
                    ]
                    [ main
                    , (viewFooter model)
                    ]
                ]
            }
            |> withMaterial
