import sequtils
import sets

import ../../lib/graph/graph
import ../../lib/graph/search


proc testBFS() =
  var g = Graph[string]()
  # e -> a <- b
  #      | \  ^
  #      v  \ |
  #      d <- c
  g.addEdge("a", "d")
  g.addBidirectionalEdge("a", "c")
  g.addEdge("c", "d")
  g.addEdge("c", "b")
  g.addEdge("b", "a")
  g.addEdge("e", "a")
  let l = g.bfs("a").toSeq
  echo l
  assert l.len == 4
  assert l[0] == "a"
  assert l[1] in ["d", "c"]
  assert l[2] in ["d", "c"]
  assert l[2] != l[1]
  assert l[3] == "b"


proc testBFSWithDepth() =
  var g = Graph[string]()
  # e -> a <- b
  #      | \  ^
  #      v  \ |
  #      d <- c
  g.addEdge("a", "d")
  g.addBidirectionalEdge("a", "c")
  g.addEdge("c", "d")
  g.addEdge("c", "b")
  g.addEdge("b", "a")
  g.addEdge("e", "a")
  let l = g.bfsWithDepth("a").toSeq
  assert l.len == 4
  assert l[0] == ("a", 0)
  assert l[1] in @[("d", 1), ("c", 1)].toHashSet
  assert l[2] in @[("d", 1), ("c", 1)].toHashSet
  assert l[2] != l[1]
  assert l[3] == ("b", 2)


proc testShortestPath() =
  var g = Graph[string]()
  # e -> a <- b
  #      | \  ^
  #      v  \ |
  #      d <- c
  g.addEdge("a", "d")
  g.addBidirectionalEdge("a", "c")
  g.addEdge("c", "d")
  g.addEdge("c", "b")
  g.addEdge("b", "a")
  g.addEdge("e", "a")
  let l = g.shortestPath("a", "b")
  assert l.len == 3
  assert l[0] == "a"
  assert l[1] == "c"
  assert l[2] == "b"
  let o = g.shortestPath("b", "a")
  assert o.len == 2
  assert o[0] == "b"
  assert o[1] == "a"
  let k = g.shortestPath("a", "e")
  assert k.len == 0
  let m = g.shortestPath("a", "a")
  assert m.len == 1
  assert m[0] == "a"


if isMainModule:
  testBFS()
  testBFSWithDepth()
  testShortestPath()
