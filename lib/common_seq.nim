import sequtils

template mapItIf*(a: openarray[auto], map: untyped, filter: untyped): auto =
  mapIt(filterIt(a, filter), map)

template findIt*(a: openarray[auto], b: untyped): int =
  mapIt(a, b).find(true)

