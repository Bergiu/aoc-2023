import strutils
import sequtils


type
  PosObj*[T] = tuple[x, y: int, obj: T]
  Range* = tuple[start, stop: int]
  Coordinate* = tuple[x, y: int]


func addMod*(a, b, m: int): int =
  (a + b) mod m


func subMod*(a, b, m: int): int =
  (a - b + m) mod m


func splitLines*(s: string, keepTnl: bool=true): seq[string] =
  ## Split a string into lines, keeping or discarding the trailing
  ## newline characters.
  var s = s
  removeSuffix(s)
  strutils.splitLines(s)


iterator splitInvIndex*(s: string, seps: set[char] = Whitespace,
                  maxsplit: int = -1): tuple[start, stop: int] =
  ## Split a string into substrings, using the inverse of the given set
  ## of characters as separators and yielding the start and stop indices.
  ## If maxsplit is given, at most maxsplit splits are done.
  var s = s
  var maxsplit = maxsplit
  var last = 0
  if maxsplit != 0:
    # iterate over the string
    for i in 0..<s.len:
      if s[i] notin seps:
        if last == i:
          # skip over non-separators at the start of the string
          last += 1
          continue
        # found a separator
        yield (start: last, stop: i)
        # skip over the separator in the next iteration
        last = i + 1
        # check if we're done
        if maxsplit > 0:
          maxsplit -= 1
          if maxsplit == 0:
            break
  # yield the rest of the string if last < s.len:
  if last < s.len:
    yield (start: last, stop: s.len)


iterator splitInv*(s: string, seps: set[char] = Whitespace,
                  maxsplit: int = -1): string =
  ## Split a string into substrings, using the inverse of the given set
  ## of characters as separators. If maxsplit is given, at most maxsplit
  ## splits are done.
  for (start, stop) in splitInvIndex(s, seps, maxsplit):
    yield s[start..<stop]


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

