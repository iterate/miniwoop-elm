-- http://iter.at/elmkurs
--
-- npm install -g elm elm-live
-- mkdir miniwoop-elm2
-- mkdir src
-- touch src/Main.elm
-- elm-live --output=elm.js src/Main.elm --open --debug
-- 1. Hello World
-- 2. Add Model with messages / init with beginnerProgram / AddMessage
-- 3. Go on


module Main exposing (main)

import Html exposing (Html, text, textarea, form, button, div, main_, h1, h2, input)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput, onSubmit, onClick)
import Request.Message
import Http
import Data.Message exposing (PostMessage, Message)


-- Model


type alias Model =
    { messages : List Message
    , textInput : String
    , username : Maybe String
    , usernameInput : String
    }


init : ( Model, Cmd Msg )
init =
    ( { messages = []
      , textInput = ""
      , username = Nothing
      , usernameInput = ""
      }
    , Request.Message.list |> Http.send MessagesReceived
    )



-- Update


type Msg
    = TextInput String
    | AddMessage String
    | MessagesReceived (Result Http.Error (List Message))
    | MessagePosted (Result Http.Error Message)
    | InputUsername String
    | SetUsername
    | WoopClick Message
    | MessageWooped (Result Http.Error Message)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextInput text ->
            { model | textInput = text } ! []

        AddMessage user ->
            let
                message =
                    PostMessage model.textInput user
            in
                model
                    ! [ Request.Message.post message
                            |> Http.send MessagePosted
                      ]

        MessagesReceived (Ok messages) ->
            { model | messages = messages |> List.reverse } ! []

        MessagesReceived (Err err) ->
            Debug.crash <| "Could not get messages " ++ (toString err)

        InputUsername input ->
            { model | usernameInput = input } ! []

        SetUsername ->
            { model | username = Just model.usernameInput } ! []

        MessagePosted (Ok messages) ->
            { model | textInput = "" } ! [ Request.Message.list |> Http.send MessagesReceived ]

        MessagePosted (Err err) ->
            Debug.crash <| "Could not post message " ++ (toString err)

        WoopClick msg ->
            model ! [ Request.Message.woop msg |> Http.send MessageWooped ]

        MessageWooped (Ok messages) ->
            { model | textInput = "" } ! [ Request.Message.list |> Http.send MessagesReceived ]

        MessageWooped (Err err) ->
            Debug.crash <| "Could not woop message " ++ (toString err)



-- View


view : Model -> Html Msg
view model =
    main_ [ class "main" ]
        [ h1 [] [ text "MiniWoop" ]
        , case model.username of
            Nothing ->
                viewSetUsername model

            Just username ->
                viewMessages model username
        ]


viewMessages : Model -> String -> Html Msg
viewMessages model user =
    div []
        [ div [ class "inputs" ]
            [ textarea [ placeholder "Skriv inn melding", onInput TextInput, value model.textInput ] []
            , button [ onClick (AddMessage user) ] [ text "Send" ]
            ]
        , div [ class "messages" ]
            (List.map viewMessage model.messages)
        ]


viewSetUsername : Model -> Html Msg
viewSetUsername model =
    form [ class "set-username", onSubmit SetUsername ]
        [ h2 [] [ text "Hvem er du?" ]
        , input [ onInput InputUsername, placeholder "Brukernavn" ] []
        , button [] [ text "OK" ]
        ]


viewMessage : Message -> Html Msg
viewMessage message =
    div [ class "message" ]
        [ div [ class "user" ] [ text message.user ]
        , div [ class "text" ] [ text message.text ]
        , div [ class "woops" ] [ text (toString message.woops) ]
        , button [ class "woop-button", onClick (WoopClick message) ] [ text "woop" ]
        ]


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
