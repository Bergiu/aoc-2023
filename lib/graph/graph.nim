import sets
import tables
import deques
import sequtils

import ../common_seq
import ../common_set

type
  Graph*[N] = object of RootObj
    ## A graph is a set of nodes and edges.
    nodes*: HashSet[N]
    edges*: HashSet[tuple[source, destination: N]]

func initGraph*[N](): Graph[N] =
  ## Initialize a graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert graph.hasEdge(1, 2)
  return default(Graph[N])

func initGraph*[N](nodes: openarray[N]): Graph[N] =
  ## Initialize a graph with nodes.
  runnableExamples:
    var graph = initGraph[int](@[1, 2, 3])
    assert graph.nodes.len == 3
  result.nodes = nodes.toHashSet

func addNode*[N](self: var Graph[N], node: N) =
  ## Add a node.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addNode(1)
    assert graph.nodes.len == 1
  self.nodes.incl(node)

func addNodes*[N](self: var Graph[N], nodes: openarray[N]) =
  ## Add multiple nodes at once.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addNodes(@[1, 2, 3])
    assert graph.nodes.len == 3
  self.nodes.incl(nodes.toHashSet)

func addEdge*[N](self: var Graph[N], source, destination: N) =
  ## Add an edge.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert graph.hasEdge(1, 2)
  self.nodes.incl(source)
  self.nodes.incl(destination)
  self.edges.incl((source, destination))

func addEdges*[N](self: var Graph[N], edges: openarray[tuple[source, destination: N]]) =
  ## Add multiple edges at once.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdges(@[(1, 2), (2, 3)])
    assert graph.hasEdge(1, 2)
    assert graph.hasEdge(2, 3)
  self.nodes.incl(edges.mapIt(it.source).toHashSet)
  self.nodes.incl(edges.mapIt(it.destination).toHashSet)
  self.edges.incl(edges.toHashSet)

func addBidirectionalEdge*[N](self: var Graph[N], source, destination: N) =
  ## Add a bidirectional edge.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addBidirectionalEdge(1, 2)
    assert graph.hasEdge(1, 2)
    assert graph.hasEdge(2, 1)
  self.addEdge(source, destination)
  self.addEdge(destination, source)

func addBidirectionalEdges*[N](self: var Graph[N], edges: openarray[tuple[source, destination: N]]) =
  ## Add multiple bidirectional edges at once.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addBidirectionalEdges(@[(1, 2), (2, 3)])
    assert graph.hasEdge(1, 2)
    assert graph.hasEdge(2, 1)
    assert graph.hasEdge(2, 3)
    assert graph.hasEdge(3, 2)
  self.addEdges(edges)
  self.addEdges(edges.mapIt((it.destination, it.source)))

func hasNode*[N](self: Graph[N], node: N): bool =
  ## Check if a node exists.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addNode(1)
    assert graph.hasNode(1)
  node in self.nodes

func hasEdge*[N](self: Graph[N], source, destination: N): bool =
  ## Check if an edge exists.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert graph.hasEdge(1, 2)
  (source, destination) in self.edges

func hasBidirectionalEdge*[N](self: Graph[N], source, destination: N): bool =
  ## Check if a bidirectional edge exists.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addBidirectionalEdge(1, 2)
    assert graph.hasBidirectionalEdge(1, 2)
    assert graph.hasBidirectionalEdge(2, 1)
  self.hasEdge(source, destination) and self.hasEdge(destination, source)

func outNeighbors*[N](self: Graph[N], node: N): HashSet[N] =
  ## Get the outgoing neighbors of a node.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert graph.outNeighbors(1) == @[2].toHashSet
  self.edges.toSeq.mapItIf(it.destination, it.source == node).toHashSet

func inNeighbors*[N](self: Graph[N], node: N): HashSet[N] =
  ## Get the incoming neighbors of a node.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert graph.inNeighbors(2) == @[1].toHashSet
  self.edges.toSeq.mapItIf(it.source, it.destination == node).toHashSet

func neighbors*[N](self: Graph[N], node: N): HashSet[N] =
  ## Get the incoming and outgoing neighbors of a node.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert graph.neighbors(1) == @[2].toHashSet
    assert graph.neighbors(2) == @[1].toHashSet
  self.outNeighbors(node).union(self.inNeighbors(node))

func `in`*[N](node: N, graph: Graph[N]): bool =
  ## Check if a node is in the graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addNode(1)
    assert 1 in graph
  graph.hasNode(node)

func `in`*[N](edge: tuple[source, destination: N], graph: Graph[N]): bool =
  ## Check if an edge is in the graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert (1, 2) in graph
  graph.hasEdge(edge.source, edge.destination)

func `in`*[N](self: Graph[N], graph: Graph[N]): bool =
  ## Check if a graph is a subgraph of another graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdges(@[(1, 2), (2, 3)])
    var subgraph = initGraph[int]()
    subgraph.addEdges(@[(1, 2), (2, 3)])
    assert subgraph in graph
  graph.nodes.isSuperset(self.nodes) and graph.edges.isSuperset(self.edges)

func `notin`*[N](node: N, graph: Graph[N]): bool =
  ## Check if a node is not in the graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addNode(1)
    assert 2 notin graph
  not (node in graph)

func `notin`*[N](edge: tuple[source, destination: N], graph: Graph[N]): bool =
  ## Check if an edge is not in the graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    assert (2, 1) notin graph
  not (edge in graph)

func `notin`*[N](self: Graph[N], graph: Graph[N]): bool =
  ## Check if a graph is not a subgraph of another graph.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdges(@[(1, 2), (2, 3)])
    var notsubgraph = initGraph[int]()
    notsubgraph.addEdges(@[(1, 2), (2, 4)])
    assert subgraph notin graph
  not (self in graph)
