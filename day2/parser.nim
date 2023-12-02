import strutils


type
  Subset* = object
    red*: int
    green*: int
    blue*: int
  Game* = object
    id*: int
    subgames*: seq[Subset]


proc parseInput*(input: string): seq[Game] =
  for line in input.splitLines():
    if line.len == 0: continue
    var game = Game()
    let tmp = line.split(":")
    game.id = parseInt(tmp[0].split()[1])
    let subgamesStr = tmp[1].split(";")
    for subgameStr in subgamesStr:
      var subgame = Subset()
      let colors = subgameStr.split(",")
      for color in colors:
        let tmp = color.strip().split()
        let count = parseInt(tmp[0])
        let color = tmp[1]
        case color
        of "red":
          subgame.red = count
        of "green":
          subgame.green = count
        of "blue":
          subgame.blue = count
        else:
          discard
      game.subgames.add subgame
    result.add game

