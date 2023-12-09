import sequtils
import tables
import intsets
import sets
import options


type ENFA* = object
  ## epsilon NFA with multiple accept states
  states*: IntSet
  transitions*: Table[int, Table[Option[char], IntSet]]
  start*: int
  accept*: IntSet

proc newENFA*(): ENFA =
  ## creates a new empty ENFA with start state 0 and no accept states
  result = ENFA(
    states: toIntSet([0]),
    transitions: initTable[int, Table[Option[char], IntSet]](),
    start: 0,
    accept: initIntSet()
  )

proc `[]`*(self: ENFA, state: int, ch: Option[char]): IntSet =
  ## returns the set of states reachable from state with character ch
  return self.transitions.getOrDefault(state).getOrDefault(ch)

proc addState*(self: var ENFA, state: int) =
  ## adds a state to the ENFA
  self.states.incl state

proc addStates*(self: var ENFA, states: IntSet) =
  ## adds states to the ENFA
  self.states = self.states + states

proc addStates*(self: var ENFA, states: seq[int]) =
  ## adds states to the ENFA
  self.states = self.states + toIntSet(states)

proc addTransition*(self: var ENFA, fr: int, ch: Option[char], to: int) =
  ## adds a transition from fr to to with character ch
  # add missing states
  # if not self.states.contains(fr):
  #   self.states.incl fr
  # if not self.states.contains(to):
  #   self.states.incl to
  # add transition
  if not self.transitions.hasKey(fr):
    self.transitions[fr] = {ch: toIntSet([to])}.toTable
  elif not self.transitions[fr].hasKey(ch):
    self.transitions[fr][ch] = toIntSet([to])
  else:
    self.transitions[fr][ch].incl to

proc addTransition*(self: var ENFA, fr: int, ch: char, to: int) =
  ## adds a transition from fr to to with character ch
  self.addTransition(fr, some(ch), to)

proc addTransition*(self: var ENFA, fr: int, to: int) =
  ## adds an epsilon transition from fr to to
  self.addTransition(fr, none(char), to)

proc epsilonHull*(self: ENFA, state: int): IntSet =
  ## returns the epsilon hull of state
  if not self.states.contains(state):
    return initIntSet()
  var stack = toSeq([state])
  while stack.len > 0:
    var s = stack.pop
    result.incl s
    var esilonTransitions = self.transitions.getOrDefault(s).getOrDefault(none(char))
    for t in esilonTransitions:
      if not result.contains(t):
        stack.add t
  result

proc epsilonHull*(self: ENFA, states: IntSet): IntSet =
  ## returns the epsilon hull of states
  for s in states:
    result = result + self.epsilonHull(s)

proc epsilonHull*(self: ENFA, states: seq[int]): IntSet =
  ## returns the epsilon hull of states
  for s in states:
    result = result + self.epsilonHull(s)

proc deltaDach*(self: ENFA, state: int, ch: Option[char]): IntSet =
  ## returns the set of states reachable from state with character ch
  if ch.isNone():
    return self.epsilonHull(state)
  var tmp = initIntSet()
  for s in self.epsilonHull(state):
    tmp = tmp + self[s, ch]
  result = self.epsilonHull(tmp)

proc deltaDach*(self: ENFA, states: IntSet, ch: Option[char]): IntSet =
  ## returns the set of states reachable from states with character ch
  for s in states:
    result = result + self.deltaDach(s, ch)

proc deltaDach*(self: ENFA, state: int, word: string): IntSet =
  ## returns the set of states reachable from state with word
  result = self.epsilonHull(state)
  for c in word:
    result = self.deltaDach(result, some(c))

proc createENFA*(validWords: HashSet[string]): ENFA =
  result = newENFA()
  for word in validWords:
    var lastState = 0
    for c in word:
      var state = result.states.len
      result.states.incl state
      result.addTransition(lastState, some(c), state)
      lastState = state
    result.accept.incl lastState

proc createOneAcceptingStateENFA*(validWords: HashSet[string]): ENFA =
  result = newENFA()
  var acc = result.states.len
  result.states.incl acc
  result.accept.incl acc
  for word in validWords:
    var lastState = 0
    for c in word:
      var state = result.states.len
      result.states.incl state
      result.addTransition(lastState, some(c), state)
      lastState = state
    result.addTransition(lastState, none(char), acc)

proc accepts*(self: ENFA, word: string): bool =
  ## returns true if the enfa accepts the word
  return self.accept.intersection(self.deltaDach(self.start, word)).len > 0
