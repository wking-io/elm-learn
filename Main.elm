module Main exposing (..)

import Html exposing (..)
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
    }


initialModel : Model
initialModel =
    { questions = initProgress [] }


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
                ]
                [ text prefixed ]
            ]


viewQuizSubmit : Html Msg
viewQuizSubmit =
    input [ class "quiz__body__form__submit", type_ "submit", disabled True, value "Submit Answer" ] []


viewQuizForm : List String -> Html Msg
viewQuizForm options =
    Html.form [ class "quiz__body__form" ]
        (List.append
            (List.map viewQuizOption options)
            (List.singleton viewQuizSubmit)
        )


view : Model -> Html Msg
view model =
    let
        current questions =
            questions
                |> getCurrent

        example =
            current model.questions
                |> getExample
    in
        div [ class "container" ]
            [ nav [ class "nav" ]
                [ h1 [ class "nav__title" ] [ text "elm-learn" ]
                ]
            , section [ class "content" ]
                [ div [ class "quiz" ]
                    [ header [ class "quiz__header" ]
                        [ p [ class "quiz__header__title" ] [ text "Multiple Choice" ]
                        , p [ class "quiz__header__progress" ] [ text "1/2" ]
                        ]
                    , div [ class "quiz__body" ]
                        [ div [ class "quiz__body__question" ]
                            [ h2 [ class "quiz__body__question__title" ] [ text "Choose the method that solves the problem below:" ]
                            , pre [ class "quiz__body__question__example" ]
                                (List.map (\line -> div [] [ text line ]) example)
                            ]
                        , viewQuizForm (getOptions (current model.questions))
                        ]
                    ]
                ]
            ]


type Msg
    = Answer String
    | BuildQuiz (List Question)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Answer newAnswer ->
            ( { model | questions = (answer newAnswer model.questions) }, Cmd.none )

        BuildQuiz shuffledQuestions ->
            ( { model | questions = (initProgress shuffledQuestions) }, Cmd.none )
