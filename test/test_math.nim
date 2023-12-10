import ../lib/common_math


proc testAddMod() =
  assert addMod(0, 0, 3) == 0
  assert addMod(1, 0, 3) == 1
  assert addMod(2, 0, 3) == 2
  assert addMod(3, 0, 3) == 0
  assert addMod(0, 1, 3) == 1
  assert addMod(1, 1, 3) == 2
  assert addMod(2, 1, 3) == 0
  assert addMod(3, 1, 3) == 1
  assert addMod(1, 2, 3) == 0
  assert addMod(2, 2, 3) == 1
  assert addMod(3, 2, 3) == 2
  assert addMod(4, 2, 3) == 0
  assert addMod(5, 2, 3) == 1
  assert addMod(6, 2, 3) == 2
  assert addMod(7, 2, 3) == 0
  assert addMod(0, 0, 5) == 0
  assert addMod(1, 0, 5) == 1
  assert addMod(2, 0, 5) == 2
  assert addMod(3, 0, 5) == 3
  assert addMod(4, 0, 5) == 4
  assert addMod(5, 0, 5) == 0
  assert addMod(6, 0, 5) == 1
  assert addMod(7, 0, 5) == 2
  assert addMod(8, 0, 5) == 3
  assert addMod(9, 0, 5) == 4
  assert addMod(10, 0, 5) == 0
  assert addMod(0, 1, 5) == 1
  assert addMod(1, 1, 5) == 2
  assert addMod(2, 1, 5) == 3
  assert addMod(3, 1, 5) == 4
  assert addMod(4, 1, 5) == 0
  assert addMod(5, 1, 5) == 1


proc testSubMod() =
  assert subMod(0, 0, 3) == 0
  assert subMod(1, 0, 3) == 1
  assert subMod(2, 0, 3) == 2
  assert subMod(3, 0, 3) == 0
  assert subMod(0, 1, 3) == 2
  assert subMod(1, 1, 3) == 0
  assert subMod(2, 1, 3) == 1
  assert subMod(3, 1, 3) == 2
  assert subMod(1, 2, 3) == 2
  assert subMod(2, 2, 3) == 0
  assert subMod(3, 2, 3) == 1
  assert subMod(4, 2, 3) == 2
  assert subMod(5, 2, 3) == 0
  assert subMod(6, 2, 3) == 1
  assert subMod(7, 2, 3) == 2
  assert subMod(0, 0, 5) == 0
  assert subMod(1, 0, 5) == 1
  assert subMod(2, 0, 5) == 2
  assert subMod(3, 0, 5) == 3
  assert subMod(4, 0, 5) == 4
  assert subMod(5, 0, 5) == 0
  assert subMod(6, 0, 5) == 1
  assert subMod(7, 0, 5) == 2
  assert subMod(8, 0, 5) == 3
  assert subMod(9, 0, 5) == 4
  assert subMod(10, 0, 5) == 0
  assert subMod(0, 1, 5) == 4
  assert subMod(1, 1, 5) == 0
  assert subMod(2, 1, 5) == 1


func testPow() =
  assert pow(0, 0) == 1
  assert pow(0, 1) == 0
  assert pow(1, 0) == 1
  assert pow(1, 1) == 1
  assert pow(2, 0) == 1
  assert pow(2, 1) == 2
  assert pow(2, 2) == 4
  assert pow(2, 3) == 8


func testSumIt() =
  assert @[0, 1, 2, 3, 4].sumIt(it) == 10
  assert @[0, 1, 2, 3, 4].sumIt(it * 2) == 20


if isMainModule:
  testAddMod()
  testSubMod()
  testPow()
  testSumIt()
