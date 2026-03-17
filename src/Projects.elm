-- Copyright © Kyle Roucis 2026
-- Created with assistance from Claude.ai Sonnet 4.6 (https://claude.ai)


module Projects exposing (Project, all)

import Images


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
      , year = "Released 2023"
      , image = Images.ch3ss_m4tch
      , summary = "Competitive match-3 game based loosely on chess. First Clockwork-based game."
      , description = "<TODO>"
      , tags = [ "iOS", "Android", "macOS", "Swift", "Android NDK", "Kotlin", "Clockwork Game Engine", "App Store", "Google Play" ]
      , github = Nothing
      , urls =
            [ ( "App Store", "https://apps.apple.com/tr/app/ch3ss-m4tch/id1604265608" )
            ]
      }
    , { slug = "simple-swaps"
      , title = "Simple Swaps - Game - iOS & Android"
      , year = "Released 2024"
      , image = Images.simple_swaps
      , summary = "Block swapping and pattern matching game focused on engine features and simplicity."
      , description = "<TODO>"
      , tags = [ "iOS", "Android", "Swift", "Android NDK", "Kotlin", "Clockwork Game Engine", "App Store", "Google Play" ]
      , github = Nothing
      , urls =
            [ ( "App Store", "https://apps.apple.com/tr/app/ch3ss-m4tch/id1604265608" )
            ]
      }
    , { slug = "pixel-forge"
      , title = "Pixel Forge - Graphics Tool - macOS"
      , year = "Released 2024"
      , image = Images.pixel_forge
      , summary = "Metal-based shader creation tool."
      , description = "<TODO>"
      , tags = [ "macOS", "Swift", "Metal", "AppKit", "SwiftUI", "App Store" ]
      , github = Nothing
      , urls =
            [ ( "App Store", "https://apps.apple.com/us/app/pixel-forge/id6473090142?mt=12" )
            ]
      }
    ]
