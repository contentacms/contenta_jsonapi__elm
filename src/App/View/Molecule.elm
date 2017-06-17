module App.View.Molecule exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.View.Components exposing (..)
import App.View.Atom exposing (..)
import App.View.Grid exposing (grid2__2)
import App.PageType exposing (Page(..))
import Material.Card as Card
import Material.Icons.Device as IconsDevice
import Material.Icons.Action as IconsAction
import Material.Icons.Editor as IconsEditor
import Color
import Svg


recipeCard : Recipe -> Html Msg
recipeCard recipe =
    div [ onClick <| SetActivePage <| RecipeDetailPage recipe.id ]
        [ h3 [] [ a [ onClick <| SetActivePage <| RecipeDetailPage recipe.id, href "#" ] [ cardTitle recipe.title ] ]
        , imageInCard <| Maybe.withDefault "http://placekitten.com/g/200/300" recipe.image
        , cardTags <| List.map (.name) recipe.tags
        ]


articleCard : Article -> Html Msg
articleCard article =
    div []
        [ image <| Maybe.withDefault "http://placekitten.com/g/200/300" article.image
        , cardTags [ "No article tags yet?" ]
        , cardTitle article.title
        ]


featureImage : String -> Html Msg
featureImage =
    image


authorBlock : String -> String -> String -> String -> Html Msg
authorBlock title authorName authorImage authorText =
    div []
        [ blockTitle title
        , div []
            [ image authorImage
            , h4 [] [ text authorName ]
            ]
        , p [] [ text authorText ]
        ]


moreFeaturedArticlesBlock : List Article -> Html Msg
moreFeaturedArticlesBlock articles =
    div
        []
        [ blockTitle "More featured article"
        ]


recipesDetailMetadata : Recipe -> Html Msg
recipesDetailMetadata recipe =
    grid2__2
        (recipeDetailItem (mIcon IconsDevice.access_time) "Preperation time" <| (toString recipe.prepTime) ++ " minutes")
        (recipeDetailItem (mIcon IconsDevice.access_time) "Cooking time" <| (toString recipe.totalTime) ++ " minutes")
        (recipeDetailItem (mIcon IconsEditor.format_list_numbered) "Serves" "todo 4")
        (recipeDetailItem (mIcon IconsAction.schedule) "Difficuly" <| (toString recipe.difficulty))


recipeIngredients : Recipe -> Html Msg
recipeIngredients recipe =
    div []
        [ blockTitle "Ingredients for this recipe"
        , ul [] <| List.map (\ingredient -> li [] [ text ingredient ]) recipe.ingredients
        ]


recipeMethod : Recipe -> Html Msg
recipeMethod recipe =
    div []
        [ blockTitle "Method"
        , ol [] <| List.map (\string -> li [] [ text string ]) <| String.split ", " recipe.recipeInstruction
        ]


recipeAuthorLine : Recipe -> Html Msg
recipeAuthorLine recipe =
    div []
        [ text <| "by" ++ "TODO: Fetch name"
        , div [] [ text "Tag", cardTags <| List.map (.name) recipe.tags ]
        ]
