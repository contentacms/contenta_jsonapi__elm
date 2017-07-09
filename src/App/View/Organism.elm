module App.View.Organism exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.View.Atom exposing (..)
import App.View.Style exposing (cursorPointer)
import App.View.Molecule exposing (..)
import App.View.Grid exposing (grid4, grid4WithStyle, grid1__1)
import App.PageType exposing (..)
import Material.List as ML
import Material.Footer as Footer
import Material.Layout as Layout
import Material.Options as Options
import Material.Elevation as Elevation


recipesPerCategory : List Recipe -> Html Msg
recipesPerCategory recipes =
    if (List.length recipes) > 0 then
        div []
            [ grid4WithStyle [ Elevation.e0 ] <|
                List.map
                    recipeCard
                    recipes
            ]
    else
        div [] [ text "No recipes found" ]


recipesGrid : List Recipe -> Html Msg
recipesGrid =
    grid4
        << (List.map recipeCard)


articleCardList : List Article -> Html Msg
articleCardList articles =
    div [] <| List.map articleCard articles


recipeDetailHeader : Recipe -> Html Msg
recipeDetailHeader recipe =
    -- @todo 2 column grid?
    grid1__1
        (imageBig <|
            Maybe.withDefault "http://placekitten.com/g/200/300"
                recipe.image
        )
        (div
            []
            [ recipesDetailMetadata recipe
              {--@todo no description yet --}
            , text ""
            ]
        )


recipeDetailMain : Recipe -> Html Msg
recipeDetailMain recipe =
    grid1__1
        (recipeIngredients
            recipe
        )
        (recipeMethod
            recipe
        )


recipesFeaturedHeader : Html Msg
recipesFeaturedHeader =
    text "TODO Implement featured recipe header on recipes category listing"


recipeMoreArticlesTeaser : Html Msg
recipeMoreArticlesTeaser =
    text "TODO Implement more articles teaser"


viewHeader : Model -> Html Msg
viewHeader model =
    let
        liStyle =
            [ Options.css "display" "inline", Options.css "padding-right" "5px" ]
    in
        div
            []
            [ siteTitle "Umami, food magazine"
            , ML.ul []
                [ ML.li liStyle [ a [ href "#", onClick (SetActivePage Home) ] [ text "Home" ] ]
                , ML.li liStyle [ a [ href "#", onClick (SetActivePage ArticleList) ] [ text "Features" ] ]
                , ML.li liStyle [ a [ href "#", onClick (SetActivePage RecipesPerCategoryList) ] [ text "Recipes" ] ]
                , ML.li liStyle [ a [ href "#", onClick (SetActivePage AboutUs) ] [ text "About us" ] ]
                ]
            ]


viewFooter : Model -> Html Msg
viewFooter model =
    Footer.mini []
        { left = Footer.left [] [ Footer.logo [] [ Footer.html <| text "Umami Publications example footer content. Integer psuere erat a ante venenatis dapibus ..." ] ]
        , right =
            Footer.right []
                [ Footer.links []
                    [ Footer.linkItem [ Footer.href "#", Options.onClick (SetActivePage ContactPage) ] [ Footer.html <| text "Get in touch" ]
                    , Footer.linkItem [ Footer.href "#", Options.onClick (SetActivePage AboutUs) ] [ Footer.html <| text "About the Contenta ELM frontend" ]
                    ]
                ]
        }


viewTabs : List (Html Msg)
viewTabs =
    []


viewMdlHeader : List (Html Msg)
viewMdlHeader =
    [ Layout.row []
        [ Layout.title [ Options.onClick (SetActivePage Home), uncurry Options.css cursorPointer ] [ text "Umami, food magazine" ]
        , Layout.spacer
        , Layout.navigation []
            [ Layout.link [ Layout.href "http://www.contentacms.org/" ] [ img [ height 36, src "assets/contenta-lg.png", alt "Contenta Logo" ] [] ]
            , Layout.link [ Layout.href "https://github.com/contentacms/contenta_jsonapi__elm" ] [ img [ height 36, src "assets/github.png", alt "Github logo" ] [] ]
            , Layout.link [ Layout.href "http://elm-lang.org" ] [ img [ height 36, src "assets/elm_logo_transparent.svg", alt "Elm logo" ] [] ]
            ]
        ]
    ]


viewDrawer : List (Html Msg)
viewDrawer =
    [ Layout.title [] [ text "Umami" ]
    , Layout.navigation []
        [ Layout.link [ Layout.href "#", Options.onClick (ClickDrawerLink Home) ] [ text "Home" ]
        , Layout.link [ Layout.href "#", Options.onClick (ClickDrawerLink ArticleList) ] [ text "Features" ]
        , Layout.link [ Layout.href "#", Options.onClick (ClickDrawerLink RecipesPerCategoryList) ] [ text "Recipes" ]
        , Layout.link [ Layout.href "#", Options.onClick (ClickDrawerLink AboutUs) ] [ text "About us" ]
        ]
    ]
