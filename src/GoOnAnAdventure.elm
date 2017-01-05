module GoOnAnAdventure exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Read exposing (..)

main = Html.beginnerProgram { model = model , view = view , update = update }

aContinuation = Continuation { body = "A continuation to the next chapter", chapter = \_ -> Chapter { title = "The end", body = "...", continuations = [anotherContinuation]} }
anotherContinuation = Continuation { body = "Or is it?", chapter = \_ -> Chapter { title = "The REAL end", body = "Credits roll", continuations = []} }
alternateContinuation = Continuation { body = "A continuation to an alternate chapter", chapter = \_ -> Chapter { title = "Have I seen you before?", body = "You look familiar", continuations = [loopContinuation]} }
loopContinuation = Continuation { body = "Go over there", chapter = \_ -> Chapter { title = "Deja'vu", body = "You spin me right round", continuations = [alternateContinuation]} }

aChapter = Chapter { title = "A lesser but still awesome title", body = "A sexy body", continuations = [aContinuation, alternateContinuation]}

aStory = Story {title = "The most important title", chapters = []}

model : Read
model = { story = aStory, chapter = aChapter }

viewContinuation : Continuation -> Html Action
viewContinuation (Continuation {body, chapter}) = div [] [button [onClick <| GoToChapter <| chapter ()] [text body]]

viewChapter : Chapter -> Html Action
viewChapter (Chapter {title, body, continuations}) = div [] [
                                                              h2 [] [text title],
                                                              h3 [] [text body],
                                                              div [] (List.map viewContinuation continuations)
                                                            ]

viewStory : Story -> Html Action
viewStory (Story {title, chapters}) = div [] [
                                              h1 [] [text title]
                                             ]

viewRead : Read -> Html Action
viewRead {story, chapter} = div [] [
                        viewStory story,
                        viewChapter chapter
                       ]

view = viewRead

type Action = GoToChapter Chapter

update action read =
  case action of
    GoToChapter chapter -> { read | chapter = chapter }
