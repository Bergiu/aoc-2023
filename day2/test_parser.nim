import parser


const exampleInput* = """Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""


func test() =
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


if isMainModule:
  test()
