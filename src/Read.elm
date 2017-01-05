module Read exposing (..)

type alias Read = { story : Story, chapter : Chapter }

type Story = Story { title : String, chapters: List Chapter }

type Chapter = Chapter { title : String, body : String, continuations: List Continuation }

type Continuation = Continuation { body : String, chapter: () -> Chapter }
