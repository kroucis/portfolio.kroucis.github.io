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
    [ { slug = "ch3ss-m4tch"
      , title = "Ch3ss M4tch - Game - macOS & iOS & Android"
      , year = "2023"
      , image = "/images/Ch3ssM4tch.png"
      , summary = "Competitive match-3 game based loosely on chess. First Clockwork-based game."
      , description = "<TODO>"
      , tags = [ "iOS", "Android", "macOS", "Swift", "Clockwork Game Engine", "App Store", "Google Play" ]
      , github = Nothing
      , urls =
            [ ( "App Store", "https://apps.apple.com/tr/app/ch3ss-m4tch/id1604265608" )
            ]
      }
    , { slug = "simple-swaps"
      , title = "Simple Swaps - Game - iOS & Android"
      , year = "2024"
      , image = "/images/SimpleSwaps.jpg"
      , summary = "Block swapping and pattern matching game focused on engine features and simplicity."
      , description = "<TODO>"
      , tags = [ "iOS", "Android", "Swift", "Clockwork Game Engine", "App Store", "Google Play" ]
      , github = Nothing
      , urls =
            [ ( "App Store", "https://apps.apple.com/tr/app/ch3ss-m4tch/id1604265608" )
            ]
      }
    , { slug = "pixel-forge"
      , title = "Pixel Forge - Graphics Tool - macOS"
      , year = "2024"
      , image = "/images/PixelForge.png"
      , summary = "Metal-based shader creation tool."
      , description = "<TODO>"
      , tags = [ "macOS", "Swift", "Metal", "App Store" ]
      , github = Nothing
      , urls =
            [ ( "App Store", "https://apps.apple.com/us/app/pixel-forge/id6473090142?mt=12" )
            ]
      }
    ]
