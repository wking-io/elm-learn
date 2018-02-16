module ListModule exposing (json)


json : String
json =
    """
      {
        "id": "list",
        "name": "List Module",
        "functions": [
          {
            "id": 'isEmpty',
            "name": 'isEmpty',
            "description": "Determine if a list is empty.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#isEmpty",
            "questions": [
              "_________ [] == True",
            ],
          },
          {
            "id": "length",
            "name": "length",
            "description": "Determine the length of a list.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#length",
            "questions": [
              "_________ [1,2,3] == 3",
            ],
          }
        ]
      }
    """
