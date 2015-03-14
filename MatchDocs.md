This is the wiki documentation for the code in "match.lisp": this should be sufficient to program against, but in case of difficulty, see that file in the svn repository.




# match #

Lisp syntax: `(match pattern fact &optional bindings)`

Determines if the fact matches the pattern (using the bindings provided, if any), and returns NIL if not, T or a set of bindings if so.

Arguments:
  * **pattern**: an arbitrary lisp data structure, to be interpreted as documented below
  * **fact**: an arbitrary lisp data structure to be tested against the pattern (hopefully a fact from the working memory)
  * **bindings**: a list suitable for the `assoc` function in common lisp (e.g. `'((=A . B ) (=moviename . "Crash" ))`)

## match pattern syntax ##

So far, largely the same as what was in the original assignment.  Additions:

  * If a pattern looks like `("|" p1 p2 p3)`, it matches against a single atomic fact, and is true if any of the patterns match.
  * The pattern "`*`" matches any fact.

# match-rule #

(Extracted from comments in the file, which may be more up to date)

Lisp syntax: `(match-rule rule working-memory)`

Does a depth-first search through the working memory, searching
for combinations of facts that match the list of patterns given.

Arguments:
  * **rule**: a rule object (see DataStructures)  may match a fact in the WM
  * **working-memory**          : the working memory object (also see DataStructures)

Notes:
  * ~~Both WM and~~ partial-match-list are excellent candidates for refactoring   into structures/objects
  * ~~Have to check to see if T as a parent binding return will cause problems (seems not to, though)~~
  * ~~Still doesn't check closed-list~~