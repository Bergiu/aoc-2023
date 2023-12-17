import sets
import sequtils
import tables

import ../../lib/graph/graph
import ../../lib/graph/attributed_graph

proc testInit() =
  type Color = enum White, Black
  let g = AttributedGraph[int, Color]()
  assert g.edges.len == 0
  assert g.nodes.len == 0
  assert g.attributes.pairs.toSeq.len == 0

proc testInitGraph() =
  type Color = enum White, Black
  let g = initAttributedGraph[int, Color]()
  assert g.edges.len == 0
  assert g.nodes.len == 0
  assert g.attributes.pairs.toSeq.len == 0

proc testAddAttribute() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addAttribute(1, 2, Color.White)
  assert g.hasNode(1)
  assert g.hasNode(2)
  assert g.hasEdge(1, 2)
  assert g.attributes.pairs.toSeq.len == 1
  assert g.attribute(1, 2) == Color.White

proc testAttribute() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addAttribute(1, 2, Color.White)
  assert g.attribute(1, 2) == Color.White

proc testAddEdge() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addEdge(1, 2, Color.White)
  assert g.hasNode(1)
  assert g.hasNode(2)
  assert g.hasEdge(1, 2)
  assert g.attributes.pairs.toSeq.len == 1
  assert g.attribute(1, 2) == Color.White

proc testAddEdges() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addEdges(@[(1, 2, Color.White), (2, 3, Color.Black)])
  assert g.hasNode(1)
  assert g.hasNode(2)
  assert g.hasNode(3)
  assert g.hasEdge(1, 2)
  assert g.hasEdge(2, 3)
  assert g.attributes.pairs.toSeq.len == 2
  assert g.attribute(1, 2) == Color.White
  assert g.attribute(2, 3) == Color.Black

proc testAddBidirectionalEdge() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addBidirectionalEdge(1, 2, Color.White)
  assert g.hasNode(1)
  assert g.hasNode(2)
  assert g.hasEdge(1, 2)
  assert g.hasEdge(2, 1)
  assert g.attributes.pairs.toSeq.len == 2
  assert g.attribute(1, 2) == Color.White
  assert g.attribute(2, 1) == Color.White

proc testAddBidirectionalEdges() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addBidirectionalEdges(@[(1, 2, Color.White), (2, 3, Color.Black)])
  assert g.hasNode(1)
  assert g.hasNode(2)
  assert g.hasNode(3)
  assert g.hasEdge(1, 2)
  assert g.hasEdge(2, 1)
  assert g.hasEdge(2, 3)
  assert g.hasEdge(3, 2)
  assert g.attributes.pairs.toSeq.len == 4
  assert g.attribute(1, 2) == Color.White
  assert g.attribute(2, 1) == Color.White
  assert g.attribute(2, 3) == Color.Black
  assert g.attribute(3, 2) == Color.Black

proc testHasEdge() =
  type Color = enum White, Black
  var g = initAttributedGraph[int, Color]()
  g.addBidirectionalEdges(@[(1, 2, Color.White), (2, 3, Color.Black)])
  assert g.hasEdge(1, 2)
  assert g.hasEdge(2, 1)
  assert g.hasEdge(2, 3)
  assert g.hasEdge(3, 2)
  assert not g.hasEdge(1, 3)
  assert not g.hasEdge(3, 1)

if isMainModule:
  testInit()
  testInitGraph()
  testAddAttribute()
  testAttribute()
  testAddEdge()
  testAddEdges()
  testAddBidirectionalEdge()
  testAddBidirectionalEdges()
  testHasEdge()
