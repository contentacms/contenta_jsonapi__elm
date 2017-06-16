module App.JsonApiHelper exposing (..)

{-
   This file is trying to implement some abstractions over the bare JSONAPI packages of elm.

   @todo
   - Actually write a toString for url
   - continue with defining the types for include and field
   - Write test coverage

-}


type alias Url =
    { path : String
    , filter : Maybe (List Filter)
    , include : Maybe (List Include)
    , field : Maybe (List Field)
    , sort : Maybe (List Sort)
    , pager : Maybe (List Pager)
    }


url : String -> Url
url path =
    Url
        { path = path
        , filter = Nothing
        , include = Nothing
        , field = Nothing
        , sort = Nothing
        , pager = Nothing
        }


withFilter : Filter -> Url -> Url
withFilter filter url =
    { url
        | filter =
            Maybe.map url.filter
                |> (::) filter
    }


withInclude : Include -> Url -> Url
withInclude include url =
    { url
        | include =
            Maybe.map url.include
                |> (::) include
    }


withField : Field -> Url -> Url
withField field url =
    { url
        | field =
            Maybe.map url.field
                |> (::) field
    }


withSort : Sort -> Url -> Url
withSort sort url =
    { url
        | sort =
            Maybe.map url.sort
                |> (::) sort
    }


withPager : Pager -> Url -> Url
withPager pager url =
    { url
        | pager =
            Maybe.map url.pager
                |> (::) pager
    }


type alias Sort =
    { keys : List String
    , direction : SortDirection
    }


type SortDirection
    = ASC
    | DESC


sortAsc : String -> Sort
sortAsc string =
    { keys = [ string ]
    , direction = ASC
    }


sortDesc : String -> Sort
sortDesc string =
    { keys = [ string ]
    , direction = DESC
    }


sortAscWithPath : List String -> Sort
sortAscWithPath keys =
    { keys = keys
    , direction = ASC
    }


sortDescWithPath : List String -> Sort
sortDescWithPath keys =
    { keys = keys
    , direction = DESC
    }


type alias Filter =
    { keys : List String
    , operator : Maybe String
    , value : String
    }


filter : List String -> String -> Filter
filter keys value =
    { keys = keys
    , operator = Nothing
    , value = value
    }


type Include
    = Meh2


type Field
    = Meh3


type Pager
    = PagerNumber Int
    | PagerSize Int
    | PagerOffset Int
    | PagerLimit Int
    | PagerCursor Int
