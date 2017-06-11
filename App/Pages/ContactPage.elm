module App.Pages.ContactPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick)


view : ContactForm -> Html Msg
view model =
    div []
        [ label []
            [ text "Your name"
            , input [ type_ "textfield", value model.name, onInput <| ContactM << SetName ] []
            ]
        , label []
            [ text "Your email address"
            , input [ type_ "textfield", value model.email, onInput <| ContactM << SetEmail ] []
            ]
        , label []
            [ text "Telephone"
            , input [ type_ "textfield", value model.telephone, onInput <| ContactM << SetTelephone ] []
            ]
        , label []
            [ text "Subject"
            , input [ type_ "textfield", value model.subject, onInput <| ContactM << SetSubject ] []
            ]
        , label []
            [ text "Message"
            , textarea [ onInput <| ContactM << SetMessage ] [ text model.message ]
            ]
        , button [ onClick <| ContactM SubmitForm ] [ text "Submit" ]
        ]
