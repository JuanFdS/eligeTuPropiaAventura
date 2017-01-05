module CraftAnAdventure exposing (..)

import Read exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

main = Html.beginnerProgram { model = model , view = view , update = update }

type alias Model = { story : Story, addChapterFormVisible : Bool }

type Action = ShowAddChapterForm | AddChapter Chapter

model : Model
model = { story = story "Story Title" [], addChapterFormVisible = False }

viewStory : Story -> Html Action
viewStory {title, chapters} = h1 [] [text title, div [] [text <| (++) "Amount of chapters: " <| toString <| List.length chapters] ]

viewAddChapterForm addingChapter = div [] [div [hidden addingChapter] [
                                                button [onClick ShowAddChapterForm] [text "Add chapter"]
                                              ],
                                           div [hidden <| not addingChapter] [
                                                div [] [textarea [placeholder "Write here your chapter"] []],
                                                div [] [
                                                  button [onClick <| AddChapter <|
                                                  Chapter { title ="lal", body ="lel", continuations = [] }
                                                  ] [text "Save"],
                                                  button [onClick ShowAddChapterForm] [text "Cancel"]
                                                ]
                                              ]
                                          ]

view : Model -> Html Action
view model = div [] [viewStory model.story,
                     viewAddChapterForm model.addChapterFormVisible
                    ]

update : Action -> Model -> Model
update action model =
  case action of
    ShowAddChapterForm -> { model | addChapterFormVisible = not model.addChapterFormVisible }
    AddChapter chapter -> update ShowAddChapterForm <| { model | story = addChapter chapter model.story}
