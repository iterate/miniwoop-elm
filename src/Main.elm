-- http://iter.at/elmkurs
--
-- npm install -g elm elm-live
-- mkdir miniwoop-elm2
-- mkdir src
-- touch src/Main.elm
-- elm-live --output=elm.js src/Main.elm --open --debug
-- 1. Hello World
-- 2. Add Model with posts / init with beginnerProgram / AddPost
-- 3. Go on


module Main exposing (main)

import Html exposing (Html, text, textarea, form, button, div, main_, h1, h2, input, header, i)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput, onSubmit, onClick)
import Request.Post
import Http
import Data.Post exposing (NewPost, Post)


-- Model


type alias Model =
    { likes : Int
    , posts : List Post
    , textInput : String
    , username : Maybe String
    , usernameInput : String
    }


init : ( Model, Cmd Msg )
init =
    ( { likes = 0
      , posts = []
      , textInput = ""
      , username = Just "Sindre"
      , usernameInput = ""
      }
    , Request.Post.list |> Http.send PostsReceived
    )



-- Update


type Msg
    = TextInput String
    | AddPost String
    | PostsReceived (Result Http.Error (List Post))
    | PostPosted (Result Http.Error Post)
    | InputUsername String
    | SetUsername
    | LikeClick Post
    | PostLiked (Result Http.Error Post)
    | Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextInput text ->
            { model | textInput = text } ! []

        AddPost user ->
            let
                post =
                    NewPost model.textInput user
            in
                model
                    ! [ Request.Post.post post
                            |> Http.send PostPosted
                      ]

        PostsReceived (Ok posts) ->
            { model | posts = posts |> List.reverse } ! []

        PostsReceived (Err err) ->
            Debug.crash <| "Could not get posts " ++ (toString err)

        InputUsername input ->
            { model | usernameInput = input } ! []

        SetUsername ->
            { model | username = Just model.usernameInput } ! []

        PostPosted (Ok posts) ->
            { model | textInput = "" } ! [ Request.Post.list |> Http.send PostsReceived ]

        PostPosted (Err err) ->
            Debug.crash <| "Could not create post " ++ (toString err)

        LikeClick msg ->
            model ! [ Request.Post.woop msg |> Http.send PostLiked ]

        PostLiked (Ok posts) ->
            { model | textInput = "" } ! [ Request.Post.list |> Http.send PostsReceived ]

        PostLiked (Err err) ->
            Debug.crash <| "Could not like post " ++ (toString err)

        Increment ->
            { model | likes = model.likes + 1 } ! []

        Decrement ->
            { model | likes = model.likes - 1 } ! []



-- View


view : Model -> Html Msg
view model =
    main_ [ class "main" ]
        [ header []
            [ h1 [] [ text "MiniWoop" ]
            , div [ class "counter" ]
                [ button [ onClick Increment ] [ text "+" ]
                , text (toString model.likes)
                , button [ onClick Decrement ] [ text "-" ]
                ]
            ]
        , case model.username of
            Nothing ->
                viewSetUsername model

            Just username ->
                viewPosts model username
        ]


viewPosts : Model -> String -> Html Msg
viewPosts model user =
    div []
        [ div [ class "inputs" ]
            [ textarea [ placeholder "Skriv inn melding", onInput TextInput, value model.textInput ] []
            , button [ onClick (AddPost user) ] [ text "Send" ]
            ]
        , div [ class "posts" ]
            (List.map viewPost model.posts)
        ]


viewSetUsername : Model -> Html Msg
viewSetUsername model =
    form [ class "set-username", onSubmit SetUsername ]
        [ h2 [] [ text "Hvem er du?" ]
        , input [ onInput InputUsername, placeholder "Brukernavn" ] []
        , button [] [ text "OK" ]
        ]


viewPost : Post -> Html Msg
viewPost post =
    div [ class "post" ]
        [ div [ class "user" ] [ text post.user ]
        , div [ class "text" ] [ text post.text ]
        , div [ class "woops" ] [ text (toString post.woops) ]
        , button [ class "woop-button", onClick (LikeClick post) ] [ text "woop" ]
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
