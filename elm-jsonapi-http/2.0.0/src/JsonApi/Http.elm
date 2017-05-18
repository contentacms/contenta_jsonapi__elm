module JsonApi.Http
    exposing
        ( getDocument
        , getPrimaryResource
        , getPrimaryResourceCollection
        )

{-| A library for requesting resources from JSON API-compliant servers.
    Intended to be used in conjunction with `elm-jsonapi`, which provides
    serializers and helper functions.

@docs getDocument, getPrimaryResource, getPrimaryResourceCollection
-}

import JsonApi
import JsonApi.Decode exposing (document)
import JsonApi.Documents
import Http exposing (Request)
import Task exposing (Task)
import Json.Decode exposing (Decoder)


{-| Retreives a JSON API document from the given endpoint.
-}
getDocument : String -> Request JsonApi.Document
getDocument url =
  get url extractDocument


{-| Retreives the JSON API resource from the given endpoint.
    If there the payload is malformed or there is no singleton primary resource,
    the error type will be BadPayload.
-}
getPrimaryResource : String -> Request JsonApi.Resource
getPrimaryResource url =
    get url (extractDocument >> Result.andThen JsonApi.Documents.primaryResource)


{-| Retreives the JSON API resource collection from the given endpoint.
    If there the payload is malformed or there is no primary resource collection,
    the error type will be BadPayload.
-}
getPrimaryResourceCollection : String -> Request (List JsonApi.Resource)
getPrimaryResourceCollection url =
    get url (extractDocument >> Result.andThen JsonApi.Documents.primaryResourceCollection)


extractDocument : Http.Response String -> Result String JsonApi.Document
extractDocument { body } =
    Json.Decode.decodeString JsonApi.Decode.document body


get : String -> (Http.Response String -> Result String a) -> Request a
get url handler =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Content-Type" "application/vnd.api+json"
            , Http.header "Accept" "application/vnd.api+json"
            ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectStringResponse handler
        , timeout = Nothing
        , withCredentials = False
        }
