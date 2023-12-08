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
    (slot tiempoDisponibleLectura (type INTEGER))
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

    (bind ?tiempoDisponibleLectura (question "Cuál es su tiempo disponible de lectura del 0 al 10?: "))
    (bind ?tiempoDisponibleLectura (integer ?tiempoDisponibleLectura))
    (if (< ?tiempoDisponibleLectura 0) then (printout t crlf "Tiempo disponible de lectura incorrecto. " crlf)(exit))
    (if (> ?tiempoDisponibleLectura 10) then (printout t crlf "Tiempo disponible de lectura incorrecto. " crlf)(exit))

    (assert (User (edad ?edad) (frecuenciaLectura ?frecuenciaLectura) (tiempoDisponibleLectura ?tiempoDisponibleLectura)))
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
    (slot tiempoDisponibleLectura (type STRING)) ; poco, normal, mucho
)

(defrule crear-abstracted-user
    (declare (salience 100))
    (User (edad ?edad) (frecuenciaLectura ?frecLectura) (tiempoDisponibleLectura ?tiempoDisp))
    =>
    (bind ?edadAbstracta (if (< ?edad 12) then "niño"
                         else (if (< ?edad 20) then "adolescente"
                         else (if (< ?edad 35) then "joven"
                         else (if (< ?edad 50) then "adulto"
                         else "mayor")))))
    (bind ?frecLecturaAbstracta (if (< ?frecLectura 4) then "poca"
                                 else (if (< ?frecLectura 7) then "normal"
                                 else "mucha")))
    (bind ?tiempoDispAbstracto (if (< ?tiempoDisp 4) then "poco"
                                else (if (< ?tiempoDisp 7) then "normal"
                                else "mucho")))
    (assert (AbstractedUser (edad ?edadAbstracta)
                            (frecuenciaLectura ?frecLecturaAbstracta)
                            (tiempoDisponibleLectura ?tiempoDispAbstracto)))
    ;(printout t "AbstractedUser creado con edad: " ?edadAbstracta 
    ;          ", frecuencia de lectura: " ?frecLecturaAbstracta 
    ;          ", y tiempo disponible: " ?tiempoDispAbstracto crlf)
    (focus ASOCIACION)
)

;************************
;* MÓDULO DE ASOCIACIÓN *  
;************************

(defmodule ASOCIACION (import ABSTRACCION ?ALL) (export ?ALL))

(deftemplate AbstractedBook
    (slot genero (type STRING))
    (slot complejidad (type INTEGER))
    (slot paginas (type INTEGER)) 
)

(defrule asociar-edad
    (declare (salience 33))  ;; Alta prioridad
    (AbstractedUser (edad ?edad))
    =>
    (if (eq ?edad "niño") then (assert (AbstractedBook (genero "Ciencia Ficción")))
    else (if (eq ?edad "adolescente") then (assert (AbstractedBook (genero "Fantasía")))
    else (if (eq ?edad "joven") then (assert (AbstractedBook (genero "Romance")))
    else (if (eq ?edad "adulto") then (assert (AbstractedBook (genero "Misterio")))
    else (if (eq ?edad "mayor") then (assert (AbstractedBook (genero "Drama"))))))))
    ;(printout t "Edad asociada " crlf)
)

(defrule ajustar-por-frecuencia
    (declare (salience 32))
    (AbstractedUser (frecuenciaLectura ?frecuencia))
    =>
    (if (eq ?frecuencia "mucha") then
        (do-for-fact ((?b AbstractedBook)) TRUE
           (modify ?b (complejidad 10)))
    else if (eq ?frecuencia "normal") then
        (do-for-fact ((?b AbstractedBook)) TRUE
           (modify ?b (complejidad 7)))
    else if (eq ?frecuencia "poca") then
        (do-for-fact ((?b AbstractedBook)) TRUE
           (modify ?b (complejidad 5)))
    )
    ;(printout t "frecuencia asociada " ?frecuencia crlf)
)

(defrule ajustar-por-tiempo
    (declare (salience 31))
    (AbstractedUser (tiempoDisponibleLectura ?tiempo))
    =>
    (if (eq ?tiempo "mucho") then
        (do-for-fact ((?b AbstractedBook)) TRUE
           (modify ?b (paginas 2000)))
    else if (eq ?tiempo "normal") then
        (do-for-fact ((?b AbstractedBook)) TRUE
           (modify ?b (paginas 500)))
    else if (eq ?tiempo "poco") then
        (do-for-fact ((?b AbstractedBook)) TRUE
           (modify ?b (paginas 200)))
    )
    ;(printout t "tiempo asociada " ?tiempo crlf)
    ;(printout t "vamos a refinamiento " crlf)
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
    (declare (salience 50))
   (AbstractedBook (genero ?generoRecomendado) (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas))
   ?lib <- (object (is-a Libro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas)))
   =>
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
   ;(printout t "vamos a respuesta " crlf)
   ;(focus RESPUESTA)
   (assert (proceso-completado))
)

(defrule vamos-a-respuesta
    (declare (salience 45))
    ;; Verifica si no hay más AbstractedBooks por procesar
    (proceso-completado)
    =>
    ;(printout t "Cambiando al módulo RESPUESTA." crlf)
    (focus RESPUESTA)
)

;*************************
;** MÓDULO DE RESPUESTA **  
;*************************

(defmodule RESPUESTA (import REFINAMIENTO ?ALL) (export ?ALL))

(defrule imprimir-respuesta
   (Recomendaciones (titulos-recomendados $?titulos&:(> (length$ ?titulos) 0)))
   =>
   (printout t "Te podría gustar: " crlf)
   (foreach ?titulo ?titulos
      (printout t " - " ?titulo crlf))
)

(defrule no-hay-recomendaciones
    (not (Recomendaciones (titulos-recomendados $?titulos&:(> (length$ ?titulos) 0))))
    =>
    (printout t "No hay recomendaciones disponibles." crlf)
)
