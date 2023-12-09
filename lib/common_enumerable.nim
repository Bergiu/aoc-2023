import sequtils
import common_types


iterator enumerate*[T](s: seq[T], start: int = 0): (int, T) =
  ## Return an iterator that yields pairs (i, s[i]), where i is the
  ## index of the item in the sequence.
  for i in start..<s.len:
    yield (i, s[i])


iterator enumerate2D*[T](inp: seq[seq[T]]): PosObj[char] =
  for i, line in enumerate(inp):
    for j, c in enumerate(line):
      yield (x: j, y: i, obj: c)


iterator enumerate2D*(inp: seq[string]): PosObj[char] =
  for i, line in enumerate(inp):
    for j, c in enumerate(line.toSeq):
      yield (x: j, y: i, obj: c)


proc flatten*[T](s: seq[seq[T]]): seq[T] =
  ## Flatten a sequence of sequences.
  for x in s:
    for y in x:
      result.add(y)
