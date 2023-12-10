import strutils


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


iterator splitLenInclusiveRemaining*(s: string, length: int): string =
  ## Split a string into substrings of the given length, including the
  ## remaining characters.
  ## Example: splitLenInclusiveRemaining("123456789", 4) -> "1234", "5678", "9"
  var i = 0;
  while i < s.len:
    yield s[i ..< min(i+length, s.len)]
    i += length


iterator splitLenIgnoreRemaining*(s: string, length: int): string =
  ## Split a string into substrings of the given length, ignoring the
  ## remaining characters.
  ## Example: splitLenIgnoreRemaining("123456789", 4) -> "1234", "5678"
  for i in 0 ..< s.len div length:
    yield s[i*length ..< (i+1)*length]


iterator splitLen*(s: string, length: int, ignoreRemaining=false): string =
  ## Split a string into substrings of the given length.
  ## If ignoreRemaining is true, the last substring may be shorter.
  ## Example for ignoreRemaining=false:
  ##   splitLen("123456789", 4) -> "1234", "5678", "9"
  ## Example for ignoreRemaining=true:
  ##   splitLen("123456789", 4) -> "1234", "5678"
  if ignoreRemaining:
    for s in splitLenIgnoreRemaining(s, length):
      yield s
  else:
    for s in splitLenInclusiveRemaining(s, length):
      yield s


