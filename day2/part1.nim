import sequtils
import math
import parser
import test_parser


const minSubgame = Subset(red: 12, green: 13, blue: 14)


func isSubgameValid(subgame: Subset): bool =
  if subgame.red > minSubgame.red: return false
  if subgame.green > minSubgame.green: return false
  if subgame.blue > minSubgame.blue: return false
  return true


func isGameValid(game: Game): bool =
  ## check if game is valid
  ## each subgame needs to be valid
  return game.subgames.all(isSubgameValid)


func part1(games: openArray[Game]): int =
  return filter(games, isGameValid).mapIt(it.id).sum()


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
