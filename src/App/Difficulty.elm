module App.Difficulty exposing (..)


type Difficulty
    = Easy
    | Medium
    | Hard


difficultyToString : Difficulty -> String
difficultyToString difficulty =
    case difficulty of
        Easy ->
            "easy"

        Medium ->
            "medium"

        Hard ->
            "hard"


stringToDifficulty : String -> Maybe Difficulty
stringToDifficulty difficulty =
    case difficulty of
        "easy" ->
            Just Easy

        "medium" ->
            Just Medium

        "hard" ->
            Just Hard

        _ ->
            Nothing
