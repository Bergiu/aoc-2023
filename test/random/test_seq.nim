import ../../lib/common_seq

proc testMapItIf() =
  var a = @[1, 2, 3, 4, 5, 6]
  assert a.mapItIf(it * 2, it mod 2 == 0) == @[4, 8, 12]
  assert a.mapItIf(it * 2, it mod 2 == 1) == @[2, 6, 10]

proc testFindIt() =
  var a = @[1, 2, 3, 4, 5, 6]
  assert a.findIt(it mod 2 == 0) == 1
  assert a.findIt(it mod 2 == 1) == 0

if isMainModule:
  testMapItIf()
  testFindIt()
