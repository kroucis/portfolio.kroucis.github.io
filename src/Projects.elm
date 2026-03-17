module Projects exposing (Project, all)


type alias Project =
    { slug : String
    , title : String
    , year : String
    , image : String
    , summary : String
    , description : String
    , tags : List String
    , github : Maybe String
    , urls : List ( String, String )
    }


all : List Project
all =
    [ { slug = "your-project"
      , title = "Your Project"
      , year = "2024"
      , image = ""
      , summary = "A short description of what this project does."
      , description = "A longer description. What problem does it solve? What did you learn? What's interesting about it?"
      , tags = [ "Elm", "Web" ]
      , github = Nothing
      , urls = []
      }
    ]
