---
toc: 4 - Writing the Story
summary: How to send pros.
aliases:
- pro
- projecting
- project
---
#Pros
Send dragon projection messages to other characters.

> Learn how the pro system works in the [Pro Tutorial](/help/pro_tutorial).

# Dragon names
By default, the pro command only works for character names and not dragon names. You can change this for projections to yourself by setting your alias to your dragon's name (ie `alias <dragon name>`). 

## Projecting from the Web-Portal
There is a "Pro" button on any active scene in the web-portal. Projecting into a scene will send a message in-game, if the character is connected. By default, proing on the portal will send a text to all participants of the scene.

`<name>=<message>` - Send a message to a specific person from the webportal. Adds recipients to scene if not already a participant.

>  **Note:** Someone who's not logged in may not know they've been pro'ed unless they notice their notifications!

## Commands
`pro/newscene <name> [<name> <name>]=<message>` - Starts a new scene + sends a message to those names + the scene.

`pro <name> [<name> <name>]=<message>` - Send a message to name(s) outside of a scene.
`pro <name> [<name> <name>]/<scene #>=<message>` - Send a pro to name + add it to a scene. Adds recipients to scene if not already a participant.
`pro [=]<message>` - Send a message to your last target + last scene.

`pro/reply` - See who last projected to you.
`pro/reply <message>` - Reply to the last projection (including all recipients + scene, if there is one)

>  **Note:** If you do not wish to receive pros (in general, or from a specific person), the `page/ignore <name>=<on/off>` and `page/dnd <on/off>` commands will block pros as well.
