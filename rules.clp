;***********************
;***** FUNCIONES *******
;***********************

(deffunction question (?question)
    (format t "%s" ?question)
    (bind ?answer (read))
    ?answer
)

;***********************
;******** MAIN *********
;***********************

(defmodule MAIN (export ?ALL))

(defrule initial
    =>
    (printout t crlf "*** Bienvenidos al recomendador. *** " crlf crlf)
    (focus PREGUNTAS)
)

;***********************
;* MÓDULO DE PREGUNTAS *  
;***********************

(defmodule PREGUNTAS (import MAIN ?ALL) (export ?ALL))

(deftemplate User
    (slot edad (type INTEGER))
    (slot frecuenciaLectura (type INTEGER))
)

(defrule crear-perfil ""
    (declare (salience 100))
    =>
    (printout t "Introduzca sus datos personales." crlf)
    (bind ?edad (question "Introduzca su edad: "))
    (bind ?edad (integer ?edad))
    (if (< ?edad 0) then (printout t crlf "Edad incorrecta. " crlf)(exit))

    (bind ?frecuenciaLectura (question "Cuál es su frecuencia de lectura del 0 al 10?: "))
    (bind ?frecuenciaLectura (integer ?frecuenciaLectura))
    (if (< ?frecuenciaLectura 0) then (printout t crlf "Frecuencia de lectura incorrecta. " crlf)(exit))
    (if (> ?frecuenciaLectura 10) then (printout t crlf "Frecuencia de lectura incorrecta. " crlf)(exit))
    (assert (User (edad ?edad) (frecuenciaLectura ?frecuenciaLectura)))
    (printout t crlf "*** Información personal guardada correctamente. ***" crlf)
    (focus ABSTRACCION)
)

;*************************
;* MÓDULO DE ABSTRACCIÓN *  
;*************************

(defmodule ABSTRACCION (import PREGUNTAS ?ALL) (export ?ALL))

(deftemplate AbstractedUser
    (slot edad (type STRING)) ; Niño, Adolescente, Joven, Adulto, Mayor
    (slot frecuenciaLectura (type STRING)) ; poca, normal, mucha
)

(defrule abstraer-edad
    (User (edad ?edad))
    =>
    (if (< ?edad 12) then (assert (AbstractedUser (edad "niño")))
    else (if (< ?edad 20) then (assert (AbstractedUser (edad "adolescente")))
    else (if (< ?edad 35) then (assert (AbstractedUser (edad "joven")))
    else (if (< ?edad 50) then (assert (AbstractedUser (edad "adulto")))
    else (assert (AbstractedUser (edad "mayor")))))))
    ;(printout t "Edad abstraída" crlf)
    (focus ASOCIACION)
)

(defrule abstraer-frecuenciaLectura
    (User (frecuenciaLectura ?frecuenciaLectura))
    =>
    (if (< ?frecuenciaLectura 4) then (assert (AbstractedUser (frecuenciaLectura "poca")))
    else (if (< ?frecuenciaLectura 7) then (assert (AbstractedUser (frecuenciaLectura "normal")))
    else (if (< ?frecuenciaLectura 11) then (assert (AbstractedUser (edad "mucha"))))))
    ;(printout t "Frecuencia abstraída" crlf)
    (focus ASOCIACION)
)

;************************
;* MÓDULO DE ASOCIACIÓN *  
;************************

(defmodule ASOCIACION (import ABSTRACCION ?ALL) (export ?ALL))

(deftemplate AbstractedBook
    (slot genero (type STRING)) 
)

(defrule asociar-edad
    (AbstractedUser (edad ?edad))
    =>
    (if (eq ?edad "niño") then (assert (AbstractedBook (genero "Ciencia Ficción")))
    else (if (eq ?edad "adolescente") then (assert (AbstractedBook (genero "Fantasía")))
    else (if (eq ?edad "joven") then (assert (AbstractedBook (genero "Romance")))
    else (if (eq ?edad "adulto") then (assert (AbstractedBook (genero "Misterio")))
    else (if (eq ?edad "mayor") then (assert (AbstractedBook (genero "Drama"))))))))
    ;(printout t "Prototipo de libro creado" crlf)
    (focus REFINAMIENTO)
)


;**************************
;* MÓDULO DE REFINAMIENTO *  
;**************************

(defmodule REFINAMIENTO (import ASOCIACION ?ALL) (export ?ALL))

(deftemplate Recomendaciones
    (multislot titulos-recomendados (type STRING))
)

; PARA COMENTAR Ctrl + k + c
; PARA DESCOMENTAR Ctrl + k + u 

(defrule añadir-recomendaciones  
    ;(bind ?libros (find-all-instances (object (is-a Libro)) TRUE)) No funciona, no se perque
    ;?lib <- (object (is-a Libro (perteneceAGenero ?generoLibro&:(eq ?generoRecomendado ?generoLibro)))) No funciona, no se perque

    (AbstractedBook (genero ?generoRecomendado))
    ?lib <- (object (is-a Libro))

    ;?recomend <- (Recomendaciones (titulos-recomendados $?anteriores)) no existeix cap instancia de titulos recomendados, si descomentem no s'executa la implicacio
   =>
   (printout t "Genero recomendado: " ?generoRecomendado crlf)
   (printout t "Genero libro: " (send ?lib get-perteneceAGenero) crlf)
   (if (eq (send ?lib get-perteneceAGenero) ?generoRecomendado) then (printout t "Recomendacion añadida" (send ?lib get-titulo) crlf)) ; mai es compleix pq pertenece a genero es una llista i genero recomendado un string
   ;(printout t "Recomendacion añadida: " ?generoRecomendado crlf)
   
   ;(modify ?recomend (titulos-recomendados (send ?lib get-titulo))) 
   ;(focus RESPUESTA)
)

;*************************
;** MÓDULO DE RESPUESTA **  
;*************************

; (defmodule RESPUESTA (import REFINAMIENTO ?ALL) (export ?ALL))

; (defrule imprimir-respuesta
;     (Recomendaciones (titulos-recomendados ?respuesta))
;     =>
;     (loop-for-count (?i 1 (length$ ?respuesta)) do ;Esto creo que funciona, no lo he probado
;        (bind ?aux (nth$ ?i ?respuesta))
;        (printout t "Te podria gustar: " ?aux crlf)
;     )

;     (printout t "Multislot values: " $?values crlf) ;Nose si funciona
; )

