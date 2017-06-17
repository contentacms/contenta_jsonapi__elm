module App.Pages.ContactPage exposing (view)

import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src, type_, value)
import Html.Events exposing (onInput, onSubmit, onClick)
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Button as Button


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ Textfield.render Mdl
                [ 0 ]
                model.mdl
                [ Textfield.label "Name"
                , Options.onInput <| ContactM << SetName
                , Textfield.floatingLabel
                ]
                []
            ]
        , div []
            [ Textfield.render Mdl
                [ 1 ]
                model.mdl
                [ Textfield.label "Email address"
                , Options.onInput <| ContactM << SetEmail
                , Textfield.floatingLabel
                ]
                []
            ]
        , div []
            [ Textfield.render Mdl
                [ 2 ]
                model.mdl
                [ Textfield.label "Telephone"
                , Options.onInput <| ContactM << SetTelephone
                , Textfield.floatingLabel
                ]
                []
            ]
        , div []
            [ Textfield.render Mdl
                [ 3 ]
                model.mdl
                [ Textfield.label "Subject"
                , Options.onInput <| ContactM << SetSubject
                , Textfield.floatingLabel
                ]
                []
            ]
        , div []
            [ Textfield.render Mdl
                [ 4 ]
                model.mdl
                [ Textfield.label "Message"
                , Textfield.floatingLabel
                , Textfield.textarea
                , Textfield.rows 6
                , Options.onInput <| ContactM << SetMessage
                , Textfield.floatingLabel
                ]
                []
            ]
        , div []
            [ Button.render Mdl
                [ 5 ]
                model.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick <| ContactM SubmitForm
                ]
                [ text "Submit" ]
            ]
        ]
