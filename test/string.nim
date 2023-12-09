import sequtils
import ../lib/common_string


proc testSplitInv() =
  let example = "1 3 5 2 4 6"
  assert toSeq(splitInv(example, {'1', '3', '5', '2', '4', '6'})) == @["1", "3", "5", "2", "4", "6"]
  assert toSeq(splitInv(example, {'1', '3', '5', '2', '4', '6'}, maxsplit=0)) == @["1 3 5 2 4 6"]
  assert toSeq(splitInv(example, {'1', '3', '5', '2', '4', '6'}, maxsplit=1)) == @["1", "3 5 2 4 6"]
  assert toSeq(splitInv(example, {'1', '3', '5', '2', '4', '6'}, maxsplit=2)) == @["1", "3", "5 2 4 6"]
  assert toSeq(splitInv(example)) == @[" ", " ", " ", " ", " "]
  assert toSeq(splitInv("1234.567 890", {'0'..'9'})) == @["1234", "567", "890"]


proc testSplitInvIndex() =
  assert toSeq(splitInvIndex("1234.567 890", {'0'..'9'})) == @[(start: 0, stop: 4), (start: 5, stop: 8), (start: 9, stop: 12)]
  assert toSeq(splitInvIndex("1234.567 890", {'0'..'9'}, maxsplit=0)) == @[(start: 0, stop: 12)]
  assert toSeq(splitInvIndex("1234.567 890", {'0'..'9'}, maxsplit=1)) == @[(start: 0, stop: 4), (start: 5, stop: 12)]
  assert toSeq(splitInvIndex("1234.567 890", {'0'..'9'}, maxsplit=2)) == @[(start: 0, stop: 4), (start: 5, stop: 8), (start: 9, stop: 12)]
  assert toSeq(splitInvIndex("1 2 3 4.567 890", {'0'..'9'})) == @[(start: 0, stop: 1), (start: 2, stop: 3), (start: 4, stop: 5), (start: 6, stop: 7), (start: 8, stop: 11), (start: 12, stop: 15)]


proc testSplitLinesNoTnl() =
  assert splitLines("abc", keepTnl=false) == @["abc"]
  assert splitLines("abc\n", keepTnl=false) == @["abc"]
  assert splitLines("abc\r\n", keepTnl=false) == @["abc"]
  assert splitLines("abc\r", keepTnl=false) == @["abc"]
  assert splitLines("abc\n\r", keepTnl=false) == @["abc"]
  assert splitLines("abc\n\n\n", keepTnl=false) == @["abc"]
  assert splitLines("abc\ndef", keepTnl=false) == @["abc", "def"]
  assert splitLines("abc\ndef\n", keepTnl=false) == @["abc", "def"]
  assert splitLines("abc\ndef\r\n", keepTnl=false) == @["abc", "def"]
  assert splitLines("abc\r\ndef\r", keepTnl=false) == @["abc", "def"]
  assert splitLines("abc\n\rdef\r", keepTnl=false) == @["abc", "", "def"]  # \n\r is two lines


if isMainModule:
  testSplitInv()
  testSplitInvIndex()
  testSplitLinesNoTnl()
