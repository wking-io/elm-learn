module Quiz.Progress exposing (Progress, decoder, current, progress, total, grade, init, next)

import Quiz.Question as Question exposing (Question)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, hardcoded, required, requiredAt)
import Json.Encode as Encode exposing (Value)


type Progress
    = Progress (List Question) Question (List Question)


type alias InitialProgress =
    ( List Question, Question, List Question )



-- Serialization --


decoder : Decoder Progress
decoder =
    decode Progress
        |> requiredAt [ "progress", "complete" ] (Decode.list Question.decoder)
        |> requiredAt [ "progress", "current" ] Question.decoder
        |> requiredAt [ "progress", "remaining" ] (Decode.list Question.decoder)


encode : Progress -> Value
encode (Progress complete current remaining) =
    Encode.object
        [ ( "complete", Encode.list (List.map Question.encode complete) )
        , ( "current", Question.encode current )
        , ( "remaining", Encode.list (List.map Question.encode complete) )
        ]


init : List Question -> Progress
init questions =
    let
        maybeCurrent =
            case List.head questions of
                Just question ->
                    question

                Nothing ->
                    Question.empty

        maybeRemaining =
            case List.tail questions of
                Just rest ->
                    rest

                Nothing ->
                    []
    in
        Progress [] maybeCurrent maybeRemaining


next : Progress -> ( Progress, Bool )
next ((Progress complete current remaining) as original) =
    let
        nextQuestion =
            List.head remaining

        newRemaining =
            List.tail remaining
    in
        case nextQuestion of
            Just next ->
                case newRemaining of
                    Just remain ->
                        ( Progress (current :: complete) next remain, False )

                    Nothing ->
                        ( Progress (current :: complete) next [], False )

            Nothing ->
                ( original, True )


current : Progress -> Question
current (Progress _ current _) =
    current


total : Progress -> Int
total (Progress complete _ remaining) =
    [ complete, remaining ]
        |> List.map List.length
        |> List.sum
        |> (+) 1


progress : Progress -> Int
progress (Progress complete _ _) =
    complete
        |> List.length
        |> (+) 1


grade : Progress -> ( String, String )
grade (Progress complete current _) =
    let
        questions =
            current :: complete

        total =
            List.length questions

        correct =
            questions
                |> List.filter Question.isCorrect
                |> List.length
    in
        ( (toString (round (((toFloat correct) / (toFloat total)) * 100))) ++ "%", (toString correct) ++ "/" ++ (toString total) )
