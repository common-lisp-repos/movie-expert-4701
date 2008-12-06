;;;; Created on 2008-12-05 00:51:12

(defvar test-recommend-rule)
(setf test-recommend-rule
      '(

;; %%%%%%%%%%%%%%%%%%  RECOMMEND-MOVIE  %%%%%%%%%%%%%%%%%%

	;; Add initial (recommend-movie ...) object for each movie
	(
	 ((movie =n * =r * * * * * * * * * * * * * * * * * * * *)
	  )
	 
	 ((ADD (recommend-movie =n =r)))
	 
	 1
	 
	 NIL
	)

;; %%%%%%%%%%%%%%%%%%%%%%%  ACTION  %%%%%%%%%%%%%%%%%%%%%%%

	;; Add initial (user-likes-action ...) object
	(
	 ((user-likes-movie =n)
	  (movie =n * * (action 1) * * * * * * * * * * * * * * * * * * *)
	  )
	 
	 ((ADD (user-likes-action 0)))
	 
	 -1
	 
	 T
	)
	;; Increment (user-likes-action ...) object
	(
	 ((user-likes-movie =n)
	  (movie =n * * (action 1) * * * * * * * * * * * * * * * * * * *)
	  (user-likes-action =w))
	 
	 ((REMOVE 3)
	  (ADD (user-likes-action (+ =w 1))))
	 
	 2
	 
	 NIL
	)

	;; Increment  (recommend-movie ...) object for each action if user likes action

	(
	 ((user-likes-action =w)
	  (movie =n * * (action 1) * * * * * * * * * * * * * * * * * * *)
	  (recommend-movie =n =r)
	  )
	 
	 ((REMOVE 3)
	  (ADD (recommend-movie =n (+ (* 10 =w) =r)))
	 )
	 
	 2
	 
	 NIL
	)

;; %%%%%%%%%%%%%%%%%%%%%%%  COMEDY  %%%%%%%%%%%%%%%%%%%%%%%

	;; Add initial (user-likes-comedy ...) object
	(
	 ((user-likes-movie =n)
	  (movie =n * * * * * * (comedy 1) * * * * * * * * * * * * * * *)
	  )
	 
	 ((ADD (user-likes-comedy 0)))
	 
	 -1
	 
	 T
	)
	;; Increment (user-likes-comedy ...) object
	(
	 ((user-likes-movie =n)
	  (movie =n * * * * * * (comedy 1) * * * * * * * * * * * * * * *)
	  (user-likes-comedy =w))
	 
	 ((REMOVE 3)
	  (ADD (user-likes-comedy (+ =w 1))))
	 
	 2
	 
	 NIL
	)

	;; Increment  (recommend-movie ...) object for each comedy if user likes comedy

	(
	 ((user-likes-comedy =w)
	  (movie =n * * * * * * (comedy 1) * * * * * * * * * * * * * * *)
	  (recommend-movie =n =r)
	  )
	 
	 ((REMOVE 3)
	  (ADD (recommend-movie =n (+ (* 10 =w) =r)))
	 )
	 
	 2
	 
	 NIL
	)
       )
)

(defvar new-actor-rule)
(defvar update-actor-rule)
(setf new-actor-rule 
      (make-instance 'rule 
       :pattern-list '(
		       (user-likes-movie =moviename) 
		       (actor  =actorname =moviename * *)
		      ) 
       :action-list '((ADD (user-likes-actor =actorname 0)))
       :close-on-bindings '(=actorname)
       :exhaustible T
       )
)
(setf update-actor-rule 
      (make-instance 'rule 
       :pattern-list '((user-likes-movie =moviename) 
		       (actor  =actorname =moviename * *) 
		       (user-likes-actor =actorname =w))
       :action-list '((ADD (user-likes-actor =actorname (+ =w 1)))
		      (REMOVE 3))
       :match-length 2
       ; This is true if and only if the rule above is exhausted first
       ;:exhaustible T 

       )
)


(defvar new-director-rule)
(defvar update-director-rule)
(setf new-director-rule 
      (make-instance 'rule 
       :pattern-list '(
		       (user-likes-movie =moviename) 
		       (director  =directorname =moviename)
		      ) 
       :action-list '((ADD (user-likes-director =directorname 0)))
       :close-on-bindings '(=directorname)
       :exhaustible T
       )
)
(setf update-director-rule 
      (make-instance 'rule 
       :pattern-list '((user-likes-movie =moviename) 
		       (director  =directorname =moviename) 
		       (user-likes-director =directorname =w))
       :action-list '((ADD (user-likes-director =directorname (+ =w 1)))
		      (REMOVE 3))
       :match-length 2
       ; This is *also* true if and only if the rule above is exhausted first
       ;:exhaustible T 
       )
)

(defvar filter-actors)
(setf filter-actors
  (make-instance 'rule
   :pattern-list '((user-likes-actor * <cutoff))
   :action-list '((REMOVE 1))
   ; cute trick to avoid saving references to dead objects?  Or just stupid?
   ;:match-length 0
   :pre-bindings '((=CUTOFF . 3))
  )
)

(defvar new-era-rule)
(defvar update-era-rule)
;;;;; Note: era bounds are exclusive, not inclusive (startdate of 2000
;;;;; means movies from 2001 on)
(setf new-era-rule 
      (make-instance 'rule 
       :pattern-list '(
	 (user-likes-movie =moviename) 
	 (movie-era  =era-name =startdate =enddate) 
	 (movie =moviename (& >startdate <enddate)
	  * * * * * * * * * * * * * * * * * * * * *)
       ) 
       :action-list '((ADD (user-likes-era =era-name 0)))
       :close-on-bindings '(=era-name)
       :exhaustible T
       )
)
(setf update-era-rule 
      (make-instance 'rule 
       :pattern-list 
       '(
	 (user-likes-movie =moviename) 
	 (movie-era  =era-name =startdate =enddate) 
	 (movie =moviename (&  >startdate  <enddate)
	  * * * * * * * * * * * * * * * * * * * * *)
	 (user-likes-era =era-name =w)
        )
       :action-list '((ADD (user-likes-era =era-name (+ =w 1)))
		      (REMOVE 4))
       :match-length 3
       ; This is *also* true if and only if the rule above is exhausted first
       ;:exhaustible T 
       )
)

(defvar new-actor-rule)
(defvar update-actor-rule)
(setf new-actor-rule 
      (make-instance 'rule 
       :pattern-list '(
		       (user-likes-movie =moviename) 
		       (actor  =actorname =moviename * *)
		      ) 
       :action-list '((ADD (user-likes-actor =actorname 0)))
       :close-on-bindings '(=actorname)
       :exhaustible T
       )
)
(setf update-actor-rule 
      (make-instance 'rule 
       :pattern-list '((user-likes-movie =moviename) 
		       (actor  =actorname =moviename * *) 
		       (user-likes-actor =actorname =w))
       :action-list '((ADD (user-likes-actor =actorname (+ =w 1)))
		      (REMOVE 3))
       :match-length 2
       ; This is true if and only if the rule above is exhausted first
       ;:exhaustible T 

       )
)


(defvar new-director-rule)
(defvar update-director-rule)
(setf new-director-rule 
      (make-instance 'rule 
       :pattern-list '(
		       (user-likes-movie =moviename) 
		       (director  =directorname =moviename)
		      ) 
       :action-list '((ADD (user-likes-director =directorname 0)))
       :close-on-bindings '(=directorname)
       :exhaustible T
       )
)
(setf update-director-rule 
      (make-instance 'rule 
       :pattern-list '((user-likes-movie =moviename) 
		       (director  =directorname =moviename) 
		       (user-likes-director =directorname =w))
       :action-list '((ADD (user-likes-director =directorname (+ =w 1)))
		      (REMOVE 3))
       :match-length 2
       ; This is *also* true if and only if the rule above is exhausted first
       ;:exhaustible T 
       )
)

(defvar filter-actors)
(setf filter-actors
  (make-instance 'rule
   :pattern-list '((user-likes-actor * <cutoff))
   :action-list '((REMOVE 1))
   ; cute trick to avoid saving references to dead objects?  Or just stupid?
   ;:match-length 0
   :pre-bindings '((=CUTOFF . 3))
  )
)

(defvar new-era-rule)
(defvar update-era-rule)
;;;;; Note: era bounds are exclusive, not inclusive (startdate of 2000
;;;;; means movies from 2001 on)
(setf new-era-rule 
      (make-instance 'rule 
       :pattern-list '(
	 (user-likes-movie =moviename) 
	 (movie-era  =era-name =startdate =enddate) 
	 (movie =moviename (& >startdate <enddate)
	  * * * * * * * * * * * * * * * * * * * * *)
       ) 
       :action-list '((ADD (user-likes-era =era-name 0)))
       :close-on-bindings '(=era-name)
       :exhaustible T
       )
)
(setf update-era-rule 
      (make-instance 'rule 
       :pattern-list 
       '(
	 (user-likes-movie =moviename) 
	 (movie-era  =era-name =startdate =enddate) 
	 (movie =moviename (&  >startdate  <enddate)
	  * * * * * * * * * * * * * * * * * * * * *)
	 (user-likes-era =era-name =w)
        )
       :action-list '((ADD (user-likes-era =era-name (+ =w 1)))
		      (REMOVE 4))
       :match-length 3
       ; This is *also* true if and only if the rule above is exhausted first
       ;:exhaustible T 
       )
)

;TRY:

;(defvar rules-object (initialize test-recommend-rule))

;(wmadd '(USER-LIKES-MOVIE "Forrest\ Gump\ \(1994\)") knowledge-base)
;(wmadd '(USER-LIKES-MOVIE "Monty\ Python\ and\ the\ Holy\ Grail\ \(1975\)") knowledge-base)
;(wmadd '(USER-LIKES-MOVIE "City\ Lights\ \(1931\)") knowledge-base)
;(wmadd '(USER-LIKES-MOVIE "Matrix\,\ The\ \(1999\)") knowledge-base)

;(candidate-list knowledge-base 'RECOMMEND-MOVIE)

;(engine rules-object knowledge-base)

;OR

;(interpreter test-recommend-rule knowledge-base)
