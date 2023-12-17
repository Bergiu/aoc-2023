import graph
import tables
import sets
import sequtils

type ColoredGraph*[N, C] = object of Graph[N]
  ## A colored graph is a graph with nodes colored with a color.
  colors*: Table[N, C]

func initColoredGraph*[N, C](): ColoredGraph[N, C] =
  ## Initialize a colored graph.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addColor(1, 2) # node 1 has color 2
    assert graph.color(1) == 2
  return default(ColoredGraph[N, C])

func initColoredGraph*[N, C](nodes: openarray[tuple[node: N, color: C]]): ColoredGraph[N, C] =
  ## Initialize a colored graph with nodes and colors.
  runnableExamples:
    var graph = initColoredGraph[int, int](@[(1, 2), (2, 3)])
    assert graph.color(1) == 2
    assert graph.color(2) == 3
  for (node, color) in nodes:
    # also adds the node
    result.addColor(node, color)

func addColor*[N, C](self: var ColoredGraph[N, C], node: N, color: C) =
  ## Add a color to a node.
  ## If the node does not exist, it will be created.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addColor(1, 2)
    assert graph.color(1) == 2
  self.nodes.incl(node)
  self.colors[node] = color

func addColors*[N, C](self: var ColoredGraph[N, C], colors: openarray[tuple[node: N, color: C]]) =
  ## Add multiple colors to nodes.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addColors(@[(1, 2), (2, 3)])
    assert graph.color(1) == 2
    assert graph.color(2) == 3
  for (node, color) in colors:
    self.addColor(node, color)

func color*[N, C](self: ColoredGraph[N, C], node: N): C =
  ## Get the color of a node.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addColor(1, 2)
    assert graph.color(1) == 2
  if not self.colors.hasKey(node):
    return default(C)
  return self.colors[node]

func addNode*[N, C](self: var ColoredGraph[N, C], node: N, color: C) =
  ## Add a node with a color.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addNode(1, 2)
    assert graph.color(1) == 2
  self.addNode(node)
  self.addColor(node, color)

func addNodes*[N, C](self: var ColoredGraph[N, C], nodes: openarray[tuple[node: N, color: C]]) =
  ## Add multiple nodes at once with colors.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addNodes(@[(1, 2), (2, 3)])
    assert graph.color(1) == 2
    assert graph.color(2) == 3
  self.addColors(nodes)

func hasNode*[N, C](self: ColoredGraph[N, C], node: N, color: C): bool =
  ## Check if a node with a color exists.
  runnableExamples:
    var graph = initColoredGraph[int, int]()
    graph.addNode(1, 2)
    assert graph.hasNode(1, 2)
  self.hasNode(node) and self.color(node) == color

