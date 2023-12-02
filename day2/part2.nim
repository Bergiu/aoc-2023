import sequtils
import parser
import test_parser
import math


func minNeccessary(game: Game): int =
  let maxValues = Subset(
    red: game.subgames.mapIt(it.red).max(),
    blue: game.subgames.mapIt(it.blue).max(),
    green: game.subgames.mapIt(it.green).max()
  )
  return @[maxValues.red, maxValues.green, maxValues.blue].foldl(a*b)


func part2(games: openArray[Game]): int =
  return games.map(minNeccessary).sum()


func test() =
  let games = parseInput(exampleInput)
  let res = part2(games)
  assert res == 2286


proc main() =
  echo "Task1"
  test()
  let input = readFile("input.txt")
  let games = parseInput(input)
  let res = part2(games)
  echo res


if isMainModule:
  main()
