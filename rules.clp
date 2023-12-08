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
   (AbstractedBook (genero ?generoRecomendado))
   ?lib <- (object (is-a Libro))
   =>
   ;(do-for-all-facts ((?r Recomendaciones)) TRUE
   ;   (retract ?r))
   ;mirem si genero recomendado esta a la llista de perteneceAGenero
   (if (member$ ?generoRecomendado (send ?lib get-perteneceAGenero))
      then
      (bind ?recomendaciones-existente (find-all-facts ((?r Recomendaciones)) TRUE))
      ;(printout t "tamaño lista: " (length$ ?recomendaciones-existente) crlf)
      ;si no hi ha recomanacions ho creem, else afegim al final
      (if (eq (length$ ?recomendaciones-existente) 0)
         then
         (assert (Recomendaciones (titulos-recomendados (send ?lib get-titulo))))
         else
         (bind ?recomendacion (nth$ 1 ?recomendaciones-existente))
         ;pillem els titols com a strings enlloc de com a hechos per poder gestionar la llista i afegir
         (bind ?titulos-actuales (fact-slot-value ?recomendacion titulos-recomendados))
         ; nomes el posem si no esta a la llista
         (if (not (member$ (send ?lib get-titulo) ?titulos-actuales))
             then
             (modify ?recomendacion (titulos-recomendados (insert$ ?titulos-actuales (length$ ?titulos-actuales) (send ?lib get-titulo))))
         )
      )
   )
   (focus RESPUESTA)
)

;*************************
;** MÓDULO DE RESPUESTA **  
;*************************

(defmodule RESPUESTA (import REFINAMIENTO ?ALL) (export ?ALL))

(defrule imprimir-respuesta
   (Recomendaciones (titulos-recomendados $?titulos))
   =>
   (if (> (length$ ?titulos) 0)
      then
      (printout t "Te podría gustar: " crlf)
      (foreach ?titulo ?titulos
         (printout t " - " ?titulo crlf))
      else
      (printout t "No hay recomendaciones disponibles." crlf))
)
