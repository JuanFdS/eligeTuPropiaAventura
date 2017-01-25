module Continuation exposing (..)
import Read exposing (..)
import Chapter exposing (..)

--Creating
empty : Continuation
empty = new "" Chapter.empty

new : String -> Chapter -> Continuation
new body chapter = Continuation { body = body, chapter= (\_ -> chapter) }

--Obtaining fields
body : Continuation -> String
body (Continuation {body}) = body

chapterLazy : Continuation -> () -> Chapter
chapterLazy (Continuation {chapter}) = chapter

chapter : Continuation -> Chapter
chapter (Continuation {chapter}) = chapter()

--Updating
setChapter : Chapter -> Continuation -> Continuation
setChapter chapter (Continuation continuation) = Continuation { continuation | chapter = \_ -> chapter }

setBody : String -> Continuation -> Continuation
setBody body (Continuation continuation) = Continuation { continuation | body = body }
