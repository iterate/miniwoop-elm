module Data.Message exposing (Message, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Json.Encode as Encode


type alias Message =
    { text : String }


decoder : Decoder Message
decoder =
    decode Message
        |> required "text" Decode.string


encode : Message -> Encode.Value
encode message =
    Encode.object
        [ ( "text", Encode.string message.text ) ]
