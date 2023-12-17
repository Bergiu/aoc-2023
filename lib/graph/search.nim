import sets
import deques
import graph


iterator bfs*[N](self: Graph[N], start: N): N =
  ## Breadth-first search / Breitensuche
  ## Returns an iterator over the nodes in the order they are visited.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    graph.addEdge(2, 3)
    graph.addEdge(1, 4)
    assert bfs(graph, 1).toSeq in @[[1, 2, 4, 3], [1, 4, 2, 3]]
  var visited = initHashSet[N]()
  var queue = initDeque[N]()
  queue.addLast(start)
  while queue.len > 0:
    let node = queue.popFirst()
    if node in visited:
      continue
    visited.incl(node)
    for neighbor in self.outNeighbors(node) - visited:
      queue.addLast(neighbor)
    yield node


iterator bfsWithDepth*[N](self: Graph[N], start: N): tuple[node: N, depth: int] =
  ## Breadth-first search / Breitensuche
  ## Returns an iterator over the nodes in the order they are visited and their depth.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    graph.addEdge(2, 3)
    graph.addEdge(1, 4)
  var visited = initHashSet[N]()
  var queue = initDeque[tuple[node: N, depth: int]]()
  queue.addLast((start, 0))
  while queue.len > 0:
    let (node, depth) = queue.popFirst()
    if node in visited:
      continue
    visited.incl(node)
    for neighbor in self.outNeighbors(node) - visited:
      queue.addLast((neighbor, depth + 1))
    yield (node, depth)


proc shortestPath*[N](self: Graph[N], start: N, target: N): seq[N] =
  ## Find the shortest path between two nodes.
  ## If no path exists, an empty sequence is returned.
  runnableExamples:
    var graph = initGraph[int]()
    graph.addEdge(1, 2)
    graph.addEdge(2, 3)
    graph.addEdge(1, 4)
    assert graph.shortestPath(1, 3) == @[1, 2, 3]
    assert graph.shortestPath(3, 1) == @[]
  var visited = initHashSet[N]()
  var queue = initDeque[tuple[node: N, path: seq[N]]]()
  queue.addLast((start, @[]))
  while queue.len > 0:
    let (node, path) = queue.popFirst()
    if node in visited:
      continue
    visited.incl(node)
    if node == target:
      return path & @[node]
    for neighbor in self.outNeighbors(node) - visited:
      queue.addLast((neighbor, path & @[node]))
  return @[]
