; Simple Collaborative Kitting Domain
; Written by Joseph Kim
; 2/16/2017
;
;
; Three actions available = {kit, assemble, inspect}
; Before kitting, object must be inspected
; Before inspecting, object must be assembled


(define (domain simplekit)
  (:requirements :typing :durative-actions :fluents)
  (:types agent object)

  (:predicates  
    (assembled ?o - object)
    (inspected ?o - object)
    (kitted ?o - object)
    (available ?a - agent)
  )

  (:functions
    (assemble_duration ?a - agent)
    (inspect_duration ?a - agent)
    (kit_duration ?a - agent)
    (assemble_ergo ?a - agent)
    (inspect_ergo ?a - agent)
    (kit_ergo ?a - agent)
    (ergonomics)
  )
  

  (:durative-action assemble
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (assemble_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (assembled ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics) (assemble_ergo ?a)))
                    )
  )


  (:durative-action inspect
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (inspect_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (assembled ?o))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (inspected ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics) (inspect_ergo ?a)))
                    )
  )


  (:durative-action kit
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (kit_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (inspected ?o))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (kitted ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics) (kit_ergo ?a)))
                    )
  )


)
