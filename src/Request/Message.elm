module Request.Message exposing (list, post)

import Data.Message as Message exposing (Message)
import Json.Decode as Decode
import Http


list : Http.Request (List Message)
list =
    Http.get "http://127.0.0.1:8080/messages" (Decode.list Message.decoder)


post : Message -> Http.Request (List Message)
post msg =
    Http.post "http://127.0.0.1:8080/messages" (Http.jsonBody <| Message.encode msg) (Decode.list Message.decoder)
