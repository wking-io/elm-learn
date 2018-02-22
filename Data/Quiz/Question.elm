module Quiz.Question exposing (Question, decoder, encode, empty, example, isCorrect, answer)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (..)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as EncodeExtra


type alias Question =
    { id : String
    , name : String
    , example : List (List String)
    , options : List String
    , answer : Maybe String
    }



-- Serialization --


decoder : Decoder Question
decoder =
    decode Question
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "examples" (Decode.list (Decode.list Decode.string))
        |> hardcoded []
        |> hardcoded Nothing


encode : Question -> Value
encode question =
    Encode.object
        [ ( "id", Encode.string question.id )
        , ( "name", Encode.string question.name )
        , ( "example", encodeExample question.example )
        , ( "options", encodeStringList question.options )
        , ( "answer", EncodeExtra.maybe Encode.string question.answer )
        ]



-- Identifiers --


empty : Question
empty =
    { id = "Nope"
    , name = "Nope"
    , example = [ [ "Sorry, there was an error and we didn't find any functions for this quiz." ] ]
    , options = [ "Nope", "Nope", "Nope", "Nope" ]
    , answer = Nothing
    }


example : Question -> Maybe (List String)
example question =
    List.head question.example


isCorrect : Question -> Bool
isCorrect question =
    let
        maybeAnswer =
            case question.answer of
                Just answer ->
                    answer

                Nothing ->
                    ""
    in
        maybeAnswer == question.id


answer : String -> Question -> Question
answer answer question =
    let
        maybeAnswer =
            if (String.isEmpty answer) then
                Nothing
            else
                Just answer
    in
        { question | answer = maybeAnswer }



-- Internal --


encodeStringList : List String -> Value
encodeStringList strings =
    strings
        |> List.map Encode.string
        |> Encode.list


encodeExample : List (List String) -> Value
encodeExample example =
    example
        |> List.map encodeStringList
        |> Encode.list
