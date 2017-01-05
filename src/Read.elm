module Read exposing (..)

type alias Read = { story : Story, chapter : Chapter }

type alias Story = { title : String, chapters: List Chapter }

type Chapter = Chapter { title : String, body : String, continuations: List Continuation }

type Continuation = Continuation { body : String, chapter: () -> Chapter }

emptyStory = story "" []

story title chapters = { title = title, chapters = chapters}

addChapter : Chapter -> Story -> Story
addChapter chapter story = { story | chapters = story.chapters ++ [chapter]}
