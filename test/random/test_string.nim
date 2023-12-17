import sequtils
import ../../lib/common_string


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


proc testSplitLen() =
  assert splitLen("abc", 1).toSeq == @["a", "b", "c"]
  assert splitLen("abc", 2).toSeq == @["ab", "c"]
  assert splitLen("abc", 3).toSeq == @["abc"]
  assert splitLen("abc", 4).toSeq == @["abc"]
  assert splitLen("abcdef", 1).toSeq == @["a", "b", "c", "d", "e", "f"]
  assert splitLen("abcdef", 2).toSeq == @["ab", "cd", "ef"]
  assert splitLen("abcdef", 3).toSeq == @["abc", "def"]
  assert splitLen("abcdef", 4).toSeq == @["abcd", "ef"]
  assert splitLen("abcdef", 5).toSeq == @["abcde", "f"]
  assert splitLen("abcdef", 6).toSeq == @["abcdef"]
  assert splitLen("abcdef", 7).toSeq == @["abcdef"]
  assert splitLen("abc", 1, true).toSeq == @["a", "b", "c"]
  assert splitLen("abc", 2, true).toSeq == @["ab"]
  assert splitLen("abc", 3, true).toSeq == @["abc"]
  assert splitLen("123456789", 4, true).toSeq == @["1234", "5678"]
  assert splitLen("abc", 1, false).toSeq == @["a", "b", "c"]
  assert splitLen("abc", 2, false).toSeq == @["ab", "c"]
  assert splitLen("abc", 3, false).toSeq == @["abc"]
  assert splitLen("123456789", 4, false).toSeq == @["1234", "5678", "9"]


proc testSplitLenIgnoreRemaining() =
  assert splitLenIgnoreRemaining("abc", 1).toSeq == @["a", "b", "c"]
  assert splitLenIgnoreRemaining("abc", 2).toSeq == @["ab"]
  assert splitLenIgnoreRemaining("abc", 3).toSeq == @["abc"]
  assert splitLenIgnoreRemaining("123456789", 4).toSeq == @["1234", "5678"]


proc testSplitLenInclusiveRemaining() =
  assert splitLenInclusiveRemaining("abc", 1).toSeq == @["a", "b", "c"]
  assert splitLenInclusiveRemaining("abc", 2).toSeq == @["ab", "c"]
  assert splitLenInclusiveRemaining("abc", 3).toSeq == @["abc"]
  assert splitLenInclusiveRemaining("123456789", 4).toSeq == @["1234", "5678", "9"]


if isMainModule:
  testSplitInv()
  testSplitInvIndex()
  testSplitLinesNoTnl()
  testSplitLen()
  testSplitLenIgnoreRemaining()
  testSplitLenInclusiveRemaining()
