module Request.Message exposing (list, post)

import Data.Message as Message exposing (Message)
import Json.Decode as Decode
import Http


url : String -> String
url endpoint =
    "http://localhost:5000" ++ endpoint


list : Http.Request (List Message)
list =
    Http.get (url "/messages") (Decode.list Message.decoder)


post : Message -> Http.Request Message
post msg =
    Http.post (url "/messages") (Http.jsonBody <| Message.encode msg) Message.decoder
