module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import QuizProgress exposing (..)
import Random exposing (..)
import ListModule


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = ( initialModel, Random.generate BuildQuiz (initQuiz ListModule.json) )
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { questions : QuizProgress
    , isComplete : Bool
    , showReview : Bool
    }


initialModel : Model
initialModel =
    { questions = initProgress []
    , isComplete = False
    , showReview = False
    }


viewQuizOption : String -> Html Msg
viewQuizOption option =
    let
        unique =
            "answer-" ++ (String.toLower option)

        prefixed =
            "List." ++ option
    in
        div [ class "quiz__body__form__option" ]
            [ input
                [ class "quiz__body__form__input"
                , type_ "radio"
                , id unique
                , name "answer"
                , value option
                ]
                []
            , label
                [ class "quiz__body__form__label"
                , for unique
                , onClick (SubmitAnswer option)
                ]
                [ text prefixed ]
            ]


viewQuizSubmit : Html Msg
viewQuizSubmit =
    input
        [ class "quiz__body__form__submit"
        , type_ "submit"
        , disabled True
        , value "Submit Answer"
        ]
        []


viewQuizForm : ( Maybe String, List String ) -> Html Msg
viewQuizForm ( maybeAnswer, options ) =
    let
        answer =
            case maybeAnswer of
                Just answer ->
                    answer

                Nothing ->
                    ""
    in
        Html.form [ class "quiz__body__form" ]
            (List.append
                (List.map viewQuizOption options)
                (List.singleton viewQuizSubmit)
            )


viewQuiz : QuizProgress -> Html Msg
viewQuiz progress =
    let
        current =
            progress
                |> getCurrent

        example =
            current
                |> getExample
    in
        div [ class "quiz" ]
            [ header [ class "quiz__header" ]
                [ p [ class "quiz__header__title" ] [ text "Multiple Choice" ]
                , p [ class "quiz__header__progress" ] [ text ((toString (getProgressCount progress)) ++ "/" ++ (toString (getTotal progress))) ]
                ]
            , div [ class "quiz__body" ]
                [ div [ class "quiz__body__question" ]
                    [ h2 [ class "quiz__body__question__title" ] [ text "Choose the method that solves the problem below:" ]
                    , pre [ class "quiz__body__question__example" ]
                        (List.map (\line -> div [] [ text line ]) example)
                    ]
                , viewQuizForm ( getAnswer current, getOptions current )
                ]
            ]


viewResult : QuizProgress -> Html Msg
viewResult progress =
    let
        ( grade, exact ) =
            getGrade progress
    in
        div [ class "tc w-100" ]
            [ h1 [] [ text grade ]
            , p [] [ text ("You got " ++ exact ++ " correct!") ]
            , button [ type_ "button", class "btn--underline mb1" ] [ text "Review your answers here!" ]
            , div [ class "flex justify-center w-75 center mt5" ]
                [ button [ class "w-50 mr3 btn" ] [ text "Try Again" ]
                , button [ class "w-50 ml3 btn" ] [ text "Main Menu" ]
                ]
            ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ nav [ class "nav" ]
            [ h1 [ class "nav__title" ] [ text "elm-learn" ]
            ]
        , section [ class "content" ]
            [ if model.isComplete then
                viewResult model.questions
              else
                viewQuiz model.questions
            ]
        ]


type Msg
    = SubmitAnswer String
    | BuildQuiz (List Question)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitAnswer newAnswer ->
            let
                ( newProgress, isComplete ) =
                    model.questions
                        |> updateAnswer newAnswer
                        |> nextQuestion
            in
                ( { model
                    | questions = newProgress
                    , isComplete = isComplete
                  }
                , Cmd.none
                )

        BuildQuiz shuffledQuestions ->
            ( { model | questions = (initProgress shuffledQuestions) }, Cmd.none )
