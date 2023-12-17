import graph
import tables
import sets
import sequtils

type AttributedGraph*[N, A] = object of Graph[N]
  ## An attributed graph is a graph with edges attributed with an attribute.
  attributes*: Table[tuple[source, destination: N], A]

func initAttributedGraph*[N, A](): AttributedGraph[N, A] =
  ## Initialize an attributed graph.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addAttribute(1, 2, 3) # edge from 1 to 2 has attribute 3
    assert graph.attribute(1, 2) == 3
  return default(AttributedGraph[N, A])

func addAttribute*[N, A](self: var AttributedGraph[N, A], source, destination: N, attribute: A) =
  ## Add an attribute to an edge.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addAttribute(1, 2, 3)
    assert graph.attribute(1, 2) == 3
  self.addEdge(source, destination)
  self.attributes[(source, destination)] = attribute

func attribute*[N, A](self: AttributedGraph[N, A], source, destination: N): A =
  ## Get the attribute of an edge.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addAttribute(1, 2, 3)
    assert graph.attribute(1, 2) == 3
  if (source, destination) notin self.attributes:
    return default(A)
  return self.attributes[(source, destination)]

func addEdge*[N, A](self: var AttributedGraph[N, A], source, destination: N, attribute: A) =
  ## Add an edge with an attribute.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addEdge(1, 2, 3)
    assert graph.attribute(1, 2) == 3
  self.addEdge(source, destination)
  self.addAttribute(source, destination, attribute)

func addEdges*[N, A](self: var AttributedGraph[N, A], edges: openarray[tuple[source, destination: N, attribute: A]]) =
  ## Add multiple edges at once with attributes.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addEdges(@[(1, 2, 3), (2, 3, 4)])
    assert graph.attribute(1, 2) == 3
    assert graph.attribute(2, 3) == 4
  self.addEdges(edges.mapIt((it.source, it.destination)))
  for (source, destination, attribute) in edges:
    self.addAttribute(source, destination, attribute)

func addBidirectionalEdge*[N, A](self: var AttributedGraph[N, A], source, destination: N, attribute: A) =
  ## Add a bidirectional edge with an attribute.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addBidirectionalEdge(1, 2, 3)
    assert graph.attribute(1, 2) == 3
    assert graph.attribute(2, 1) == 3
  self.addEdge(source, destination, attribute)
  self.addEdge(destination, source, attribute)

func addBidirectionalEdges*[N, A](self: var AttributedGraph[N, A], edges: openarray[tuple[source, destination: N, attribute: A]]) =
  ## Add multiple bidirectional edges at once with attributes.
  ## If the nodes are not already in the graph, they are added.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addBidirectionalEdges(@[(1, 2, 3), (2, 3, 4)])
    assert graph.attribute(1, 2) == 3
    assert graph.attribute(2, 1) == 3
    assert graph.attribute(2, 3) == 4
    assert graph.attribute(3, 2) == 4
  self.addBidirectionalEdges(edges.mapIt((it.source, it.destination)))
  for (source, destination, attribute) in edges:
    self.addAttribute(source, destination, attribute)
    self.addAttribute(destination, source, attribute)

func hasEdge*[N, A](self: AttributedGraph[N, A], source, destination: N, attribute: A): bool =
  ## Check if an edge with an attribute exists.
  runnableExamples:
    var graph = initAttributedGraph[int, int]()
    graph.addEdge(1, 2, 3)
    assert graph.hasEdge(1, 2, 3)
  self.hasEdge(source, destination) and self.attribute(source, destination) == attribute
