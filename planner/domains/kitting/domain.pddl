; Collaborative Kitting Domain
; Written by Joseph Kim
; 8/29/2016
;
; NOTE: You can update the ergonomic values for each activities


(define (domain kitting)
  (:requirements :typing :durative-actions :fluents)
  (:types agent object container)

  (:predicates  
    (retrieved ?o - object)
    (available ?a - agent)
    (assembled_base ?o - object)
    (assembled_top ?o - object)
    (stocked ?o - object)
    (gotContainer ?c - container)
    (paddedContainer ?c - container)
    (kitted ?o - object ?c - container)
  )


  (:functions
    (retrieve_duration ?a - agent)
    (assemble_base_duration ?a - agent)
    (assemble_top_duration ?a - agent)
    (stock_duration ?a - agent)
    (get_container_duration ?a - agent)
    (pad_container_duration ?a - agent)
    (kitting_duration ?a - agent)
    (ergonomics ?a - agent)
  )
  


  (:durative-action RetrieveParts
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (retrieve_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (retrieved ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 1))
                    )
  )


  (:durative-action Assemble_Base
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (assemble_base_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (retrieved ?o))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (assembled_base ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 4.5))
                    )
  )


  (:durative-action Assemble_Top
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (assemble_top_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (assembled_base ?o))
                    (at start (retrieved ?o))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (assembled_top ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 4.5))
                    )
  )


  (:durative-action Stock
    :parameters     (?a - agent ?o - object)
    :duration       (= ?duration (stock_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (assembled_top ?o))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (stocked ?o))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 0))
                    )
  )


  (:durative-action GetContainer
    :parameters     (?a - agent ?c - container)
    :duration       (= ?duration (get_container_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    )
    :effect         (and 
                    (at start (not (available ?a)))
                    (at end (gotContainer ?c))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 2))
                    )
  )

  (:durative-action PadContainer
    :parameters     (?a - agent ?c - container)
    :duration       (= ?duration (pad_container_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (gotContainer ?c))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (paddedContainer ?c))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 1))
                    )
  )


  (:durative-action Kit
    :parameters     (?a - agent ?o - object ?c - container)
    :duration       (= ?duration (kitting_duration ?a))
    :condition      (and
                    (at start (available ?a))
                    (at start (paddedContainer ?c))
                    (at start (stocked ?o))
                    )
    :effect         (and  
                    (at start (not (available ?a)))
                    (at end (kitted ?o ?c))
                    (at end (available ?a))
                    (at end (increase (ergonomics ?a) 0.5))
                    )
  )


)
