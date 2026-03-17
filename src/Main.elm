-- Copyright © Kyle Roucis 2026
-- Created with assistance from Claude.ai Sonnet 4.6 (https://claude.ai)


module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Me
import Posts exposing (Post)
import Projects exposing (Project)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, top)



-- =====================================================================
-- ROUTES
-- =====================================================================


type Route
    = Home
    | ProjectDetail String
    | BlogList
    | BlogPost String
    | NotFound


isLocal : Bool
isLocal =
    False


siteRoot : String
siteRoot =
    if isLocal then
        "/"

    else
        "portfolio.kroucis.github.io/"


routeParser : Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Home top
        , Parser.map BlogList (Parser.s "blog")
        , Parser.map BlogPost (Parser.s "blog" </> Parser.string)
        , Parser.map ProjectDetail (Parser.s "projects" </> Parser.string)
        ]


fromUrl : Url -> Route
fromUrl url =
    Parser.parse routeParser url |> Maybe.withDefault NotFound


toHref : Route -> String
toHref route =
    case route of
        Home ->
            siteRoot

        BlogList ->
            siteRoot ++ "blog"

        BlogPost slug ->
            siteRoot ++ "blog/" ++ slug

        ProjectDetail slug ->
            siteRoot ++ "projects/" ++ slug

        NotFound ->
            siteRoot



-- =====================================================================
-- DATA
-- =====================================================================
-- =====================================================================
-- MODEL
-- =====================================================================


type alias Model =
    { key : Nav.Key
    , route : Route
    , showPhoto : Bool
    }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, route = fromUrl url, showPhoto = False }, Cmd.none )



-- =====================================================================
-- UPDATE
-- =====================================================================


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | TogglePhoto


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked (Internal url) ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        LinkClicked (External url) ->
            ( model, Nav.load url )

        UrlChanged url ->
            ( { model | route = fromUrl url }, Cmd.none )

        TogglePhoto ->
            ( { model | showPhoto = not model.showPhoto }, Cmd.none )



-- =====================================================================
-- VIEW
-- =====================================================================


view : Model -> Document Msg
view model =
    { title = pageTitle model.route
    , body =
        [ viewNav model.route
        , main_ [] [ viewPage model.route model.showPhoto ]
        , viewFooter
        ]
    }


pageTitle : Route -> String
pageTitle route =
    case route of
        Home ->
            Me.name

        ProjectDetail slug ->
            Projects.all
                |> List.filter (\p -> p.slug == slug)
                |> List.head
                |> Maybe.map (\p -> p.title ++ " — " ++ Me.name)
                |> Maybe.withDefault "Not Found"

        BlogList ->
            "Writing — " ++ Me.name

        BlogPost slug ->
            Posts.all
                |> List.filter (\p -> p.slug == slug)
                |> List.head
                |> Maybe.map (\p -> p.title ++ " — " ++ Me.name)
                |> Maybe.withDefault "Not Found"

        NotFound ->
            "Not Found — " ++ Me.name


viewNav : Route -> Html Msg
viewNav route =
    nav []
        [ a [ href (toHref Home) ] [ text Me.name ]
        , div [ class "nav-links" ]
            [ a [ href (toHref Home), classList [ ( "active", isHome route ) ] ] [ text "work" ]
            , a [ href (toHref BlogList), classList [ ( "active", isBlog route ) ] ] [ text "writing" ]
            ]
        ]


isHome : Route -> Bool
isHome route =
    case route of
        Home ->
            True

        ProjectDetail _ ->
            True

        _ ->
            False


isBlog : Route -> Bool
isBlog route =
    case route of
        BlogList ->
            True

        BlogPost _ ->
            True

        _ ->
            False


viewFooter : Html Msg
viewFooter =
    footer []
        [ text "Built with "
        , a [ href "https://elm-lang.org/", target "_blank", rel "noopener noreferrer" ] [ text "Elm" ]
        , text " and "
        , a [ href "https://claude.ai/", target "_blank", rel "noopener noreferrer" ] [ text "Claude.ai" ]
        , text " Sonnet 4.6."
        ]


viewPage : Route -> Bool -> Html Msg
viewPage route showPhoto =
    case route of
        Home ->
            viewHome showPhoto

        ProjectDetail slug ->
            viewProjectDetail slug

        BlogList ->
            viewBlogList

        BlogPost slug ->
            viewBlogPost slug

        NotFound ->
            viewNotFound



-- =====================================================================
-- HOME
-- =====================================================================


viewHome : Bool -> Html Msg
viewHome showPhoto =
    div []
        [ viewHero showPhoto
        , h2 [] [ text "Work" ]
        , div [] (List.map viewProjectCard Projects.all)
        ]


viewHero : Bool -> Html Msg
viewHero showPhoto =
    div []
        [ h1 [ class "hero-name" ] [ text Me.name ]
        , button
            [ class "hero-photo-toggle"
            , onClick TogglePhoto
            ]
            [ text
                (if showPhoto then
                    "hide photo ↑"

                 else
                    "show photo ↓"
                )
            ]
        , if showPhoto then
            img
                [ class "hero-photo"
                , src Me.photo
                , alt ("Photo of " ++ Me.name)
                ]
                []

          else
            text ""
        , p [ class "hero-bio" ] [ text Me.bio ]
        , div [ class "hero-links" ]
            (List.map viewHeroLink Me.links)
        ]


viewHeroLink : ( String, String ) -> Html Msg
viewHeroLink ( label, url ) =
    a [ href url, target "_blank", rel "noopener noreferrer" ] [ text label ]


viewProjectCard : Project -> Html Msg
viewProjectCard project =
    a [ class "project-card", href (toHref (ProjectDetail project.slug)) ]
        [ div [ class "project-card-header" ]
            [ div [ class "project-card-title" ] [ text project.title ]
            , if project.image /= "" then
                img
                    [ class "project-card-image"
                    , src project.image
                    , alt (project.title ++ " screenshot")
                    ]
                    []

              else
                text ""
            ]
        , div [ class "project-card-meta" ] [ text project.year ]
        , div [ class "project-card-summary" ] [ text project.summary ]
        , div [ class "tags" ] (List.map viewTag project.tags)
        ]



-- =====================================================================
-- PROJECT DETAIL
-- =====================================================================


viewProjectDetail : String -> Html Msg
viewProjectDetail slug =
    case Projects.all |> List.filter (\p -> p.slug == slug) |> List.head of
        Nothing ->
            viewNotFound

        Just project ->
            div []
                [ a [ class "back", href (toHref Home) ] [ text "← all work" ]
                , h1 [ class "detail-title" ] [ text project.title ]
                , div [ class "detail-meta" ]
                    [ text (project.year ++ " · ")
                    , span [] (List.intersperse (text ", ") (List.map text project.tags))
                    ]
                , if project.image /= "" then
                    img
                        [ class "project-image"
                        , src project.image
                        , alt (project.title ++ " screenshot")
                        ]
                        []

                  else
                    text ""
                , div [ class "prose" ]
                    [ p [] [ text project.description ] ]
                , div [ class "tags", style "margin-top" "2rem" ]
                    (List.filterMap identity
                        [ project.github |> Maybe.map (\u -> a [ href u, target "_blank", rel "noopener noreferrer" ] [ text "GitHub →" ])
                        ]
                        ++ List.map (\( label, u ) -> a [ href u, target "_blank", rel "noopener noreferrer" ] [ text (label ++ " →") ]) project.urls
                    )
                ]



-- =====================================================================
-- BLOG LIST
-- =====================================================================


viewBlogList : Html Msg
viewBlogList =
    div []
        [ h2 [] [ text "Writing" ]
        , div []
            (Posts.all
                |> List.sortBy .date
                |> List.reverse
                |> List.map viewPostRow
            )
        ]


viewPostRow : Post -> Html Msg
viewPostRow post =
    a [ class "post-row", href (toHref (BlogPost post.slug)) ]
        [ span [ class "post-row-title" ] [ text post.title ]
        , span [ class "post-row-date" ] [ text post.date ]
        ]



-- =====================================================================
-- BLOG POST
-- =====================================================================


viewBlogPost : String -> Html Msg
viewBlogPost slug =
    case Posts.all |> List.filter (\p -> p.slug == slug) |> List.head of
        Nothing ->
            viewNotFound

        Just post ->
            div []
                [ a [ class "back", href (toHref BlogList) ] [ text "← writing" ]
                , h1 [ class "detail-title" ] [ text post.title ]
                , div [ class "detail-meta" ]
                    [ text (post.date ++ " · ")
                    , span [] (List.intersperse (text ", ") (List.map text post.tags))
                    ]
                , div [ class "prose" ]
                    [ Html.map never post.body ]
                ]



-- =====================================================================
-- SHARED
-- =====================================================================


viewTag : String -> Html msg
viewTag t =
    span [ class "tag" ] [ text t ]


viewNotFound : Html Msg
viewNotFound =
    div [ class "not-found" ]
        [ h1 [] [ text "Page not found." ]
        , a [ href (toHref Home) ] [ text "Go home →" ]
        ]



-- =====================================================================
-- MAIN
-- =====================================================================


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
