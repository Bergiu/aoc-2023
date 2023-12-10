import math
import sequtils


func addMod*(a, b, m: int): int =
  (a + b) mod m


func subMod*(a, b, m: int): int =
  (a - b + m) mod m


func pow*(x, y: int): int =
  pow(x.float, y.float).round.int


template sumIt*[T](a: openarray[T], b: untyped): auto =
  sum(mapIt(a, b))
