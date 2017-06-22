module Request.Message exposing (list, post, woop)

import Data.Message as Message exposing (Message, PostMessage)
import Json.Decode as Decode
import Http


url : String -> String
url endpoint =
    "https://miniwoop-backend.app.iterate.no" ++ endpoint


list : Http.Request (List Message)
list =
    Http.get (url "/messages") (Decode.list Message.decoder)


post : PostMessage -> Http.Request Message
post msg =
    Http.post (url "/messages") (Http.jsonBody <| Message.encode msg) Message.decoder


woop : Message -> Http.Request Message
woop message =
    Http.post (url <| "/messages/" ++ message.id ++ "/woop") Http.emptyBody Message.decoder
