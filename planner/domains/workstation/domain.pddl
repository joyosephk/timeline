; Human-robot workstation kitting
; -PDDL Domain file
; -Written by Joseph Kim

(define (domain workstation)
(:requirements :typing :durative-actions :fluents)
(:types location block agent)

(:predicates  

  (at ?a - agent ?x - location)
  (on ?b - block ?x - location)
  (holding ?b - block ?a - agent)
  (available ?a - agent)
  (inspectLocation ?x - location)
  (inspected ?b - block)
  (kitLocation ?x - location)
  (kitted ?b - block)
  (grasp_free ?a - agent)

)

(:functions   

  (distance ?x ?y - location)
  (speed ?a - agent)
  (time_grasp ?a - agent)
  (time_kit ?a - agent)
  (time_inspect ?a - agent)
  (ergonomics ?a - agent)

)
  

(:durative-action goto
:parameters     (?a - agent ?x ?y - location)
:duration       (= ?duration (/ (distance ?x ?y) (speed ?a)))
:condition      (and (at start (at ?a ?x)))
:effect   (and  (at start (not (at ?a ?x)))
                (at end (at ?a ?y))

                ; INCREASE ERGONOMICS PROPORTIONAL TO DISTANCE
                (at end (increase (ergonomics ?a) 
                                  (/ (distance ?x ?y) 10) 
                        )
                )
          )
)


(:durative-action pickup
:parameters     (?a - agent ?b - block ?x - location) 
:duration       (= ?duration (time_grasp ?a))
:condition (and (at start (at ?a ?x))
                (over all (at ?a ?x))
                (at start (available ?a))
                (at start (on ?b ?x))
                (at start (grasp_free ?a))
            )

:effect (and (at start (not (on ?b ?x)))
             (at start (holding ?b ?a))
             (at start (not (available ?a)))
             (at end (available ?a))
             (at end (not (grasp_free ?a)))
        )
)


(:durative-action putdown
:parameters     (?a - agent ?b - block ?x - location)
:duration       (= ?duration (time_grasp ?a))
:condition (and
                (over all (at ?a ?x))
                (at start (holding ?b ?a))
                (at start (available ?a))
           )
            
:effect (and    (at end (not (holding ?b ?a)))
                (at start (not (available ?a)))
                (at end (available ?a))
                (at end (on ?b ?x))
                (at end (grasp_free ?a))
        )
)


(:durative-action inspect
:parameters     (?a - agent ?b - block ?x - location)
:duration       (= ?duration (time_inspect ?a))
:condition      (and
                (at start (inspectLocation ?x)) 
                (at start (at ?a ?x))
                (over all (at ?a ?x))
                (at start (on ?b ?x))
                (at start (available ?a))
                )
:effect         (and  
                (at end (inspected ?b))
                (at start (not (available ?a)))
                (at end (available ?a))

                ; INCREASE ERGONOMICS (flat amount)
                (at end (increase (ergonomics ?a) 
                                  1
                        )
                )

                )
)


(:durative-action kit
:parameters     (?a - agent ?b - block ?x - location)
:duration       (= ?duration (time_kit ?a))
:condition      (and
                (at start (kitLocation ?x)) 
                (at start (at ?a ?x))
                (over all (at ?a ?x))
                (at start (on ?b ?x))
                (at start (available ?a))
                (at start (inspected ?b))
                )
:effect         (and
                (at start (not (available ?a)))
                (at end (available ?a))
                (at end (kitted ?b))

                ; INCREASE ERGONOMICS (flat amount)
                (at end (increase (ergonomics ?a) 
                                  2
                        )
                )
                )
)
)


