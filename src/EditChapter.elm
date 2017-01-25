module EditChapter exposing (..)
import Read exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Dict exposing (values, toList)
import Html.Attributes exposing (..)
import Maybe exposing (..)
import EditContinuation exposing (..)
import Chapter exposing (..)
import Continuation exposing (new, setChapter)

main = Html.beginnerProgram {model = model, update = update, view = view []}

type alias EditingContinuation = Maybe (Int, Continuation)
type alias Model = {chapter : Chapter, editingContinuation : Maybe (Int, Continuation)}
model : Model
model = {chapter = Chapter.empty |> setTitle "asd" |> setBody "wosd" |> addContinuation (Continuation.new "Sarlonga" Chapter.empty) , editingContinuation = Nothing}

editChapter : (Chapter -> Chapter) -> Model -> Model
editChapter f model = { model | chapter = f model.chapter }

editEditingContinuation : (EditingContinuation -> EditingContinuation) -> Model -> Model
editEditingContinuation f model = { model | editingContinuation = f model.editingContinuation }

type Action = ChildEditContinuation EditingContinuation EditContinuation.Action
              | EditChapter (Chapter -> Chapter)
              | ShowEditContinuation (Int, Continuation)
              | CloseEditContinuation
              | Save

update : Action -> Model -> Model
update action =
  case action of
    EditChapter f ->
      editChapter f
    ChildEditContinuation (Just (id, continuation)) EditContinuation.Save ->
      update CloseEditContinuation << editChapter (editContinuation id continuation)
    ChildEditContinuation _ action ->
      editEditingContinuation <| Maybe.map (\(id, continuation) -> (id, EditContinuation.update action continuation))
    ShowEditContinuation continuationWithId ->
      editEditingContinuation <| \_ -> Just continuationWithId
    CloseEditContinuation ->
      editEditingContinuation <| \_ -> Nothing
    Save ->
      identity

viewContinuationWithId : (Int, Continuation) -> Html Action
viewContinuationWithId (id, continuation) =
  div [] [text <| Continuation.body continuation,
          button [onClick <| ShowEditContinuation (id, continuation)] [text "Edit"],
          button [onClick <| EditChapter <| removeContinuation id ] [text "Delete"]]

viewContinuations : Chapter -> Html Action
viewContinuations chapter = chapter
                            |> continuations
                            |> toList
                            |> List.map viewContinuationWithId
                            |> div []

viewAddContinuationButton : Model -> Html Action
viewAddContinuationButton {chapter, editingContinuation} =
  let
    newId = continuations chapter |> nextId
    newContinuation = Continuation.empty |> setChapter chapter
  in
    button [hidden (editingContinuation /= Nothing),
            onClick <| ShowEditContinuation (newId, newContinuation)
           ] [text "Add new continuation"]

viewChapter chapter = div [] [p [] [text "Title: ", textarea [onInput <| EditChapter << setTitle] [text <| Chapter.title chapter]],
                              p [] [text "Body: ", textarea [onInput <| EditChapter << setBody] [text <| Chapter.body chapter]],
                              p [] [text "Continuations:"],
                              viewContinuations chapter]

viewEditContinuation : List Chapter -> Maybe (Int, Continuation) -> Html EditContinuation.Action
viewEditContinuation chapters editingContinuation =
  case editingContinuation of
    Nothing -> div [] []
    Just (_, continuation) -> div [] [EditContinuation.view chapters continuation]

view : List Chapter -> Model -> Html Action
view chapters model = div [] [viewChapter model.chapter,
                              viewAddContinuationButton model,
                              Html.map (ChildEditContinuation model.editingContinuation) <| viewEditContinuation chapters model.editingContinuation,
                              button [onClick Save] [text "Save Chapter"]]
