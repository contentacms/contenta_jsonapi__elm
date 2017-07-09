module App.View.Atom exposing (..)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import App.PageType exposing (..)
import Color
import Svg
import Material.Chip as Chip
import Material.Grid as Grid
import Material.Typography as Typography
import Material.Options as Options
import App.View.Components exposing (onClickPreventDefault)
import RemoteData exposing (WebData, RemoteData(..))
import Material.Progress as Progress


image url =
    img [ src url ] []


imageInCard url =
    img [ attribute "width" "100%", src url ] []


imageBig url =
    img [ attribute "width" "100%", src url ] []


mIcon : (Color.Color -> Int -> Svg.Svg msg) -> Html msg
mIcon icon =
    Svg.svg [ width 48, height 48 ] [ icon Color.black 48 ]


imageWithAlt url altString =
    img [ src url, alt altString ] []


siteTitle : String -> Html Msg
siteTitle title =
    Options.styled h1
        [ Typography.display4 ]
        [ text title ]


pageTitle : String -> Html msg
pageTitle title =
    Options.styled h2
        [ Typography.display3 ]
        [ text title ]


sectionTitle : String -> Html Msg
sectionTitle title =
    Options.styled h3
        [ Typography.display2 ]
        [ text title ]


blockTitle : String -> Html Msg
blockTitle title =
    h4 [] [ text title ]


cardTags : List String -> Html msg
cardTags tags =
    div [] <|
        List.map
            (\tag ->
                Chip.span []
                    [ Chip.content [] [ text tag ]
                    ]
            )
            tags


cardTagsInline : List String -> Html Msg
cardTagsInline tags =
    span [] <|
        List.map
            (\tag ->
                Chip.button []
                    [ Chip.content [] [ span [ onClickPreventDefault (SetActivePage <| RecipesPerTagPage tag) ] [ text tag ] ] ]
            )
            tags


cardTitle string =
    h3 [] [ text string ]


moreLink : Html Msg
moreLink =
    div [] [ text "more" ]


recipeDetailItem : Html Msg -> String -> String -> Html Msg
recipeDetailItem icon title itemText =
    div []
        [ icon
        , div []
            [ span [] [ b [] [ text (title ++ ": ") ] ]
            , span [] [ text itemText ]
            ]
        ]


recipeLink : Recipe -> List (Html Msg) -> Html Msg
recipeLink recipe children =
    a [ onClick <| SetActivePage <| RecipeDetailPage recipe.id ] children


viewRemoteData : (a -> Html msg) -> WebData a -> Html msg
viewRemoteData innerView webdata =
    case webdata of
        NotAsked ->
            text "Initialisting"

        Loading ->
            Progress.indeterminate

        Failure err ->
            text ("Error: " ++ toString err)

        Success a ->
            innerView a


viewRemoteDataWithTitle : (a -> Html msg) -> WebData a -> String -> Html msg
viewRemoteDataWithTitle innerView webdata title =
    div []
        [ pageTitle title
        , case webdata of
            NotAsked ->
                text "Initialisting"

            Loading ->
                Progress.indeterminate

            Failure err ->
                text ("Error: " ++ toString err)

            Success a ->
                innerView a
        ]
