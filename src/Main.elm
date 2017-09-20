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


-- Model


type alias Post =
    { id : Int
    , text : String
    , likes : Int
    , user : String
    }


type alias Model =
    { likes : Int
    , posts : List Post
    , textInput : String
    , username : Maybe String
    , usernameInput : String
    , nextId : Int
    }


init : Model
init =
    { likes = 0
    , posts = []
    , textInput = ""
    , username = Nothing
    , usernameInput = ""
    , nextId = 0
    }



-- Update


type Msg
    = TextInput String
    | AddPost String
    | InputUsername String
    | SetUsername
    | Increment
    | Decrement
    | IncrementPost Int
    | DecrementPost Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextInput text ->
            { model | textInput = text }

        AddPost user ->
            let
                post =
                    { id = model.nextId
                    , text = model.textInput
                    , likes = 0
                    , user = user
                    }
            in
                { model | posts = post :: model.posts, textInput = "", nextId = model.nextId + 1 }

        InputUsername input ->
            { model | usernameInput = input }

        SetUsername ->
            { model | username = Just model.usernameInput }

        IncrementPost postId ->
            let
                updatePost post =
                    if post.id == postId then
                        { post | likes = post.likes + 1 }
                    else
                        post
            in
                { model | posts = List.map updatePost model.posts }

        DecrementPost postId ->
            let
                updatePost post =
                    if post.id == postId then
                        { post | likes = post.likes - 1 }
                    else
                        post
            in
                { model | posts = List.map updatePost model.posts }

        Increment ->
            { model | likes = model.likes + 1 }

        Decrement ->
            { model | likes = model.likes - 1 }



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
        , div [ class "counter" ]
            [ button [ onClick (IncrementPost post.id) ] [ text "+" ]
            , text (toString post.likes)
            , button [ onClick (DecrementPost post.id) ] [ text "-" ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }
