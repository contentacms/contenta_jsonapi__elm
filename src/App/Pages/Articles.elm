module App.Pages.Articles exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)
import RemoteData exposing (WebData, RemoteData(..))
import App.View.Components exposing (viewRemoteData)


view : Model -> WebData (List Article) -> Html Msg
view model articles =
    viewRemoteData
        (\data ->
            case data of
                [] ->
                    text "No Articles found"

                list ->
                    div [] <| List.map viewArticle list
        )
        articles


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
