module Main exposing (main)

import Html exposing (Html, text, textarea, form, button, div, main_, h1)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput, onSubmit, onClick)
import Request.Message
import Http
import Data.Message exposing (Message)


-- Model


type alias Model =
    { messages : List Message
    , textInput : String
    }


init : ( Model, Cmd Msg )
init =
    ( { messages = []
      , textInput = ""
      }
    , Request.Message.list |> Http.send MessagesReceived
    )



-- Update


type Msg
    = TextInput String
    | AddMessage
    | MessagesReceived (Result Http.Error (List Message))
    | MessagePosted (Result Http.Error (List Message))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextInput text ->
            { model | textInput = text } ! []

        AddMessage ->
            let
                message =
                    Message model.textInput
            in
                model
                    ! [ Request.Message.post message
                            |> Http.send MessagePosted
                      ]

        MessagesReceived (Ok messages) ->
            { model | messages = messages |> List.reverse } ! []

        MessagesReceived (Err err) ->
            Debug.crash <| "Could not get messages " ++ (toString err)

        MessagePosted (Ok messages) ->
            { model | messages = messages |> List.reverse, textInput = "" } ! []

        MessagePosted (Err err) ->
            Debug.crash <| "Could not get messages " ++ (toString err)



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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
