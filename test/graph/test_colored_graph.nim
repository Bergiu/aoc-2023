import sets
import sequtils
import tables

import ../../lib/graph/graph
import ../../lib/graph/colored_graph

proc testInit() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  assert g.colors.pairs.toSeq.len == 0

proc testInitColoredGraph() =
  type Color = enum White, Black
  var g = initColoredGraph[int, Color]()
  assert g.colors.pairs.toSeq.len == 0

proc testInitColoredGraphNodes() =
  type Color = enum White, Black
  var g = initColoredGraph(@[(1, Color.White), (2, Color.Black)])
  assert g.colors.pairs.toSeq.len == 2
  assert g.colors[1] == Color.White
  assert g.colors[2] == Color.Black
  assert g.hasNode(1)
  assert g.hasNode(2)

proc testAddColor() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert g.color(1) == Color.White
  assert g.color(2) == Color.White
  assert g.color(3) == Color.White
  g.addColor(1, Color.Black)
  assert g.color(1) == Color.Black
  assert g.color(2) == Color.White
  assert g.color(3) == Color.White
  g.addColor(2, Color.Black)
  assert g.color(1) == Color.Black
  assert g.color(2) == Color.Black
  assert g.color(3) == Color.White
  g.addColor(3, Color.Black)
  assert g.color(1) == Color.Black
  assert g.color(2) == Color.Black
  assert g.color(3) == Color.Black

proc testColor() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert g.color(1) == Color.White
  assert g.color(2) == Color.White
  assert g.color(3) == Color.White
  g.addColor(1, Color.Black)
  assert g.color(1) == Color.Black
  assert g.color(2) == Color.White
  assert g.color(3) == Color.White
  g.addColor(2, Color.Black)

proc testAddColors() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  g.addEdge(1, 2)
  g.addEdge(1, 3)
  g.addEdge(2, 3)
  assert g.color(1) == Color.White
  assert g.color(2) == Color.White
  assert g.color(3) == Color.White
  g.addColors(@[(1, Color.Black), (2, Color.Black)])
  assert g.color(1) == Color.Black
  assert g.color(2) == Color.Black
  assert g.color(3) == Color.White

proc testAddNode() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  g.addNode(1, Color.White)
  g.addNode(2, Color.Black)
  g.addNode(3, Color.White)
  assert g.nodes.len == 3
  assert g.color(1) == Color.White
  assert g.color(2) == Color.Black
  assert g.color(3) == Color.White

proc testAddNodes() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  g.addNodes(@[(1, Color.White), (2, Color.Black), (3, Color.White)])
  assert g.nodes.len == 3
  assert g.color(1) == Color.White
  assert g.color(2) == Color.Black
  assert g.color(3) == Color.White

proc testHasNode() =
  type Color = enum White, Black
  var g = ColoredGraph[int, Color]()
  g.addNode(1)
  g.addNode(2)
  g.addNode(3)
  assert g.hasNode(1, Color.White)
  assert g.hasNode(2, Color.White)
  assert g.hasNode(3, Color.White)
  assert not g.hasNode(1, Color.Black)
  assert not g.hasNode(4, Color.Black)

if isMainModule:
  testInit()
  testInitColoredGraph()
  testInitColoredGraphNodes()
  testAddColor()
  testColor()
  testAddColors()
  testAddNode()
  testAddNodes()
  testHasNode()
