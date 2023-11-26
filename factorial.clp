(defrule factorial
    (limite ?l)
    ?f <- (fact ?x&:(< ?x ?l) ?y)
    =>
    (retract ?f)
    (assert (fact (+ ?x 1) (* ?y (+ ?x 1))))
)

(deffacts hechos
    (fact 1 1)
    (limite 6)
)
