import sets


func union*[A](a, b: openarray[A]): HashSet[A] =
  a.toHashSet + b.toHashSet

func isSubset*[A](a, b: HashSet[A]): bool =
  a.difference(b).len == 0

func isSuperset*[A](a, b: HashSet[A]): bool =
  b.difference(a).len == 0
