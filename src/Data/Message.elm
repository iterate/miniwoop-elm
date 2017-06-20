module Data.Message exposing (Message, PostMessage, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Json.Encode as Encode


type alias PostMessage =
    { text : String
    , user : String
    }


type alias Message =
    { id : String
    , text : String
    , woops : Int
    , user : String
    }


decoder : Decoder Message
decoder =
    decode Message
        |> required "id" Decode.string
        |> required "text" Decode.string
        |> required "woops" Decode.int
        |> required "user" Decode.string


encode : PostMessage -> Encode.Value
encode message =
    Encode.object
        [ ( "text", Encode.string message.text )
        , ( "user", Encode.string message.user )
        ]
