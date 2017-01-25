module EditContinuation exposing (..)
import Read exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Chapter exposing (title, continuations)
import Continuation exposing (..)

main = Html.beginnerProgram {model = model, update = update, view = view []}

type alias Model = Continuation

model : Continuation
model = Continuation.empty

type Action = EditBody String | EditChapter Chapter | Save

update : Action -> Continuation -> Continuation
update action =
  case action of
    EditBody body -> setBody body
    EditChapter chapter -> setChapter chapter
    Save -> identity

viewChapter : Chapter -> Html Action
viewChapter chapter = div [onClick <| EditChapter chapter] [text <| title chapter]

view : List Chapter -> Model -> Html Action
view possibleChapters continuation =
  let body = Continuation.body continuation
      actualChapter = Continuation.chapterLazy continuation
  in
    div [] ([h1 [] [text <| body],
             p [] [text "Write the continuation text", textarea [onInput EditBody] [text body]],
             p [] [text <| "Actual continuation: " ++ (title <| actualChapter ())],
             p [] [text "Choose a continuation"]]
             ++ (List.map viewChapter possibleChapters) ++ [
             button [onClick <| Save] [text "Save Continuation"]
             ]
           )
