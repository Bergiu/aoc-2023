import sequtils


template mapItIf*(a: openarray[auto], map: untyped, filter: untyped): auto =
  mapIt(filterIt(a, filter), map)
