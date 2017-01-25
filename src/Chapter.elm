module Chapter exposing (..)
import Read exposing (..)
import Dict exposing (..)

--Creating
empty : Chapter
empty = new "" "" Dict.empty

new : String -> String -> Continuations -> Chapter
new title body continuations = Chapter {title = title, body = body, continuations = continuations}

--Obtaining fields
body : Chapter -> String
body (Chapter {body}) = body

title : Chapter -> String
title (Chapter {title}) = title

continuations : Chapter -> Continuations
continuations (Chapter {continuations}) = continuations

--Updating
setBody : String -> Chapter -> Chapter
setBody body (Chapter chapter) = Chapter { chapter | body = body }

setTitle : String -> Chapter -> Chapter
setTitle title (Chapter chapter) = Chapter { chapter | title = title }

updateContinuations : (Continuations -> Continuations) -> Chapter -> Chapter
updateContinuations f (Chapter chapter) =
  Chapter { chapter | continuations = f chapter.continuations }

addContinuation : Continuation -> Chapter -> Chapter
addContinuation continuation = updateContinuations <| addValue continuation

editContinuation : Int -> Continuation -> Chapter -> Chapter
editContinuation id continuation  = updateContinuations <| insert id continuation

removeContinuation : Int -> Chapter -> Chapter
removeContinuation id = updateContinuations <| remove id
