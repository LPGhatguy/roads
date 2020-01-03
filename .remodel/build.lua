local contents = remodel.readFile("default.project.json")
local project = json.fromString(contents)
project.fileLocation = "default.project.json"

local game = rojo.buildProject(project)

remodel.writePlaceFile(game, "Place.rbxlx")