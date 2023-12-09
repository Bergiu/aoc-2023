func addMod*(a, b, m: int): int =
  (a + b) mod m


func subMod*(a, b, m: int): int =
  (a - b + m) mod m
