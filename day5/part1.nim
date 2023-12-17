import strutils
import sequtils
import intsets
import re
import sets
import deques
import tables
import algorithm

import ../lib/common_string
import ../lib/common_set
import ../lib/common_seq
import ../lib/graph/attributed_graph
import ../lib/graph/graph
import ../lib/graph/search


const exampleInput = """seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""


type State = enum
  EmptyLine
  SeedList
  Map


type Range = object
  sourceStart: int
  destinationStart: int
  length: int


func increase(self: Range): int =
  self.destinationStart - self.sourceStart 


func `==`(self: Range, index: int): bool =
  index in self.sourceStart ..< self.sourceStart + self.length


func reverse(self: Range): Range =
  return Range(
    sourceStart: self.destinationStart,
    destinationStart: self.sourceStart,
    length: self.length)


type Mapping = object
  source: string
  destination: string
  ranges: seq[Range]


func reverse(self: Mapping): Mapping =
  Mapping(
    source: self.destination,
    destination: self.source,
    ranges: self.ranges.mapIt(it.reverse))


proc `[]`(self: Mapping, index: int): int =
  var i = self.ranges.find(index)
  if i == -1:
    return index
  return self.ranges[i].increase + index


template findIt*[T](a: openarray[T], b: untyped): auto =
  a.mapIt(b).find(true)

func graph(self: seq[Mapping]): AttributedGraph[string, Mapping] =
  var g = AttributedGraph[string, Mapping]()
  for mapping in self:
    g.addEdge(mapping.source, mapping.destination, mapping)
    g.addEdge(mapping.destination, mapping.source, mapping.reverse)
  return g

func `[]`(self: seq[Mapping], cat1, cat2: string): Mapping =
  var i = self.findIt(it.source == cat1 and it.destination == cat2)
  if i != -1:
    return self[i]
  i = self.findIt(it.source == cat2 and it.destination == cat1)
  if i != -1:
    return self[i].reverse
  return Mapping(source: cat1, destination: cat2, ranges: @[])

func convert(self: seq[Mapping], cat1, cat2: string, number: int): int =
  let g = self.graph
  var path = g.shortestPathEdges(cat1, cat2)
  result = number
  for (start, destination) in path:
    let mapping = g.attribute(start, destination)
    result = mapping[result]

proc parseRange(line: string): Range =
  let parts = line.split(WHITESPACE, 3).mapIt(it.strip).map(parseInt)
  return Range(
    destinationStart: parts[0],
    sourceStart: parts[1],
    length: parts[2])


proc parse(input: string): tuple[seeds: IntSet, mappings: seq[Mapping]] =
  let l = input.splitLines(keepTnl=true)
  var state = EmptyLine
  let mapRegex = re"^(\w+)-to-(\w+) map:$"
  var matches: array[2, string]
  for line in l:
    if line.strip == "":
      state = EmptyLine
    elif line.startsWith("seeds:"):
      state = SeedList
      let seeds = line.split(": ", 1)[1].split.mapIt(it.strip).map(parseInt).toIntSet
      result.seeds.incl(seeds)
    elif line.match(mapRegex, matches):
      state = Map
      let mapping = Mapping(
        source: matches[0],
        destination: matches[1],
        ranges: @[])
      result.mappings.add(mapping)
    elif state == SeedList:
      let seeds = line.split.mapIt(it.strip).map(parseInt).toIntSet
      result.seeds.incl(seeds)
    elif state == Map:
      let range = parseRange(line)
      result.mappings[^1].ranges.add(range)

proc part1List(seeds: IntSet, mappings: seq[Mapping]): seq[int] =
  seeds.mapIt(mappings.convert("seed", "location", it)).sorted()

proc part1(seeds: IntSet, mappings: seq[Mapping]): int =
  part1List(seeds, mappings)[0]

proc test() =
  let tmp = parse(exampleInput)
  var seeds = tmp.seeds
  let mappings = tmp.mappings
  let seedSoilTest = [
    (0, 0), (1, 1), (48, 48), (49, 49), (50, 52), (51, 53),
    (96, 98), (97, 99), (98, 50), (99, 51),
  ]
  assert seeds == [79, 14, 55, 13].toIntSet
  for (seed, soil) in seedSoilTest:
    assert mappings["seed", "soil"][seed] == soil
    assert mappings["soil", "seed"][soil] == seed
  assert part1List(seeds, mappings) == @[35, 43, 82, 86]
  assert part1(seeds, mappings) == 35

proc main() =
  let input = parse(readFile("input.txt"))
  echo part1(input.seeds, input.mappings)

if isMainModule:
  test()
  main()
