module Data.Post exposing (Post, NewPost, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Json.Encode as Encode


type alias NewPost =
    { text : String
    , user : String
    }


type alias Post =
    { id : String
    , text : String
    , woops : Int
    , user : String
    }


decoder : Decoder Post
decoder =
    decode Post
        |> required "id" Decode.string
        |> required "text" Decode.string
        |> required "woops" Decode.int
        |> required "user" Decode.string


encode : NewPost -> Encode.Value
encode post =
    Encode.object
        [ ( "text", Encode.string post.text )
        , ( "user", Encode.string post.user )
        ]
