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
import Material.Options as Options exposing (css)
import Material.Typography as Typography
import Material.Elevation as Elevation
import Material.Card as Card
import Material.Grid as Grid
import Material.Color as Color
import Material.Button as Button
import Svg


recipeCard : Recipe -> Html Msg
recipeCard recipe =
    Card.view
        [ Options.onClick <| SetActivePage <| RecipeDetailPage recipe.id
        , css "width" "100%"
        , Elevation.e2
        ]
        [ Card.media []
            [ img [ src <| Maybe.withDefault "http://placekitten.com/g/200/300" recipe.image, style [ ( "width", "100%" ) ] ] []
            ]
        , Card.title
            [ css "padding" "0"
              -- Clear default padding to encompass scrim
            ]
            [ Card.head
                [ css "padding" "16px"
                ]
                [ h3 [] [ text recipe.title ] ]
            ]
        , Card.text []
            [ text "Non-alcoholic syrup used for both its tart and sweet flavour as well as its deep red color." ]
        , Card.actions
            [ Card.border, Options.cs "recipe__tags" ]
          <|
            List.map (\tag -> a [ onClickPreventDefault (SetActivePage <| RecipesPerTagPage tag.name), href <| "/recipes/tag/" ++ tag.name ] [ text tag.name ]) recipe.tags
        ]


articleCard : Article -> Html Msg
articleCard article =
    {- Todo Use a MDL card -}
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
    Options.div [ Elevation.e2 ]
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
        , Options.div []
            [ Maybe.withDefault (text "") <| Maybe.map (.name >> List.singleton >> cardTagsInline) recipe.category
            , cardTagsInline <| List.map (.name) recipe.tags
            ]
        ]


recipeTitleLine : Recipe -> Html Msg
recipeTitleLine recipe =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 10 ] [ pageTitle recipe.title ]
        , Grid.cell [ Grid.size Grid.All 2, Grid.align Grid.Bottom ] [ recipeAuthorLine recipe ]
        ]
