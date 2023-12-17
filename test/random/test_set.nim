import ../../lib/common_set
import sets

proc testUnion() =
  assert union([1, 2, 3], [2, 3, 4]) == [1, 2, 3, 4].toHashSet
  assert union([1, 2, 3, 4], [2, 3, 4]) == [1, 2, 3, 4].toHashSet
  assert union([1, 2, 3], [2, 3, 4, 5]) == [1, 2, 3, 4, 5].toHashSet

proc testIsSubset() =
  assert isSubset([1, 2, 3].toHashSet, [2, 3, 4].toHashSet) == false
  assert isSubset([1, 2, 3, 4].toHashSet, [2, 3, 4].toHashSet) == false
  assert isSubset([1, 2, 3].toHashSet, [1, 2, 3, 4].toHashSet) == true

proc testIsSuperset() =
  assert isSuperset([1, 2, 3].toHashSet, [2, 3, 4].toHashSet) == false
  assert isSuperset([1, 2, 3, 4].toHashSet, [2, 3, 4].toHashSet) == true
  assert isSuperset([1, 2, 3].toHashSet, [1, 2, 3, 4].toHashSet) == false

if isMainModule:
  testUnion()
  testIsSubset()
  testIsSuperset()
