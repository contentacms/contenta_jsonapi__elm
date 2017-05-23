module App.Pages.Articles exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)


view : Model -> Html Msg
view model =
    div []
        (model.pages.articles.articles
            |> Maybe.map (List.map viewArticle)
            |> Maybe.withDefault ([ text "No articles" ])
        )


viewArticle : Article -> Html Msg
viewArticle article =
    div []
        [ div []
            [ (article.image
                |> Maybe.map (\url -> img [ src url ] [])
                |> Maybe.withDefault (text "No image")
              )
            ]
        , div []
            [ text "TODO Category"
            ]
        , h3 [] [ text article.title ]
        ]
