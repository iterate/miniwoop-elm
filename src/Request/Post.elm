module Request.Post exposing (list, post, woop)

import Data.Post as Post exposing (Post, NewPost)
import Json.Decode as Decode
import Http


url : String -> String
url endpoint =
    "https://miniwoop-backend.app.iterate.no" ++ endpoint


list : Http.Request (List Post)
list =
    Http.get (url "/messages") (Decode.list Post.decoder)


post : NewPost -> Http.Request Post
post msg =
    Http.post (url "/messages") (Http.jsonBody <| Post.encode msg) Post.decoder


woop : Post -> Http.Request Post
woop post =
    Http.post (url <| "/messages/" ++ post.id ++ "/woop") Http.emptyBody Post.decoder
