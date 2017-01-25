module GoOnAnAdventure exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Read exposing (..)
import Dict exposing (..)
import Continuation exposing (..)
import Chapter exposing (..)
import Story exposing (..)

main = Html.beginnerProgram { model = model , view = view , update = update }

aContinuation = Continuation.new "A continuation to the next chapter"
                <| Chapter { title = "The end",
                             body = "...",
                             continuations = Dict.empty |> addValue anotherContinuation }

anotherContinuation = Continuation { body = "Or is it?",
                                     chapter = \_ -> Chapter { title = "The REAL end",
                                                               body = "Credits roll",
                                                               continuations = Dict.empty} }
alternateContinuation =
  Continuation { body = "A continuation to an alternate chapter",
                 chapter = \_ -> Chapter { title = "Have I seen you before?",
                                           body = "You look familiar",
                                           continuations = Dict.empty |> addValue loopContinuation} }
loopContinuation =
  Continuation.new "Go over there"
  <| (Chapter.empty |> Chapter.setTitle "Deja'vu" |> Chapter.setBody "You spin me right round" |> addContinuation alternateContinuation)

aChapter =
  Chapter.empty |> Chapter.setTitle "A lesser but still awesome title"
                |> Chapter.setBody "Chapter's sexy body"
                |> addContinuation aContinuation
                |> addContinuation alternateContinuation

aStory = { title = "The most important title", chapters = Dict.empty }

type alias Model = Read

model : Model
model = { story = aStory, chapter = aChapter }

type Action = GoToChapter Chapter

update : Action -> Model -> Model
update action read =
  case action of
    GoToChapter chapter -> { read | chapter = chapter }

viewContinuation : Continuation -> Html Action
viewContinuation (Continuation {body, chapter}) = div [] [button [onClick <| GoToChapter <| chapter ()] [text body]]

viewChapter : Chapter -> Html Action
viewChapter (Chapter {title, body, continuations}) = div [] [
                                                              h2 [] [text title],
                                                              h3 [] [text body],
                                                              div [] (List.map viewContinuation <| values continuations)
                                                            ]

viewStory : Story -> Html Action
viewStory {title, chapters} = div [] [h1 [] [text title]]

viewRead : Read -> Html Action
viewRead {story, chapter} = div [] [
                        viewStory story,
                        viewChapter chapter
                       ]

view : Model -> Html Action
view = viewRead
