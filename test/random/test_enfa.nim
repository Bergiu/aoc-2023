import ../../lib/enfa
import intsets
import tables
import options

proc testNewENFA() =
  let enfa = newENFA()
  assert enfa.states == [0].toIntSet;
  assert enfa.transitions == initTable[int, Table[Option[char], IntSet]]();
  assert enfa.start == 0;
  assert enfa.accept == initIntSet();

proc testGet() =
  var enfa = newENFA()
  enfa.states = [0, 1, 2].toIntSet;
  enfa.transitions = {
    0: {some('a'): [1].toIntSet, some('b'): [2].toIntSet}.toTable,
    1: {some('a'): [1,2].toIntSet, some('b'): [2].toIntSet}.toTable,
    2: {some('a'): [1].toIntSet, some('b'): [2].toIntSet}.toTable,
  }.toTable
  assert enfa[0, some('a')] == [1].toIntSet
  assert enfa[0, some('b')] == [2].toIntSet
  assert enfa[1, some('a')] == [1,2].toIntSet
  assert enfa[1, some('b')] == [2].toIntSet
  assert enfa[2, some('a')] == [1].toIntSet
  assert enfa[2, some('b')] == [2].toIntSet

proc testAddTransition1() =
  var enfa = newENFA()
  enfa.addTransition(0, 'a', 1)
  assert enfa.transitions[0][some('a')] == [1].toIntSet
  enfa.addTransition(0, 'a', 2)
  assert enfa.transitions[0][some('a')] == [1, 2].toIntSet
  enfa.addTransition(0, 'b', 3)
  assert enfa.transitions[0][some('b')] == [3].toIntSet
  enfa.addTransition(0, 'b', 0)
  assert enfa.transitions[0][some('b')] == [0, 3].toIntSet

proc testAddTransition2() =
  var enfa = newENFA()
  enfa.addTransition(0, 4)
  assert enfa.transitions[0][none(char)] == [4].toIntSet
  enfa.addTransition(0, 5)
  assert enfa.transitions[0][none(char)] == [4, 5].toIntSet
  enfa.addTransition(0, 0)
  assert enfa.transitions[0][none(char)] == [0, 4, 5].toIntSet

proc testAddTransition3() =
  var enfa = newENFA()
  enfa.addTransition(0, some('a'), 1)
  assert enfa.transitions[0][some('a')] == [1].toIntSet
  enfa.addTransition(0, some('a'), 2)
  assert enfa.transitions[0][some('a')] == [1, 2].toIntSet
  enfa.addTransition(0, some('b'), 3)
  assert enfa.transitions[0][some('b')] == [3].toIntSet
  enfa.addTransition(0, some('b'), 0)
  assert enfa.transitions[0][some('b')] == [0, 3].toIntSet
  enfa.addTransition(0, none(char), 4)
  assert enfa.transitions[0][none(char)] == [4].toIntSet
  enfa.addTransition(0, none(char), 5)
  assert enfa.transitions[0][none(char)] == [4, 5].toIntSet
  enfa.addTransition(0, none(char), 0)
  assert enfa.transitions[0][none(char)] == [0, 4, 5].toIntSet

proc testEpsilonHull() =
  var enfa = newENFA()
  enfa.addStates @[0, 1, 2, 3, 4, 5, 6, 7]
  enfa.addTransition(0, 1)
  enfa.addTransition(0, 'a', 2)
  enfa.addTransition(0, 3)
  enfa.addTransition(1, 4)
  enfa.addTransition(1, 5)
  enfa.addTransition(2, 6)
  enfa.addTransition(2, 7)
  enfa.addTransition(3, 0)
  assert enfa.epsilonHull(0) == [0, 1, 3, 4, 5].toIntSet
  assert enfa.epsilonHull(1) == [1, 4, 5].toIntSet
  assert enfa.epsilonHull(2) == [2, 6, 7].toIntSet
  assert enfa.epsilonHull(@[0]) == [0, 1, 3, 4, 5].toIntSet
  assert enfa.epsilonHull(@[1]) == [1, 4, 5].toIntSet
  assert enfa.epsilonHull(@[1,2]) == [1, 2, 4, 5, 6, 7].toIntSet
  assert enfa.epsilonHull([0].toIntSet) == [0, 1, 3, 4, 5].toIntSet
  assert enfa.epsilonHull([1].toIntSet) == [1, 4, 5].toIntSet
  assert enfa.epsilonHull([1,2].toIntSet) == [1, 2, 4, 5, 6, 7].toIntSet

proc testDeltaDach1() =
  var enfa = newENFA()
  enfa.addStates @[0, 1, 2]
  enfa.addTransition(0, 'a', 0)
  enfa.addTransition(0, 1)
  enfa.addTransition(1, 'b', 1)
  enfa.addTransition(1, 2)
  enfa.addTransition(2, 'c', 2)
  enfa.accept.incl 2
  assert enfa.deltaDach(0, some('a')) == [0, 1, 2].toIntSet
  assert enfa.deltaDach(0, some('b')) == [1, 2].toIntSet
  assert enfa.deltaDach(0, some('c')) == [2].toIntSet
  assert enfa.deltaDach(1, some('a')) == [].toIntSet
  assert enfa.deltaDach(1, some('b')) == [1, 2].toIntSet
  assert enfa.deltaDach(1, some('c')) == [2].toIntSet
  assert enfa.deltaDach(2, some('a')) == [].toIntSet
  assert enfa.deltaDach(2, some('b')) == [].toIntSet
  assert enfa.deltaDach(2, some('c')) == [2].toIntSet

proc testDeltaDach2() =
  var enfa = newENFA()
  enfa.addStates @[0, 1, 2]
  enfa.addTransition(0, 'a', 0)
  enfa.addTransition(0, 1)
  enfa.addTransition(1, 'b', 1)
  enfa.addTransition(1, 2)
  enfa.addTransition(2, 'c', 2)
  enfa.accept.incl 2
  assert enfa.deltaDach([0].toIntSet, some('a')) == [0, 1, 2].toIntSet
  assert enfa.deltaDach([0].toIntSet, some('b')) == [1, 2].toIntSet
  assert enfa.deltaDach([0].toIntSet, some('c')) == [2].toIntSet
  assert enfa.deltaDach([1].toIntSet, some('a')) == [].toIntSet
  assert enfa.deltaDach([1].toIntSet, some('b')) == [1, 2].toIntSet
  assert enfa.deltaDach([1].toIntSet, some('c')) == [2].toIntSet
  assert enfa.deltaDach([2].toIntSet, some('a')) == [].toIntSet
  assert enfa.deltaDach([2].toIntSet, some('b')) == [].toIntSet
  assert enfa.deltaDach([2].toIntSet, some('c')) == [2].toIntSet
  assert enfa.deltaDach([2, 1].toIntSet, some('a')) == [].toIntSet
  assert enfa.deltaDach([2, 1].toIntSet, some('b')) == [1, 2].toIntSet
  assert enfa.deltaDach([2, 1].toIntSet, some('c')) == [2].toIntSet
  assert enfa.deltaDach([2, 1, 0].toIntSet, some('a')) == [0, 1, 2].toIntSet

proc testDeltaDach3() =
  var enfa = newENFA()
  enfa.addStates @[0, 1, 2]
  enfa.addTransition(0, 'a', 0)
  enfa.addTransition(0, 1)
  enfa.addTransition(1, 'b', 1)
  enfa.addTransition(1, 2)
  enfa.addTransition(2, 'c', 2)
  enfa.accept.incl 2
  assert enfa.deltaDach(0, "") == [0, 1, 2].toIntSet
  assert enfa.deltaDach(0, "a") == [0, 1, 2].toIntSet
  assert enfa.deltaDach(0, "b") == [1, 2].toIntSet
  assert enfa.deltaDach(0, "c") == [2].toIntSet
  assert enfa.deltaDach(0, "ab") == [1, 2].toIntSet
  assert enfa.deltaDach(0, "bc") == [2].toIntSet
  assert enfa.deltaDach(0, "ac") == [2].toIntSet
  assert enfa.deltaDach(0, "abc") == [2].toIntSet
  assert enfa.deltaDach(1, "") == [1, 2].toIntSet
  assert enfa.deltaDach(1, "a") == [].toIntSet
  assert enfa.deltaDach(1, "b") == [1, 2].toIntSet
  assert enfa.deltaDach(1, "c") == [2].toIntSet
  assert enfa.deltaDach(1, "ab") == [].toIntSet
  assert enfa.deltaDach(1, "bc") == [2].toIntSet
  assert enfa.deltaDach(1, "ac") == [].toIntSet
  assert enfa.deltaDach(1, "abc") == [].toIntSet
  assert enfa.deltaDach(2, "") == [2].toIntSet
  assert enfa.deltaDach(2, "a") == [].toIntSet
  assert enfa.deltaDach(2, "b") == [].toIntSet
  assert enfa.deltaDach(2, "c") == [2].toIntSet
  assert enfa.deltaDach(2, "ab") == [].toIntSet
  assert enfa.deltaDach(2, "bc") == [].toIntSet
  assert enfa.deltaDach(2, "ac") == [].toIntSet
  assert enfa.deltaDach(2, "abc") == [].toIntSet

proc testAccepts() =
  var enfa = newENFA()
  enfa.addStates @[0, 1, 2]
  enfa.addTransition(0, 'a', 0)
  enfa.addTransition(0, 1)
  enfa.addTransition(1, 'b', 1)
  enfa.addTransition(1, 2)
  enfa.addTransition(2, 'c', 2)
  enfa.accept.incl 2
  assert enfa.accepts("") == true
  assert enfa.accepts("a") == true
  assert enfa.accepts("b") == true
  assert enfa.accepts("c") == true
  assert enfa.accepts("ab") == true
  assert enfa.accepts("bc") == true
  assert enfa.accepts("ac") == true
  assert enfa.accepts("abc") == true
  assert enfa.accepts("aba") == false
  assert enfa.accepts("abb") == true
  assert enfa.accepts("abbc") == true
  assert enfa.accepts("abcc") == true
  assert enfa.accepts("abca") == false
  assert enfa.accepts("abcb") == false
  assert enfa.accepts("abcc") == true
  assert enfa.accepts("aabbcc") == true


testNewENFA()
testGet()
testAddTransition1()
testAddTransition2()
testAddTransition3()
testEpsilonHull()
testDeltaDach1()
testDeltaDach2()
testDeltaDach3()
testAccepts()
