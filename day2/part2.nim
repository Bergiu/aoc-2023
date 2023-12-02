import sequtils
import parser
import test_parser


proc minNeccessary(game: Game): int =
  var maxValues = Subset()
  for subgame in game.subgames:
    if subgame.red > maxValues.red:
      maxValues.red = subgame.red
    if subgame.green > maxValues.green:
      maxValues.green = subgame.green
    if subgame.blue > maxValues.blue:
      maxValues.blue = subgame.blue
  return @[maxValues.red, maxValues.green, maxValues.blue].foldl(a*b)


proc part2(games: seq[Game]): int =
  for game in games:
    result += minNeccessary(game)


proc test() =
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
