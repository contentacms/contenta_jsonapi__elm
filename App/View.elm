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
import List
import List.Extra
import Material as M
import Material.List as ML


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
    let
        html =
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
    in
        withMaterial html


viewHeader : Model -> Html Msg
viewHeader model =
    div []
        [ div []
            []
          --            [ text "Search"
          --            ]
        , h1 [] [ text "Umami, food magazine" ]
        , ML.ul []
            [ ML.li [] [ a [ href "#", onClick (SetActivePage Home) ] [ text "Home" ] ]
            , ML.li [] [ a [ href "#", onClick (SetActivePage ArticleList) ] [ text "Features" ] ]
            , ML.li [] [ a [ href "#", onClick (SetActivePage RecipesPerCategoryList) ] [ text "Recipes" ] ]
            , ML.li [] [ a [ href "#", onClick (SetActivePage AboutUs) ] [ text "About us" ] ]
            ]
        ]
