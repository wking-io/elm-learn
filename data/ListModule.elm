module ListModule exposing (json)


json : String
json =
    """
      {
        "id": "list",
        "name": "List Module",
        "functions": [
          {
            "id": "isEmpty",
            "name":"isEmpty",
            "description": "Determine if a list is empty.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#isEmpty",
            "examples": [
              ["_________ [] == True"]
            ]
          },
          {
            "id": "length",
            "name": "length",
            "description": "Determine the length of a list.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#length",
            "examples": [
              ["_________ [1,2,3] == 3"]
            ]
          },
          {
            "id": "reverse",
            "name": "reverse",
            "description": "Reverse a List.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#reverse",
            "examples": [
              ["_________ [1,2,3,4] == [4,3,2,1]"]
            ]
          },
          {
            "id": "member",
            "name": "member",
            "description": "Figure out whether a list contains a value.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#member",
            "examples": [
              ["_________ 9 [1,2,3,4] == False", "_________ 4 [1,2,3,4] == True"]
            ]
          },
          {
            "id": "head",
            "name": "head",
            "description": "Extract the first element of a list.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#head",
            "examples": [
              ["_________ [1,2,3] == Just 1", "_________ [] == Nothing"]
            ]
          },
          {
            "id": "tail",
            "name": "tail",
            "description": "Extract the rest of the list.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#tail",
            "examples": [
              ["_________ [1,2,3] == Just 1", "_________ [] == Nothing"]
            ]
          },
          {
            "id": "filter",
            "name": "filter",
            "description": "Keep only elements that satisfy the predicate.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#filter",
            "examples": [
              ["_________ isEven [1,2,3,4,5,6] == [2,4,6]"]
            ]
          },
          {
            "id": "take",
            "name": "take",
            "description": "Take the first n members of a list.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#take",
            "examples": [
              ["_________ 2 [1,2,3,4] == [1,2]"]
            ]
          },
          {
            "id": "drop",
            "name": "drop",
            "description": "Drop the first n members of a list.",
            "referenceUrl": "http://package.elm-lang.org/packages/elm-lang/core/latest/List#drop",
            "examples": [
              ["_________ 2 [1,2,3,4] == [3,4]"]
            ]
          }
        ]
      }
    """
