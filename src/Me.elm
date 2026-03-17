-- Copyright © Kyle Roucis 2026
-- Created with assistance from Claude.ai Sonnet 4.6 (https://claude.ai)


module Me exposing (bio, links, name, photo)

import Images


name : String
name =
    "Kyle Roucis"


bio : String
bio =
    "Software engineer. Functional programming enthusiast. I build things that are correct by construction."



-- Path or URL to your photo. Swap this for your actual image file.


photo : String
photo =
    Images.me



-- Each link is ( label, url )


links : List ( String, String )
links =
    [ ( "@kroucis GitHub", "https://github.com/kroucis" )

    --, ( "Socials", "N/A" )
    , ( "Email", "mailto:kyle@kyleroucis.com" )
    ]
