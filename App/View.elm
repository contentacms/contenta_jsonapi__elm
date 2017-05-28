module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import App.Pages.Home
import App.Pages.Articles
import App.Pages.AboutUs
import App.Pages.RecipeSelectionPage
import App.Pages.RecipeList
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

            RecipeList ->
                App.Pages.RecipeList.view model

            ArticleList ->
                App.Pages.Articles.view model

            RecipeSelectionPage ->
                App.Pages.RecipeSelectionPage.view model

            RecipeDetailPage id ->
                model.recipes
                    |> Maybe.andThen List.head
                    |> Maybe.map viewRecipe
                    |> Maybe.withDefault (text "Recipe not found")
          )
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div []
        [ div []
            []
          --            [ text "Search"
          --            , (if (model.loginFormActive) then
          --                a [ onClick (LoginFormState (not model.loginFormActive)) ] [ text "Login form" ]
          --               else
          --                viewLoginForm model
          --              )
          --            ]
        , h1 [] [ text "Umami, food magazine" ]
        , ul []
            [ li [] [ a [ href "#", onClick (SetActivePage Home) ] [ text "Home" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage ArticleList) ] [ text "Features" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage RecipeList) ] [ text "Recipes" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage (RecipeSelectionPage)) ] [ text "Recipe select" ] ]
            , li [] [ a [ href "#", onClick (SetActivePage AboutUs) ] [ text "About us" ] ]
            ]
        ]


viewLoginForm : Model -> Html Msg
viewLoginForm model =
    let
        loginDetails =
            Maybe.withDefault
                { name = ""
                , password = ""
                }
                model.loginDetails
    in
        Html.form []
            [ input [ onInput InputLoginName, type_ "textfield", value loginDetails.name ] []
            , input [ onInput InputLoginPassword, type_ "password", value loginDetails.password ] []
            , button [ onClick InputLoginSubmit ] [ text "Login" ]
            ]



