;; Free-standing test file for the 'match' and 'match-rule' functions.
;; Tests each of a list of sample problems with known output, and
;; compares to make sure they all still work right.

(load "match.lisp")

(defun tap-output (function-tested tests &optional (test-number 1)) 
  (if (null tests) NIL
    (let* (
	   (current (car tests)) 
	   (result (equal 
		    (funcall function-tested (car current) (cadr current)) 
		    (caddr current)))
	   )
      (or (format T "~[not ok~;ok~] ~d ~s~%" 
		  (if result 1 0) 
		  test-number 
		  (let ((formatted (format NIL "~61a" current)))
		    (subseq formatted 0 60)))
	  (tap-output function-tested (cdr tests) (1+ test-number)))
      )
   )
)

(format T "~%testing 'match'~%")
(tap-output #'match '(
  ( a a T)
  ( a b NIL)  ; basic false
  ( a 42 NIL) ; number-string equality test
  ( 42 42 T) ; numeric equality test
  ( 42 a NIL) ; string-number equality test
  ((a b =c (& =d >c))  (a b c c)  NIL)
  ((a b =c (& =d !c))  (a b c d)  ((=C . C) (=D . D)))
  ( (a b =c (& =d <c))  (a b c d) NIL)
  ( (a b =c ("|" =c <c))  (a b c c) ((=C . C)))
  ( (a b =c ("|" =c <c))  (a b c b) ((=C . C)))
  ( (a b =c ("|" =c <c))  (a b c d) NIL )
  ( (elephants (sally (color =c) (size =s) (mood =m)) (rose (color =c) (size <s) (mood !m))) 
    (elephants (sally (color red) (size 12) (mood chipper)) (rose (color red) (size 10) (mood weird))) 
    ((=C . RED) (=S . 12) (=M . CHIPPER))
  )
  ( (elephants (sally (color =c) (size =s) (mood =m)) (rose (color =c) (size <s) (mood !m))) 
   (elephants (sally (color red) (size 12) (mood chipper)) (rose color red) (size 10) (mood weird)) 
   NIL
  )
  ( (elephant (color =c) (size =s)) (elephant (color grey) (size 12)) ((=C . GREY) (=S . 12))  )
  (  (=a (& b !a)) (42 b) ((=A . 42))) ; just a simple multiple-match test
  (  (=a (& b >a)) (42 b) NIL ) ; must not blow up
  (  (=a (& b <a)) (42 b) NIL ) ; must not blow up
  (  (=a (& b >a =b b)) (a b) ((=A . A) (=B . B)) ) ; slightly more complicated
  (  (=a (& b <a =b b)) (a b) NIL ) ; an obvious failure case
  (  (a =b *) (a c e) ( (=B . C)))  ; wildcard test	      
  (  (a * !b) (a c e) NIL )  ; wildcard test (negative)	      
)
	    
)

(defvar test-wm NIL)
(setf test-wm
  '(
    (movie "Quantum of Solace" (action 1) (comedy 0))
    (movie "The Fellowship of the Ring" (action 0) (comedy 0))
    (movie "The Court Jester" (action 0) (comedy 1))
    (movie "Sabrina" (action 0) (comedy 0))
    (director "The Fellowship of the Ring" "Jackson, Peter")
    (director "The Court Jester" "Somebody Other than Peter Jackson")
    (actor "The Fellowship of the Ring" "Wood, Elijah")
    (actor "The Fellowship of the Ring" "Tyler, Liv")
    (actor "The Court Jester" "Kaye, Danny")
    (actor "The Court Jester" "Rathbone, Basil")
    (actor "The Court Jester" "Lansbury, Angela")
    (actor "Quantum of Solace" "Craig, Daniel")
    )
)

(defvar fancy-wm NIL)
(setf fancy-wm (make-instance 'expert-wm :facts
  '(
    (movie
     (movie "Quantum of Solace" (action 1) (comedy 0))
     (movie "The Fellowship of the Ring" (action 0) (comedy 0))
     (movie "The Court Jester" (action 0) (comedy 1))
     (movie "Sabrina" (action 0) (comedy 0))
     )
    (director
     (director "The Fellowship of the Ring" "Jackson, Peter")
     (director "The Court Jester" "Somebody Other than Peter Jackson")
     )
    (actor
     (actor "The Fellowship of the Ring" "Wood, Elijah")
     (actor "The Fellowship of the Ring" "Tyler, Liv")
     (actor "The Court Jester" "Kaye, Danny")
     (actor "The Court Jester" "Rathbone, Basil")
     (actor "The Court Jester" "Lansbury, Angela")
     (actor "Quantum of Solace" "Craig, Daniel")
     )
   )
))
			      

(defvar find-peter-jackson NIL)
(setf find-peter-jackson 
      (make-instance 'rule :pattern-list
'(
  (movie =mname (action =a) (comedy =c))
  (director =mname =dirname)
 ))
)
(defvar find-bond-21 NIL)
(setf find-bond-21       
      (make-instance 'rule 
       :pattern-list  '((movie =mname (action 1) (comedy 0)))
))
(defvar find-bond-and-jackson NIL)
(setf find-bond-and-jackson 
      (make-instance 'rule :pattern-list
      '(    
	(movie "Quantum of Solace" (action 1) (comedy 0)) 
	(director =mname =dirname)
	)
      )
)
(format T "~%testing 'match-rule'~%")
(tap-output 
 #'match-rule 
 (
  list
  (list find-peter-jackson test-wm '(((=MNAME . "The Fellowship of the Ring") (=A . 0) (=C . 0)
  (=DIRNAME . "Jackson, Peter"))
 ((MOVIE "The Fellowship of the Ring" (ACTION 0) (COMEDY 0))
  (DIRECTOR "The Fellowship of the Ring" "Jackson, Peter")))
	)
  (list find-bond-21 test-wm '(((=MNAME . "Quantum of Solace"))
 ((MOVIE "Quantum of Solace" (ACTION 1) (COMEDY 0)))))
  (list find-bond-and-jackson test-wm '(((=MNAME . "The Fellowship of the Ring") (=DIRNAME . "Jackson, Peter"))
 ((MOVIE "Quantum of Solace" (ACTION 1) (COMEDY 0))
  (DIRECTOR "The Fellowship of the Ring" "Jackson, Peter"))))
  (list find-peter-jackson fancy-wm '(((=MNAME . "The Fellowship of the Ring") (=A . 0) (=C . 0)
  (=DIRNAME . "Jackson, Peter"))
 ((MOVIE "The Fellowship of the Ring" (ACTION 0) (COMEDY 0))
  (DIRECTOR "The Fellowship of the Ring" "Jackson, Peter")))
	)
  (list find-bond-21 fancy-wm '(((=MNAME . "Quantum of Solace"))
 ((MOVIE "Quantum of Solace" (ACTION 1) (COMEDY 0)))))
  (list find-bond-and-jackson fancy-wm '(((=MNAME . "The Fellowship of the Ring") (=DIRNAME . "Jackson, Peter"))
 ((MOVIE "Quantum of Solace" (ACTION 1) (COMEDY 0))
  (DIRECTOR "The Fellowship of the Ring" "Jackson, Peter"))))
  (list find-bond-and-jackson fancy-wm 
	'(((=MNAME . "The Court Jester") (=DIRNAME .  "Somebody Other than Peter Jackson"))
	  ((MOVIE "Quantum of Solace" (ACTION 1) (COMEDY 0))
	   (DIRECTOR "The Court Jester" "Somebody Other than Peter Jackson")
	   )
	  )
)


))