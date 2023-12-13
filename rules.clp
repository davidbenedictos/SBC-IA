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
    (multislot puntuacionGenero (type INTEGER))
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

    (bind ?puntuacionFantasia (question "Puntuación para el género fantasía del 0 al 10?: "))
    (bind ?puntuacionFantasia (integer ?puntuacionFantasia))
    (if (< ?puntuacionFantasia 0) then (printout t crlf "Puntuación para el género Fantasía incorrecta. " crlf)(exit))
    (if (> ?puntuacionFantasia 10) then (printout t crlf "Puntuación para el género Fantasía incorrecta. " crlf)(exit))

    
    (bind ?puntuacionRomance (question "Puntuación para el género romance del 0 al 10?: "))
    (bind ?puntuacionRomance(integer ?puntuacionRomance))
    (if (< ?puntuacionRomance 0) then (printout t crlf "Puntuación para el género Romance incorrecta. " crlf)(exit))
    (if (> ?puntuacionRomance 10) then (printout t crlf "Puntuación para el género Romance incorrecta. " crlf)(exit))

    (bind ?puntuacionMisterio (question "Puntuación para el género misterio del 0 al 10?: "))
    (bind ?puntuacionMisterio(integer ?puntuacionMisterio))
    (if (< ?puntuacionMisterio 0) then (printout t crlf "Puntuación para el género Misterio incorrecta. " crlf)(exit))
    (if (> ?puntuacionMisterio 10) then (printout t crlf "Puntuación para el género Misterio incorrecta. " crlf)(exit))

    (bind ?puntuacionCienciaFiccion (question "Puntuación para el género ciencia ficción del 0 al 10?: "))
    (bind ?puntuacionCienciaFiccion(integer ?puntuacionRomance))
    (if (< ?puntuacionCienciaFiccion 0) then (printout t crlf "Puntuación para el género CienciaFiccion incorrecta. " crlf)(exit))
    (if (> ?puntuacionCienciaFiccion 10) then (printout t crlf "Puntuación para el género CienciaFiccion incorrecta. " crlf)(exit))

    (bind ?puntuacionDrama (question "Puntuación para el género drama del 0 al 10?: "))
    (bind ?puntuacionDrama (integer ?puntuacionDrama))
    (if (< ?puntuacionDrama 0) then (printout t crlf "Puntuación para el género Drama incorrecta. " crlf)(exit))
    (if (> ?puntuacionDrama 10) then (printout t crlf "Puntuación para el género Drama incorrecta. " crlf)(exit))

    (bind ?puntuacionSuspense (question "Puntuación para el género suspense del 0 al 10?: "))
    (bind ?puntuacionSuspense (integer ?puntuacionSuspense))
    (if (< ?puntuacionSuspense 0) then (printout t crlf "Puntuación para el género Suspense incorrecta. " crlf)(exit))
    (if (> ?puntuacionSuspense 10) then (printout t crlf "Puntuación para el género Suspense incorrecta. " crlf)(exit))
    
    (bind ?puntuacionHistorica (question "Puntuación para el género historica del 0 al 10?: "))
    (bind ?puntuacionHistorica (integer ?puntuacionHistorica))
    (if (< ?puntuacionHistorica 0) then (printout t crlf "Puntuación para el género Historica incorrecta. " crlf)(exit))
    (if (> ?puntuacionHistorica 10) then (printout t crlf "Puntuación para el género Historica incorrecta. " crlf)(exit))

    (bind ?puntuacionPoesia (question "Puntuación para el género poesia del 0 al 10?: "))
    (bind ?puntuacionPoesia (integer ?puntuacionPoesia))
    (if (< ?puntuacionPoesia 0) then (printout t crlf "Puntuación para el género Poesia incorrecta. " crlf)(exit))
    (if (> ?puntuacionPoesia 10) then (printout t crlf "Puntuación para el género Poesia incorrecta. " crlf)(exit))

    
    (assert (User (edad ?edad) (frecuenciaLectura ?frecuenciaLectura) (tiempoDisponibleLectura ?tiempoDisponibleLectura) (puntuacionGenero ?puntuacionFantasia ?puntuacionRomance ?puntuacionMisterio ?puntuacionCienciaFiccion ?puntuacionDrama ?puntuacionSuspense ?puntuacionHistorica ?puntuacionPoesia)))
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
    (multislot generosFavoritos (type STRING)) ; segun la puntuacion dada
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
    
)

;(defrule add-generosFavoritos
 ;   (focus ASOCIACION)
  ;  (User (puntuacionGenero ?puntuacionGenero)
   ; =>
;)

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
    ?ab <- (AbstractedBook)
    =>
    (if (eq ?frecuencia "mucha") then (modify ?ab (complejidad 10))
    else (if (eq ?frecuencia "normal") then (modify ?ab (complejidad 7)))    
    else (if (eq ?frecuencia "poca") then (modify ?ab (complejidad 5))))    
    ;(printout t "frecuencia asociada " ?tiempo crlf)    
)

(defrule ajustar-por-tiempo
    (declare (salience 31))
    (AbstractedUser (tiempoDisponibleLectura ?tiempo))
    ?ab <- (AbstractedBook)
    =>
    (if (eq ?tiempo "mucho") then (modify ?ab (paginas 2000))
    else (if (eq ?tiempo "normal") then (modify ?ab (paginas 2000)))    
    else (if (eq ?tiempo "poco") then (modify ?ab (paginas 2000))))

    ;(printout t "tiempo asociada " ?tiempo crlf)
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

(defrule primera-recomendacion
   (declare (salience 51))
   (not (Recomendaciones (titulos-recomendados $?recomendados)))
   (AbstractedBook (genero ?generoRecomendado) (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas))
   ?lib <- (object (is-a Libro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas)))
   =>
   ;mirem si genero recomendado esta a la llista de perteneceAGenero
   (if (member$ ?generoRecomendado (send ?lib get-perteneceAGenero)) then
        (printout t "primera_recomendacion " (send ?lib get-titulo) crlf)
        (assert (Recomendaciones (titulos-recomendados (create$ (send ?lib get-titulo)))))
   )
)

(defrule añadir-recomendaciones
   (declare (salience 50))
   ?rec <- (Recomendaciones (titulos-recomendados $?recomendados))
   (AbstractedBook (genero ?generoRecomendado) (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas))
   ?lib <- (object (is-a Libro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas)))
   =>
   ;mirem si genero recomendado esta a la llista de perteneceAGenero
   (if (member$ ?generoRecomendado (send ?lib get-perteneceAGenero)) then
        (if (not (member$ (send ?lib get-titulo) ?recomendados)) then ; nomes el posem si no esta a la llista
            (if (< (length$ ?recomendados) 3) then
                (modify ?rec (titulos-recomendados $?recomendados (send ?lib get-titulo)))
                (printout t "EN REFINAMIENTO: recomendacion añadida " (send ?lib get-titulo) crlf)
            ) ;else 
            ;(printout t "EN REFINAMIENTO: LIBRO NO AÑADIDO: " (send ?lib get-titulo) crlf)
        )
   )
)

(defrule no-mas-recomendaciones
   (declare (salience 5))
   =>
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
