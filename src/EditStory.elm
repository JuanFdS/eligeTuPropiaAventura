module EditStory exposing (..)
import Read exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (toList)
import EditChapter exposing (..)
import Story exposing (..)
import Chapter exposing (..)
import Continuation exposing (..)

main = Html.beginnerProgram { model = model, update = update, view = view }

type alias EditingChapter = Maybe (Int, EditChapter.Model)
type alias Model = { story : Story, editingChapter : EditingChapter }
type Action = ShowEditChapter (Int, Chapter)
            | CloseEditChapter
            | ChildEditChapter EditingChapter EditChapter.Action
            | RemoveChapter Int

model = { story = Story.empty
                  |> Story.setTitle "Story title"
                  |> addChapter (Chapter.new "Ch. 1" "Chapter body" Dict.empty)
                  |> addChapter (Chapter.new "Ch. 2" "Chapter body" Dict.empty),
          editingChapter = Nothing }

editStory : (Story -> Story) -> Model -> Model
editStory f model = { model | story = f model.story }

update : Action -> Model -> Model
update action model =
  case action of
    ShowEditChapter (id, chapter) -> { model | editingChapter = Just (id, {chapter = chapter, editingContinuation = Nothing}) }
    CloseEditChapter -> { model | editingChapter = Nothing }
    ChildEditChapter (Just (id, {chapter})) EditChapter.Save ->
      update CloseEditChapter <| { model | story = Story.editChapter id chapter model.story}
    RemoveChapter id ->
      update CloseEditChapter <| editStory (removeChapter id) model
    ChildEditChapter _ action -> { model | editingChapter = Maybe.map (\(id, chapter) -> (id, EditChapter.update action chapter)) model.editingChapter }

viewStory : Story -> Html Action
viewStory {title, chapters} =
  div [] [h1 [] [text <| "Title: " ++ title],
          h2 [] [text "Chapters"],
          div [] <| List.map viewChapter <| toList <| chapters]

viewChapter : (Int, Chapter) -> Html Action
viewChapter (id, chapter) =
  h3 [] [text <| Chapter.title chapter,
         div [] [
           div [] [button [onClick <| ShowEditChapter (id, chapter)] [text "Edit"]],
           div [] [button [onClick <| RemoveChapter id] [text "Delete"]]
         ]]

viewEditingChapter : Model -> Html EditChapter.Action
viewEditingChapter model =
  case model.editingChapter of
    Nothing -> div [] []
    Just (_, chapter) -> EditChapter.view (List.map (\(_, chapter) -> chapter) <| toList model.story.chapters) chapter

view : Model -> Html Action
view model = div [] [viewStory model.story,
                     Html.map (ChildEditChapter model.editingChapter) <| viewEditingChapter model,
                     button [onClick <| ShowEditChapter (nextId model.story.chapters, Chapter.empty), hidden <| Nothing /= model.editingChapter] [text "Add new chapter"]]
