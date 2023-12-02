;;;***********************
;;;******** MAIN *********
;;;***********************

(defmodule MAIN (export ?ALL))

(defrule initial
    (initial-fact)
    =>
    (printout t crlf "*** Bienvenidos al recomendador. *** " crlf crlf)
    ;(focus PREGUNTAS)
)

;;;***********************
;;;* MÓDULO DE PREGUNTAS *
;;;***********************

;(defmodule PREGUNTAS (import MAIN ?ALL) (export ?ALL))



