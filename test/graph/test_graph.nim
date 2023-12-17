import ../../lib/graph/graph
import sets
import sequtils

proc testInit() =
  let g = Graph[int]()
  assert g.nodes.len == 0
  let h = Graph[string]()
  assert h.nodes.len == 0

proc testInitGraph() =
  let i = initGraph[int]()
  assert i.nodes.len == 0
  let j = initGraph[string]()
  assert j.nodes.len == 0

proc testInitGraphWithNodes() =
  let k = initGraph[int](@[1, 2, 3])
  assert k.nodes.len == 3
  assert k.nodes == [1, 2, 3].toHashSet
  let l = initGraph[string](@["a", "b", "c"])
  assert l.nodes.len == 3
  assert l.nodes == ["a", "b", "c"].toHashSet

proc testAddNode() =
  var g = Graph[int]()
  g.addNode(1)
  assert g.nodes.len == 1
  assert g.nodes == [1].toHashSet
  var h = Graph[string]()
  h.addNode("a")
  assert h.nodes.len == 1
  assert h.nodes == ["a"].toHashSet

proc testAddNodes() =
  var g = Graph[int]()
  g.addNodes(@[1, 2, 3])
  assert g.nodes.len == 3
  assert g.nodes == [1, 2, 3].toHashSet
  var h = Graph[string]()
  h.addNodes(@["a", "b", "c"])
  assert h.nodes.len == 3
  assert h.nodes == ["a", "b", "c"].toHashSet

proc testAddEdge() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  assert g.nodes.len == 2
  assert g.nodes == [1, 2].toHashSet
  assert g.edges.len == 1
  assert g.edges == [(1, 2)].toHashSet
  var h = Graph[string]()
  h.addEdge("a", "b")
  assert h.nodes.len == 2
  assert h.nodes == ["a", "b"].toHashSet
  assert h.edges.len == 1
  assert h.edges == [("a", "b")].toHashSet

proc testAddEdges() =
  var g = Graph[int]()
  g.addEdges(@[(1, 2), (1, 3), (2, 3)])
  assert g.nodes.len == 3
  assert g.nodes == [1, 2, 3].toHashSet
  assert g.edges.len == 3
  assert g.edges == [(1, 2), (1, 3), (2, 3)].toHashSet
  var h = Graph[string]()
  h.addEdges(@[("a", "b"), ("a", "c"), ("b", "c")])
  assert h.nodes.len == 3
  assert h.nodes == ["a", "b", "c"].toHashSet
  assert h.edges.len == 3
  assert h.edges == [("a", "b"), ("a", "c"), ("b", "c")].toHashSet

proc testAddBidirectionalEdge() =
  var g = Graph[int]()
  g.addBidirectionalEdge(1, 2)
  assert g.nodes.len == 2
  assert g.nodes == [1, 2].toHashSet
  assert g.edges.len == 2
  assert g.edges == [(1, 2), (2, 1)].toHashSet
  var h = Graph[string]()
  h.addBidirectionalEdge("a", "b")
  assert h.nodes.len == 2
  assert h.nodes == ["a", "b"].toHashSet
  assert h.edges.len == 2
  assert h.edges == [("a", "b"), ("b", "a")].toHashSet

proc testAddBidirectionalEdges() =
  var g = Graph[int]()
  g.addBidirectionalEdges(@[(1, 2), (1, 3), (2, 3)])
  assert g.nodes.len == 3
  assert g.nodes == [1, 2, 3].toHashSet
  assert g.edges.len == 6
  assert g.edges == [(1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2)].toHashSet
  var h = Graph[string]()
  h.addBidirectionalEdges(@[("a", "b"), ("a", "c"), ("b", "c")])
  assert h.nodes.len == 3
  assert h.nodes == ["a", "b", "c"].toHashSet
  assert h.edges.len == 6
  assert h.edges == [("a", "b"), ("a", "c"), ("b", "a"), ("b", "c"), ("c", "a"), ("c", "b")].toHashSet

proc testHasNode() =
  var g = Graph[int]()
  g.addNode(1)
  assert g.hasNode(1)
  assert not g.hasNode(2)
  var h = Graph[string]()
  h.addNode("a")
  assert h.hasNode("a")
  assert not h.hasNode("b")

proc testHasEdge() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  assert g.hasEdge(1, 2)
  assert not g.hasEdge(2, 1)
  var h = Graph[string]()
  h.addEdge("a", "b")
  assert h.hasEdge("a", "b")
  assert not h.hasEdge("b", "a")

proc testHasBidirectionalEdge() =
  var g = Graph[int]()
  g.addBidirectionalEdge(1, 2)
  assert g.hasBidirectionalEdge(1, 2)
  assert g.hasBidirectionalEdge(2, 1)
  var h = Graph[string]()
  h.addBidirectionalEdge("a", "b")
  assert h.hasBidirectionalEdge("a", "b")
  assert h.hasBidirectionalEdge("b", "a")
  assert not h.hasBidirectionalEdge("a", "c")

proc testOutNeighbors() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert g.outNeighbors(1) == [2, 3].toHashSet
  assert g.outNeighbors(2) == [3].toHashSet
  assert g.outNeighbors(3).len == 0
  var h = Graph[string]()
  h.addEdge("a", "b")
  h.addEdge("a", "c")
  h.addEdge("b", "c")
  assert h.outNeighbors("a") == ["b", "c"].toHashSet
  assert h.outNeighbors("b") == ["c"].toHashSet
  assert h.outNeighbors("c").len == 0

proc testInNeighbors() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert g.inNeighbors(1).len == 0
  assert g.inNeighbors(2) == [1].toHashSet
  assert g.inNeighbors(3) == [1, 2].toHashSet
  var h = Graph[string]()
  h.addEdge("a", "b")
  h.addEdge("a", "c")
  h.addEdge("b", "c")
  assert h.inNeighbors("a").len == 0
  assert h.inNeighbors("b") == ["a"].toHashSet
  assert h.inNeighbors("c") == ["a", "b"].toHashSet

proc testNeighbors() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert g.neighbors(1) == [2, 3].toHashSet
  assert g.neighbors(2) == [1, 3].toHashSet
  assert g.neighbors(3) == [1, 2].toHashSet
  var h = Graph[string]()
  h.addEdge("a", "b")
  h.addEdge("a", "c")
  h.addEdge("b", "c")
  assert h.neighbors("a") == ["b", "c"].toHashSet
  assert h.neighbors("b") == ["a", "c"].toHashSet
  assert h.neighbors("c") == ["a", "b"].toHashSet

proc testInNode() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert 1 in g
  assert 2 in g
  assert 3 in g
  assert not (4 in g)

proc testInEdge() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert (1, 2) in g
  assert (1, 3) in g
  assert (2, 3) in g
  assert not ((1, 4) in g)

proc testInGraph() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  var h = Graph[int]()
  h.addEdge(1, 2)
  h.addEdge(1, 3)
  h.addEdge(2, 3)
  h.addEdge(3, 4)
  assert g in h
  assert g in g
  assert not (h in g)

proc testNotInNode() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert not (1 notin g)
  assert not (2 notin g)
  assert not (3 notin g)
  assert 4 notin g

proc testNotInEdge() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert not ((1, 2) notin g)
  assert not ((1, 3) notin g)
  assert not ((2, 3) notin g)
  assert (1, 4) notin g

proc testNotInGraph() =
  var g = Graph[int]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  var h = Graph[int]()
  h.addEdge(1, 2)
  h.addEdge(1, 3)
  h.addEdge(2, 3)
  h.addEdge(3, 4)
  assert not (g notin h)
  assert not (g notin g)
  assert h notin g

if isMainModule:
  testInit()
  testInitGraph()
  testInitGraphWithNodes()
  testAddNode()
  testAddNodes()
  testAddEdge()
  testAddEdges()
  testAddBidirectionalEdge()
  testAddBidirectionalEdges()
  testHasNode()
  testHasEdge()
  testHasBidirectionalEdge()
  testOutNeighbors()
  testInNeighbors()
  testNeighbors()
  testInNode()
  testInEdge()
  testInGraph()
  testNotInNode()
  testNotInEdge()
  testNotInGraph()
