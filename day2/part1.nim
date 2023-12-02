import strutils
import sequtils
import math

var exampleInput = """Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""

type Subset = object
  red: int
  green: int
  blue: int


type Game = object
  id: int
  subgames: seq[Subset]


proc parseInput(input: string): seq[Game] =
  for line in input.splitLines():
    if line.len == 0: continue
    var game = Game()
    var tmp = line.split(":")
    game.id = parseInt(tmp[0].split()[1])
    var subgamesStr = tmp[1].split(";")
    for subgameStr in subgamesStr:
      var subgame = Subset()
      var colors = subgameStr.split(",")
      for color in colors:
        var tmp = color.strip().split()
        var count = parseInt(tmp[0])
        var color = tmp[1]
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

proc isSubgameValid(subgame: Subset): bool=
  if subgame.red > 12: return false
  if subgame.green > 13: return false
  if subgame.blue > 14: return false
  return true


proc isGameValid(game: Game): bool =
  ## check if game is valid
  ## each subgame needs to be valid
  for subgame in game.subgames:
    if not isSubgameValid(subgame): return false
  return true

proc part1(games: seq[Game]): int =
  var validGames = filter(games, isGameValid)
  var res = validGames.mapIt(it.id).sum()
  return res

proc test() =
  var games = parseInput(exampleInput)
  assert games.len == 5
  assert games[0].id == 1
  assert games[0].subgames.len == 3
  assert games[0].subgames[0].red == 4
  assert games[0].subgames[0].green == 0
  assert games[0].subgames[0].blue == 3
  assert games[0].subgames[1].red == 1
  assert games[0].subgames[1].green == 2
  assert games[0].subgames[1].blue == 6
  assert games[0].subgames[2].red == 0
  assert games[0].subgames[2].green == 2
  assert games[0].subgames[2].blue == 0
  assert games[1].id == 2
  assert games[1].subgames.len == 3
  assert games[1].subgames[0].red == 0
  assert games[1].subgames[0].green == 2
  assert games[1].subgames[0].blue == 1
  assert games[1].subgames[1].red == 1
  assert games[1].subgames[1].green == 3
  assert games[1].subgames[1].blue == 4
  assert games[1].subgames[2].red == 0
  assert games[1].subgames[2].green == 1
  assert games[1].subgames[2].blue == 1
  assert games[2].id == 3
  assert games[2].subgames.len == 3
  assert games[2].subgames[0].red == 20
  assert games[2].subgames[0].green == 8
  assert games[2].subgames[0].blue == 6
  assert games[2].subgames[1].red == 4
  assert games[2].subgames[1].green == 13
  assert games[2].subgames[1].blue == 5
  assert games[2].subgames[2].red == 1
  assert games[2].subgames[2].green == 5
  assert games[2].subgames[2].blue == 0
  assert games[3].id == 4
  assert games[3].subgames.len == 3
  assert games[4].id == 5
  assert games[4].subgames.len == 2
  var res = part1(games)
  assert res == 1+2+5


proc main() =
  echo "Task1"
  test()
  var input = readFile("input.txt")
  var games = parseInput(input)
  var res = part1(games)
  echo res


if isMainModule:
  main()
