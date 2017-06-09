module App.View.Organism exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.View.Atom exposing (..)
import App.View.Molecule exposing (..)
import App.PageType exposing (..)


recipesPerCategory : String -> List Recipe -> Html Msg
recipesPerCategory title recipes =
    div []
        [ recipeCategoryTitle title
        , div [] <|
            List.map
                recipeCard
                recipes
        ]


articleCardList : List Article -> Html Msg
articleCardList articles =
    div [] <| List.map articleCard articles


recipeDetailHeader : Recipe -> Html Msg
recipeDetailHeader recipe =
    -- @todo 2 column grid?
    div []
        [ imageBig <| Maybe.withDefault "http://placekitten.com/g/200/300" recipe.image
        , div []
            [ recipesDetailMetadata recipe
            , text "Todo fetch description"
            ]
        ]


recipeDetailMain : Recipe -> Html Msg
recipeDetailMain recipe =
    div []
        [ recipeIngredients recipe
        , recipeMethod recipe
        ]


recipesFeaturedHeader : Html Msg
recipesFeaturedHeader =
    text "TODO Implement featured recipe header on recipes category listing"


recipeMoreArticlesTeaser : Html Msg
recipeMoreArticlesTeaser =
    text "TODO Implement more articles teaser"


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
            , li [] [ a [ href "#", onClick (SetActivePage AboutUs) ] [ text "About us" ] ]
            ]
        ]
