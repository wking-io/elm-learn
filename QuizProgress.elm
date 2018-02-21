module QuizProgress
    exposing
        ( answer
        , decodeQuiz
        , emptyQuestion
        , getCurrent
        , getId
        , getName
        , getExample
        , getOptions
        , getAnswer
        , initProgress
        , initQuiz
        , shuffleQuestions
        , QuizProgress
        , Question
        )

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Random exposing (Generator)
import Random.List exposing (shuffle)
import Random.Extra exposing (combine, sample)


type alias Question =
    { id : String
    , name : String
    , example : List (List String)
    , options : List String
    , answer : Maybe String
    }


type QuizProgress
    = QuizProgress
        { complete : List Question
        , current : Question
        , remaining : List Question
        }


type alias InitialProgress =
    { complete : List Question
    , current : Question
    , remaining : List Question
    }


questionDecoder : Decoder Question
questionDecoder =
    decode Question
        |> required "id" string
        |> required "name" string
        |> required "examples" (list (list string))
        |> hardcoded []
        |> hardcoded Nothing


quizDecoder : Decoder (List Question)
quizDecoder =
    decode identity
        |> required "functions" (list questionDecoder)


decodeQuiz : String -> List Question
decodeQuiz json =
    case decodeString quizDecoder json of
        Ok quizResults ->
            quizResults

        Err err ->
            []



----------
-- Takes JSON and runs it through Decoder built above to get a List Question
----------


shuffleQuestions : String -> Generator (List Question)
shuffleQuestions json =
    let
        questions =
            json
                |> decodeQuiz
                |> shuffle
    in
        questions



----------
-- Takes List Question and maps over each question to build options for each question
----------


randomOptions : List String -> String -> Generator (List String)
randomOptions names currentName =
    names
        |> List.filter (\name -> name /= currentName)
        |> shuffle
        |> Random.map (\list -> List.take 4 <| currentName :: list)
        |> Random.andThen shuffle


addRandomOptions : List String -> Question -> Generator Question
addRandomOptions options question =
    randomOptions options question.name
        |> Random.map (\options -> { question | options = options })


randomExample : List (List String) -> Generator (List String)
randomExample examples =
    let
        checkExample example =
            case example of
                Just example ->
                    example

                Nothing ->
                    [ "No Example Found" ]
    in
        examples
            |> sample
            |> Random.map checkExample


addRandomExample : Question -> Generator Question
addRandomExample question =
    randomExample question.example
        |> Random.map (\ex -> { question | example = (List.singleton ex) })


buildOptions : List Question -> Generator (List Question)
buildOptions questions =
    let
        options =
            List.map .name questions
    in
        questions
            |> List.map (addRandomOptions options)
            |> List.map (Random.andThen addRandomExample)
            |> combine


initQuiz : String -> Generator (List Question)
initQuiz json =
    let
        questions =
            json
                |> shuffleQuestions
                |> Random.andThen buildOptions
    in
        questions


asAnswerIn : Question -> String -> Question
asAnswerIn question newAnswer =
    { question | answer = Just newAnswer }


asCurrentQuestionIn : QuizProgress -> Question -> QuizProgress
asCurrentQuestionIn (QuizProgress { complete, current, remaining }) newQuestion =
    QuizProgress { complete = complete, current = newQuestion, remaining = remaining }


answer : String -> QuizProgress -> QuizProgress
answer response progress =
    case progress of
        QuizProgress { complete, current, remaining } ->
            response
                |> asAnswerIn current
                |> asCurrentQuestionIn progress


initProgress : List Question -> QuizProgress
initProgress questions =
    let
        maybeCurrent =
            case List.head questions of
                Just question ->
                    question

                Nothing ->
                    emptyQuestion

        maybeRemaining =
            case List.tail questions of
                Just rest ->
                    rest

                Nothing ->
                    []
    in
        QuizProgress { complete = [], current = maybeCurrent, remaining = maybeRemaining }


emptyQuestion : Question
emptyQuestion =
    { id = "Nope"
    , name = "Nope"
    , example = [ [ "Sorry, there was an error and we didn't find a function." ] ]
    , options = [ "Nope", "Nope", "Nope", "Nope" ]
    , answer = Nothing
    }


getCurrent : QuizProgress -> Question
getCurrent (QuizProgress { complete, current, remaining }) =
    current


getId : Question -> String
getId question =
    question.id


getName : Question -> String
getName question =
    question.name


getExample : Question -> List String
getExample question =
    case List.head question.example of
        Just example ->
            example

        Nothing ->
            [ "Sorry, no example found!" ]


getOptions : Question -> List String
getOptions question =
    question.options


getAnswer : Question -> Maybe String
getAnswer question =
    question.answer
