---
toc: 4 - Writing the Story
tutorial: true
summary: How to send projections.
---
# Projections

The projection plugin lets you bespeak other dragons.

[[toc]]

##Sending projections without a Scene

On the game, you can project to other characters online by sending a text without specifying a scene number. These projections are not added to any scene and will not be logged or saved unless you do so manually.

Do `pro <name>=<message>` to send a projection without adding it to a scene.

> **Note:** Projecting to characters without an attached scene only works when all characters are logged in to the game via telnet; it will not work via the portal. Projecting via the portal requires a scene.

##Sending projections in a Scene

###Starting a Scene

On game, you can start a new text scene in one easy step.

`pro/newscene <name> [<name}]=<message>`

This will start a new scene, set the location and scene type, emit the text to all characters currently online, and add the text to the scene.

On the portal, you will need to [start a scene](/help/scenes_tutorial#starting-a-scene) and set the location and type manually.

###Replying to projections

####On Game
If someone projects to you, you can quickly reply using `pro/reply=<message>`. This will send your reply to everyone in the recipient list and add it to the scene. To see who last projected to you, type `pro/reply`

On the game, the 'pro' command will remember the last character and scene you projected to. If you continue to project to the same person, you can simply do `pro <name> [<name}]=<message>`.

If you're projecting to several different recipients or to several different scenes at once, you'll need to specify who you are projecting to and what scene it should be added to by doing `pro <name> [<name}]/<scene>=<message>`.

If you project to someone who was not previously in that scene, they will automatically be added to the scene.

####On the Portal
Projections sent from the portal add the projections to the scene and emit to anyone who is online on the game.

Send projections by using the 'Pro' button next to the 'Add OOC' and 'Add Pose' buttons on the portal. By default, this button projects to everyone in the scene.

To send projections to a different recipient list, do `<name> [name]=<message>` and use the 'Pro' button.

###Ignoring or Blocking Texts

If you do not wish to receive pros (in general, or from a specific person), the `page/ignore <name>=<on/off>` and `page/dnd <on/off>` commands will block pros as well.
