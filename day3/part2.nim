import sequtils
import strutils
import math
import ../lib/common_types
import ../lib/common_string
import ../lib/common_enumerable
import sugar


const exampleInput = """467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

const numbers = {'0'..'9'}


type Number = object
  line: int
  columns: Range
  value: int


func toCoord[T](p: PosObj[T]): Coordinate = (x: p.x, y: p.y)


func intersecting(coord: Coordinate, number: Number): bool =
  coord.x >= number.columns.start and
  coord.x < number.columns.stop and
  coord.y == number.line


func neighbors(coord: Coordinate, width, height: int): seq[Coordinate] =
  ## A neighbor of a coordinate is a coordinate that is adjacent to it
  let position = [(-1, -1), (-1, 0), (-1, 1),
                  (0, -1), (0, 1),
                  (1, -1), (1, 0), (1, 1)]
  position.mapIt((x: coord.x + it[0], y: coord.y + it[1]))
          .filterIt(it.x >= 0 and it.x < width and
                    it.y >= 0 and it.y < height)

proc neighbors(coord: Coordinate, numbers: seq[Number], width, height: int): seq[Number] =
  ## Neighboring numbers of a coordinate are numbers that have coordinates
  ## intersecting with the neighboring coordinates of the given coordinate
  let coords = coord.neighbors(width, height)
  numbers.filter(n => coords.anyIt(intersecting(it, n)))


proc parse(str: string): seq[string] =
  ## Returns the lines of the input, without the trailing newline
  str.splitLines(keepTnl=false)


proc parseNumber(line: string, lineNr: int, r: Range): Number =
  ## Parses a number from a line in the given range
  Number(line: lineNr, columns: r, value: line[r.start..<r.stop].parseInt())


proc parseLine(line: string, lineNr: int): seq[Number] =
  ## Parses all numbers from a line
  line.splitInvIndex(numbers).toSeq()
      .mapIt(parseNumber(line, lineNr, it))


func isGear(c: char): bool =
  c == '*'


proc getNumbers(inp: seq[string]): seq[Number] =
  ## Returns all numbers from the input
  enumerate(inp).toSeq.mapIt(parseLine(it[1], it[0])).flatten()

# proc getNumbers(inp: seq[string]): seq[Number] =
#   ## Returns all numbers from the input
#   for i, line in enumerate(inp):
#     result.add(parseLine(line, i))


proc part2(inp: seq[string]): int =
  let numbers = getNumbers(inp)
  let positions = inp.enumerate2D.toSeq
  let gears = positions.filterIt(it.obj.isGear).map(toCoord)
  let gearRatios = gears.mapIt(neighbors(it, numbers, inp[0].len, inp.len))
                  .filterIt(it.len == 2)
                  .mapIt(it.foldl(a * b.value, 1))
  gearRatios.sum()


proc test() =
  let input = parse(exampleInput)
  let s = part2(input)
  assert s == 467835


proc main() =
  let input = parse(readFile("input.txt"))
  echo part2(input)


if isMainModule:
  test()
  main()

