module App.Pages.AboutUs exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Contenta" ]
        , text "Contenta is an API-First Drupal distribution. It's all about the content"
        , h3 [] [ text "Elm Frontend" ]
        , div []
            [ div [] [ text "This frontend is using elm to render the output." ]
            , div [] [ text "Elm is a delightful language for reliable webapps." ]
            , div [] [ text "Generate JavaScript with great performance and no runtime exceptions." ]
            , div [] [ text "Rendering an image works basically like HTML:" ]
            , div []
                [ code [] [ text "<img src=\"http://example.com/example.jpg\"></img>" ]
                ]
            , div []
                [ code [] [ text "img [src \"http://example.com/example.jpg\"] [] " ]
                ]
            ]
        ]
