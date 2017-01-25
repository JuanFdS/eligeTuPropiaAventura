module Read exposing (..)
import Dict exposing (..)

type alias Read = { story : Story, chapter : Chapter }

type alias Story = { title : String, chapters: Dict Int Chapter }

type Chapter = Chapter { title : String, body : String, continuations: Dict Int Continuation }

type Continuation = Continuation { body : String, chapter: () -> Chapter }

type alias Chapters = Dict Int Chapter

type alias Continuations = Dict Int Continuation

getNextId : Int -> Dict Int value -> Int
getNextId id dict = if (member id dict) then getNextId (id + 1) dict else id

nextId : Dict Int value -> Int
nextId = getNextId 0

addValue : value -> Dict Int value -> Dict Int value
addValue value dict = insert (nextId dict) value dict
