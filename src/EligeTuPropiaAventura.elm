module EligeTuPropiaAventura exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias Read = { story : Story, chapter : Chapter }

type Story = Story { title : String, chapters: List Chapter }

type Chapter = Chapter { title : String, body : String, continuations: List Continuation }

type Continuation = Continuation { body : String, chapter: () -> Chapter }

story (Story {title, chapters}) = {title = title, chapters = chapters}

chapter (Chapter {title, body, continuations}) = {title = title, body = body, continuations = continuations}

continuation (Continuation {body, chapter}) = {body = body, chapter = chapter}

main = Html.beginnerProgram { model = model , view = view , update = update }

aContinuation = Continuation { body = "A continuation to the next chapter", chapter = \_ -> Chapter { title = "The end", body = "...", continuations = [anotherContinuation]} }
anotherContinuation = Continuation { body = "Or is it?", chapter = \_ -> Chapter { title = "The REAL end", body = "Credits roll", continuations = []} }
alternateContinuation = Continuation { body = "A continuation to an alternate chapter", chapter = \_ -> Chapter { title = "Have I seen you before?", body = "You look familiar", continuations = [loopContinuation]} }
loopContinuation = Continuation { body = "Go over there", chapter = \_ -> Chapter { title = "Deja'vu", body = "You spin me right round", continuations = [alternateContinuation]} }

aChapter = Chapter { title = "A lesser but still awesome title", body = "A sexy body", continuations = [aContinuation, alternateContinuation]}

aStory = Story {title = "The most important title", chapters = []}

model : Read
model = { story = aStory, chapter = aChapter }

viewContinuation : Continuation -> Html Msg
viewContinuation (Continuation {body, chapter}) = div [] [button [onClick (GoToChapter (chapter()))] [text body]]

viewChapter : Chapter -> Html Msg
viewChapter (Chapter {title, body, continuations}) = div [] [
                                                              h2 [] [text title],
                                                              h3 [] [text body],
                                                              div [] (List.map viewContinuation continuations)
                                                            ]

viewStory : Story -> Html Msg
viewStory (Story {title, chapters}) = div [] [
                                              h1 [] [text title]
                                             ]

viewRead : Read -> Html Msg
viewRead read = div [] [
                        viewStory read.story,
                        viewChapter read.chapter
                       ]

view = viewRead

type Msg = GoToChapter Chapter

update msg read =
  case msg of
    GoToChapter chapter -> {read | chapter = chapter}
