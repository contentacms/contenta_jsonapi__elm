module App.Utils exposing (removeErrorFromList)

removeErrorFromList : List (Result a b) -> List b
removeErrorFromList list =
    case (List.reverse list) of
        (Ok a) :: xs ->
            a :: removeErrorFromList xs

        (Err b) :: xs ->
            removeErrorFromList xs

        [] ->
            []

