# Road Not Taken
![Travis CI Build Status](https://api.travis-ci.org/LPGhatguy/roads.svg?branch=master)

[Roblox Group](https://www.roblox.com/groups/4828125/Road-Not-Taken#!/about)

Early work in progress technology demonstration game entirely with Rojo. It's not really a game yet.

This project intends to show off the latest and greatest in Rojo features. It currently requires the current `master` branch of both the CLI and Roblox Studio plugin.

## Goals
- Never check a place file into version control
- Show off current Rojo developments

## Non-goals
- Make a good game

## Status
Foundation for a game is here. Most of my time is spent working on the underlying technology for *Road Not Taken* as opposed to the game itself.

## Bugs found so far
- Refs don't serialize correctly, which makes `Model.PrimaryPart` not work. ([LPGhatguy/rojo#142](https://github.com/LPGhatguy/rojo/issues/142))
- Property type inference for `Content` values doesn't happen, and the error messages Rojo outputs when inference fails are bad.

## Design
- Hacklike game (in the vein of NetHack)
- Server authoritative
- Spectating
- Declarative world rendering (Roact!)
- Immutable game state (Rodux!)
- Minimal state replication to clients

Input flow:

1. User presses a key, picked up by `UserInputService`
2. Input is mapped to a semantic input like `moveNorth` on the client and sent to the server
3. For each system:
	1. System is run with current state and current input
	2. System can return one or more Rodux actions, which are dispatched
4. The server generates a table containing what the client should be able to see from the current state and sends a list of diffs back to the client
5. The client applies those diffs, acting as a thin client

## License
*Road Not Taken* is available under the terms of the MIT license. See [LICENSE.txt](LICENSE.txt) for details.