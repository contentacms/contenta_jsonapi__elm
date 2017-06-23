module App.Router exposing (delta2url, location2messages)

import App.Model exposing (..)
import RouteUrl exposing (HistoryEntry(..), UrlChange)
import App.PageType exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (Parser, map, parseHash, s, oneOf, (</>), int, string)


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case current.currentPage of
        Home ->
            Just <| UrlChange NewEntry "/"

        AboutUs ->
            Just <| UrlChange NewEntry "/about-us"

        ArticleList ->
            Just <| UrlChange NewEntry "/features"

        RecipesPerCategoryList ->
            Just <| UrlChange NewEntry "/recipes"

        RecipeDetailPage recipeId ->
            Just <| UrlChange NewEntry ("/recipes/" ++ recipeId)

        ContactPage ->
            Just <| UrlChange NewEntry "/contact"


location2messages : Location -> List Msg
location2messages location =
    case UrlParser.parseHash parseUrl location of
        Just msgs ->
            [ msgs ]

        Nothing ->
            []


parseUrl : Parser (Msg -> c) c
parseUrl =
    oneOf
        [ map (SetActivePage Home) (s "")
        , map (SetActivePage AboutUs) (s "about-us")
        , map (SetActivePage ArticleList) (s "features")
        , map (SetActivePage RecipesPerCategoryList) (s "recipes")
        , map (SetActivePage ContactPage) (s "contact")
        , map (\recipeId -> SetActivePage <| RecipeDetailPage (toString recipeId)) (s "item" </> string)
        ]
