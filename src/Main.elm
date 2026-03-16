module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MODEL


type alias Project =
    { title : String
    , description : String
    , url : String
    }


type alias Model =
    { name : String
    , bio : String
    , projects : List Project
    , showContact : Bool
    }


initialModel : Model
initialModel =
    { name = "Your Name"
    , bio = "I'm a developer who loves creating cool stuff with Elm!"
    , projects =
        [ { title = "Project 1"
          , description = "My first awesome project"
          , url = "https://example.com/1"
          }
        , { title = "Project 2"
          , description = "Another thing I built"
          , url = "https://example.com/2"
          }
        ]
    , showContact = False
    }



-- UPDATE


type Msg
    = ToggleContact
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleContact ->
            { model | showContact = not model.showContact }

        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header []
            [ h1 [] [ text model.name ]
            , p [ class "bio" ] [ text model.bio ]
            ]
        , section []
            [ h2 [] [ text "Projects" ]
            , div [ class "projects" ]
                (List.map viewProject model.projects)
            ]
        , button [ onClick ToggleContact ]
            [ text
                (if model.showContact then
                    "Hide Contact"

                 else
                    "Show Contact"
                )
            ]
        , if model.showContact then
            div [ class "contact" ]
                [ h3 [] [ text "Get in touch!" ]
                , p [] [ text "email: your.email@example.com" ]
                ]

          else
            text ""
        ]


viewProject : Project -> Html Msg
viewProject project =
    div [ class "project-card" ]
        [ h3 [] [ text project.title ]
        , p [] [ text project.description ]
        , a [ href project.url, target "_blank" ] [ text "View Project →" ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
