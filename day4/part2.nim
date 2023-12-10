import sequtils
import strutils
import sets
import ../lib/common_string
import ../lib/common_math


const exampleInput = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""


type Card = object
  id: int
  winning: seq[int]
  my: seq[int]


proc parseInput(inp: string): seq[Card] =
  for line in inp.splitLines(keepTnl=false):
    let tmp = line.split(":", 1)
    let tmp2 = tmp[1].split("|", 1)
      .mapIt(it.splitLen(3).toSeq.mapIt(it.strip.parseInt))
    result.add(Card(
      id: tmp[0].split(" ", 1)[1].strip.parseInt,
      winning: tmp2[0],
      my: tmp2[1]
    ))


proc part2(cards: seq[Card]): int =
  let winnings = cards.mapIt(it.winning.toHashSet.intersection(it.my.toHashSet).len)
  var copies = cards.mapIt((number: it.id, count: 1, winnings: winnings[it.id-1]))
  for i in 0..<copies.len:
    let copied = copies[i]
    for j in 0..<copied.winnings:
      if i+1+j >= copies.len: break
      inc copies[i+1+j].count, copied.count
  return copies.sumIt(it.count)


proc test() =
  let cards = parseInput(exampleInput)
  for i in 1..6:
    assert cards[i-1].id == i
  assert cards[0].winning == @[41, 48, 83, 86, 17]
  assert cards[0].my == @[83, 86, 6, 31, 17, 9, 48, 53]
  assert cards[3].winning == @[41, 92, 73, 84, 69]
  assert cards[3].my == @[59, 84, 76, 51, 58, 5, 54, 83]
  assert cards[5].winning == @[31, 18, 13, 56, 72]
  assert cards[5].my == @[74, 77, 10, 23, 35, 67, 36, 11]
  assert part2(cards) == 30


proc main() =
  let cards = parseInput(readFile("input.txt"))
  echo part2(cards)


if isMainModule:
  test()
  main()
