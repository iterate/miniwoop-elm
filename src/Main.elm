module Main exposing (main)

import Html exposing (Html, text, textarea, form, button, div, main_, h1)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput, onSubmit, onClick)


-- Model


type alias Model =
    { messages : List Message
    , textInput : String
    }


type alias Message =
    { text : String }


initialModel : Model
initialModel =
    { messages =
        [ Message "Hei"
        , Message "Dette er en test"
        , Message "Lorem ipsum dolar sit amet"
        ]
    , textInput = ""
    }



-- Update


type Msg
    = TextInput String
    | AddMessage


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextInput text ->
            { model | textInput = text }

        AddMessage ->
            let
                message =
                    Message model.textInput
            in
                { model | messages = message :: model.messages, textInput = "" }



-- View


view : Model -> Html Msg
view model =
    main_ [ class "main" ]
        [ h1 [] [ text "MiniWoop" ]
        , div [ class "inputs" ]
            [ textarea [ placeholder "Skriv inn melding", onInput TextInput, value model.textInput ] []
            , button [ onClick AddMessage ] [ text "Send" ]
            ]
        , div [ class "messages" ]
            (List.map viewMessage model.messages)
        ]


viewMessage : Message -> Html Msg
viewMessage message =
    div [ class "message" ]
        [ text message.text ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
