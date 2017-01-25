module Story exposing (..)
import Read exposing (..)
import Dict exposing (..)

--Creating
empty : Story
empty = new "" Dict.empty

new : String -> Chapters -> Story
new title chapters = { title = title, chapters = chapters }

--Obtaining fields
title : Story -> String
title {title} = title

chapters : Story -> Chapters
chapters {chapters} = chapters

--Updating
setTitle : String -> Story -> Story
setTitle title story = { story | title = title}

updateChapters : (Chapters -> Chapters) -> Story -> Story
updateChapters f story = { story | chapters = f story.chapters }

addChapter : Chapter -> Story -> Story
addChapter chapter = updateChapters <| addValue chapter

editChapter : Int -> Chapter -> Story -> Story
editChapter id chapter = updateChapters <| insert id chapter

removeChapter : Int -> Story -> Story
removeChapter id = updateChapters <| remove id
