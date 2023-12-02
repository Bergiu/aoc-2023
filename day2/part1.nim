import sequtils
import math
import parser
import test_parser


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
  let validGames = filter(games, isGameValid)
  return validGames.mapIt(it.id).sum()


proc test() =
  let games = parseInput(exampleInput)
  let res = part1(games)
  assert res == 1+2+5


proc main() =
  echo "Task1"
  test()
  let input = readFile("input.txt")
  let games = parseInput(input)
  let res = part1(games)
  echo res


if isMainModule:
  main()
