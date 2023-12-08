import sequtils
import strutils
import std/setutils
import math
import common
import std/enumerate


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
const notsymbols = {'0'..'9', '.'}


type Range = tuple[start, stop: int]


type Number = object
  line: int
  columns: Range
  value: int


func neighbors(field: seq[string], number: Number): set[char] =
  var all = ""
  let start = max(number.columns.start-1, 0)
  let stop = min(number.columns.stop, field[number.line].len-1)
  if number.line > 0:
    all &= field[number.line-1][start..stop]
  if number.columns.start != 0:
    all &= field[number.line][start]
  if number.columns.stop != field[number.line].len-1:
    all &= field[number.line][stop]
  if number.line < field.len-1:
    all &= field[number.line+1][start..stop]
  return all.toSet()


proc parseNumber(line: string, lineNr: int, r: Range): Number =
  return Number(line: lineNr, columns: r, value: line[r.start..<r.stop].parseInt())


proc parseLine(line: string, lineNr: int): seq[Number] =
  return line.splitInvIndex(numbers).toSeq()
             .mapIt(parseNumber(line, lineNr, it))


func isSymbol(c: char): bool =
  return c notin notsymbols


proc parse(str: string): seq[string] =
  return str.splitLines(keepTnl=false)


proc getNumbers(inp: seq[string]): seq[Number] =
  for i, line in enumerate(inp):
    result.add(parseLine(line, i))


proc filterNumbers(inp: seq[string], numbers: seq[Number]): seq[Number] =
  return numbers.filterIt(neighbors(inp, it).toSeq().any(isSymbol))


proc part1(numbers: seq[Number]): int =
  return numbers.mapIt(it.value).sum()


proc test() =
  let input = parse(exampleInput)
  let numbers = getNumbers(input)
  let filteredNumbers = filterNumbers(input, numbers)
  let s = part1(filteredNumbers)
  assert s == 4361


proc main() =
  let input = parse(readFile("input.txt"))
  let numbers = getNumbers(input)
  let filteredNumbers = filterNumbers(input, numbers)
  echo part1(filteredNumbers)


if isMainModule:
  test()
  main()
