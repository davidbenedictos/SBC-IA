;***********************
;***** FUNCIONES *******
;***********************

(deffunction question (?question)
    (format t "%s" ?question)
    (bind ?answer (read))
    ?answer
)

(deffunction pregunta-numerica (?pregunta ?rangini ?rangfi)
    (format t "%s" ?pregunta)
    (bind ?respuesta (read))
    (while (not (and(>= ?respuesta ?rangini) (<= ?respuesta ?rangfi))) do
        (format t "%s Ha de ser un valor entre: [%d, %d]: " ?pregunta ?rangini ?rangfi)
        (bind ?respuesta (read))
    )
    ?respuesta
)

(deffunction elementoEnLista (?elemento $?lista)
    (bind ?b (member$ ?elemento ?lista))
    (if (neq ?b FALSE) then (bind ?b TRUE)) 
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
    (slot importanciaPopularidad (type INTEGER))
    (slot importanciaValoracion (type INTEGER))
    (slot momentoFavorito (type INTEGER))
    (multislot puntuacionGenero (type INTEGER))
)

(deffacts generosExistentes
    (generos "Fantasía" "Romance" "Misterio" "CienciaFiccion" "Drama" "Suspense" "Historica" "Poesia")
)

(defrule crear-perfil "preguntas para conocer al usuario"
    (declare (salience 100))
    =>
    (printout t "Introduzca sus datos personales." crlf)

    (bind ?edad (pregunta-numerica "¿Cuál es tu edad? " 0 200))
    (bind ?frecuenciaLectura (pregunta-numerica "¿Cuál es su frecuencia de lectura semanal del 0 al 10?: " 0 10))
    (bind ?tiempoDisponibleLectura (pregunta-numerica "¿Cuánto tiempo de lectura tienes al disponible al dia del 0 al 10?: " 0 10))
    (printout t "" crlf)

    ; Gustos sobre los géneros
    (printout t "Según tu gusto personal, puntúa los siguientes géneros literarios del 0 al 10: " crlf)
    (bind ?puntuacionFantasia (pregunta-numerica "Fantasía: " 0 10))
    (bind ?puntuacionRomance (pregunta-numerica "Romance: " 0 10))
    (bind ?puntuacionMisterio (pregunta-numerica "Misterio: " 0 10))
    (bind ?puntuacionCienciaFiccion (pregunta-numerica "Ciencia ficcion: " 0 10))
    (bind ?puntuacionDrama (pregunta-numerica "Drama: " 0 10))
    (bind ?puntuacionSuspense (pregunta-numerica "Suspense: " 0 10))
    (bind ?puntuacionHistorica (pregunta-numerica "Historica: " 0 10))
    (bind ?puntuacionPoesia (pregunta-numerica "Poesia: " 0 10))

    ; Otros aspectos
    (printout t crlf "Siendo 1 nada y 5 mucho: " crlf)
    (bind ?importanciaPopularidad (pregunta-numerica "¿Cómo de importante es para ti la popularidad de un libro: " 1 5))
    (bind ?importanciaValoracion (pregunta-numerica "¿Cómo de importante es para ti la valoración de los críticos sobre un libro: " 1 5))

    (printout t crlf "¿Cuál es el momento en el que sueles leer?" crlf)
    (printout t "Opción 0: En ratos muertos, como por ejemplo en el transporte público" crlf)
    (printout t "Opción 1: Cuando tienes mucho rato disponible, como por ejemplo en el sofá de casa un domingo " crlf)
    (bind ?momentoFavorito (pregunta-numerica "Opción favorita: " 0 1))

    (assert (User (edad ?edad) (frecuenciaLectura ?frecuenciaLectura) (tiempoDisponibleLectura ?tiempoDisponibleLectura) 
    (importanciaPopularidad ?importanciaPopularidad) (importanciaValoracion ?importanciaValoracion) (momentoFavorito ?momentoFavorito)
        (puntuacionGenero ?puntuacionFantasia ?puntuacionRomance ?puntuacionMisterio ?puntuacionCienciaFiccion ?puntuacionDrama 
            ?puntuacionSuspense ?puntuacionHistorica ?puntuacionPoesia)))

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
    (slot sesionesLectura (type STRING)) ; sesiones de lectura "cortas", sesiones "largas"
    (slot importanciaPopularidad (type STRING)) ; poca, normal, mucha
    (slot importanciaValoracion (type STRING)) ; poca, normal, mucha
    (multislot generosFavoritos (type STRING)) ; segun la puntuacion dada
)

(defrule crear-abstracted-user "abstraemos datos del usuario" 
    (declare (salience 100))
    (User (edad ?edad) (frecuenciaLectura ?frecLectura) (tiempoDisponibleLectura ?tiempoDisp) (momentoFavorito ?momFav) 
        (importanciaPopularidad ?impPop) (importanciaValoracion ?impVal))
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
    (bind ?sesionesLectura (if (eq ?momFav 0) then "cortas"
                                else "largas"))
    (bind ?popularidadAbstracto (if (< ?impPop 3) then "poca"
                                else (if (< ?impPop 4) then "normal"
                                else "mucha")))
    (bind ?valoracionAbstracto (if (< ?impVal 3) then "poca"
                                else (if (< ?impVal 4) then "normal"
                                else "mucha")))
    (assert (AbstractedUser (edad ?edadAbstracta)
                            (frecuenciaLectura ?frecLecturaAbstracta)
                            (tiempoDisponibleLectura ?tiempoDispAbstracto)
                            (sesionesLectura ?sesionesLectura)
                            (importanciaPopularidad ?popularidadAbstracto)
                            (importanciaValoracion ?valoracionAbstracto)))
    ;(printout t "AbstractedUser creado con edad: " ?edadAbstracta 
    ;          ", frecuencia de lectura: " ?frecLecturaAbstracta 
    ;          ", y tiempo disponible: " ?tiempoDispAbstracto crlf)
    ;(focus ASOCIACION)
    
)

(defrule numeros "lista de numeros del 1 al puntuacionGenero.length" 
    (declare (salience 99))
    (User (puntuacionGenero $?puntuacionGenero))
    =>
    (loop-for-count (?i 1 (length$ ?puntuacionGenero)) do
        (assert (num ?i))
    )
)

(defrule añadir-favoritos "abstraemos sus generos favoritos"              
    (declare (salience 98))
    (generos $?g)
    (User (puntuacionGenero $?puntuacionGenero))
    ?max <- (num ?x)
    (forall (num ?y) (test (>= (nth$ ?x ?puntuacionGenero) (nth$ ?y ?puntuacionGenero))))
    ?aUser <-(AbstractedUser (generosFavoritos $?gFav))
    =>
    (if (not (member$ (nth$ ?x ?g) ?gFav)) then ; nomes el posem si no esta a la llista
        ;(bind ?res (modify ?aUser (generosFavoritos $?gFav (nth$ ?x ?g))))
        ;(printout t "Genero favorito añadido: " (nth$ ?x ?g) crlf) ;  
        ;(printout t "Añadido: " ?res crlf)
        (modify ?aUser (generosFavoritos $?gFav (nth$ ?x ?g)))
    )
    
    ;(printout t "Favorito " ?x " puntuacion " (nth$ ?x ?puntuacionGenero) crlf)

    ;(assert (favorito ?x))
)

(defrule siguiente-modulo
    (declare (salience 90))
    =>
    (focus ASOCIACION)
)


; (defrule imprimir-favoritos
;     (declare (salience 97))
;     (AbstractedUser (generosFavoritos $?gFav))
;     =>
;     (loop-for-count (?i 1 (length$ ?gFav)) do
;         (printout t "Genero favorito: " (nth$ ?i ?gFav) crlf)
;     )
; )

;************************
;* MÓDULO DE ASOCIACIÓN *  
;************************

(defmodule ASOCIACION (import ABSTRACCION ?ALL) (export ?ALL))

; (defrule entramos
;     (declare (salience 40))
;     =>    
;     (printout t "Entramos asociacion" crlf)
; )

(deftemplate AbstractedBook
    (multislot generos (type STRING))
    (slot complejidad (type INTEGER) (default -1))
    (slot paginas (type INTEGER) (default -1))
    (slot valorado (default -1))
    (slot popular (default -1)) 
)

(defrule ajustar-por-generos
    (declare (salience 39))
    (AbstractedUser (generosFavoritos $?gFav))
    ;?aBook <- (AbstractedBook (generos $?g))
    =>
    ;(assert ?aBook (generos $?g $?gFav))
    (assert (AbstractedBook (generos ?gFav)))
    (printout t "generos del libro definidos" crlf)
    ;(focus REFINAMIENTO)
)

(defrule ajustar-por-valoracion
    (declare (salience 33))
    (AbstractedUser (importanciaValoracion ?impVal))
    ?ab <- (AbstractedBook (valorado ?v&:(eq ?v -1))) ;todavía no se ha inicializado
    =>
    (if (or (eq ?impVal "normal") (eq ?impVal "mucha")) then (modify ?ab (valorado TRUE))
    else (modify ?ab (valorado FALSE))
    ) 
)

(defrule ajustar-por-popularidad
    (declare (salience 33))
    (AbstractedUser (importanciaPopularidad ?impPop))
    ?ab <- (AbstractedBook (popular ?p&:(eq ?p -1))) ;todavía no se ha inicializado
    =>
    (if (or (eq ?impPop "normal") (eq ?impPop "mucha")) then (modify ?ab (popular TRUE))
    else (modify ?ab (valorado FALSE))
    ) 
)

(defrule ajustar-por-frecuencia
    (declare (salience 33))
    (AbstractedUser (frecuenciaLectura ?frecuencia) (sesionesLectura ?sesiones))
    ?ab <- (AbstractedBook (complejidad ?c&:(eq ?c -1))) ;todavía no se ha inicializado
    =>
    (switch ?frecuencia
        (case "mucha" then 
            (if (eq ?sesiones "largas") then (modify ?ab (complejidad 10))
            else (modify ?ab (complejidad 8))
            ) 
        )
        (case "normal" then 
            (if (eq ?sesiones "largas") then (modify ?ab (complejidad 8))
            else (modify ?ab (complejidad 6))
            ) 
        )
        (case "poca" then 
            (if (eq ?sesiones "largas") then (modify ?ab (complejidad 6))
            else (modify ?ab (complejidad 4))
            ) 
        )
    )
)

; (defrule ajustar-por-frecuencia
;     (declare (salience 32))
;     (AbstractedUser (frecuenciaLectura ?frecuencia) )
;     ?ab <- (AbstractedBook (complejidad ?c&:(eq ?c -1))) ;todavía no se ha inicializado
;     =>
;     (if (eq ?frecuencia "mucha") then (modify ?ab (complejidad 10))
;     else (if (eq ?frecuencia "normal") then (modify ?ab (complejidad 7)))    
;     else (if (eq ?frecuencia "poca") then (modify ?ab (complejidad 5))))
;     (printout t "frecuencia asociada " crlf)    
; )

(defrule ajustar-por-tiempo
    (declare (salience 33))
    (AbstractedUser (tiempoDisponibleLectura ?tiempo) (sesionesLectura ?sesiones))
    ?ab <- (AbstractedBook (paginas ?p&:(eq ?p -1))) ;todavía no se ha inicializado
    =>
    (switch ?tiempo
        (case "mucho" then 
            (if (eq ?sesiones "largas") then (modify ?ab (paginas 2000))
            else (modify ?ab (paginas 1000))
            ) 
        )
        (case "normal" then 
            (if (eq ?sesiones "largas") then (modify ?ab (paginas 650))
            else (modify ?ab (paginas 350))
            ) 
        )
        (case "poco" then 
            (if (eq ?sesiones "largas") then (modify ?ab (paginas 300))
            else (modify ?ab (paginas 200))
            ) 
        )
    )
)

; (defrule ajustar-por-tiempo
;     (declare (salience 31))
;     (AbstractedUser (tiempoDisponibleLectura ?tiempo))
;     ?ab <- (AbstractedBook (paginas ?p&:(eq ?p -1))) ;todavía no se ha inicializado
;     =>
;     (if (eq ?tiempo "mucho") then (modify ?ab (paginas 2000))
;     else (if (eq ?tiempo "normal") then (modify ?ab (paginas 650)))    
;     else (if (eq ?tiempo "poco") then (modify ?ab (paginas 250))))
;     (printout t "tiempo asociada " crlf)
; )

(defrule imprimir-generos
    (declare (salience 20))
    (AbstractedBook (generos $?g))
    =>
    (loop-for-count (?i 1 (length$ ?g)) do
        (printout t "Genero del libro: " (nth$ ?i ?g) crlf)
    )
    (focus REFINAMIENTO)
)


; **************************
; * MÓDULO DE REFINAMIENTO *  
; **************************

(defmodule REFINAMIENTO (import ASOCIACION ?ALL) (export ?ALL))

(deftemplate Recomendaciones
    (multislot titulos-recomendados (type STRING))
)

; (defrule entramos
;     (declare (salience 60))
;     =>    
;     (printout t "Entramos refinamiento" crlf)
; )

; (defrule primera-recomendacion
;     (declare (salience 51))
;    =>
;     (printout t "Entro refinamiento" crlf)
; )

; (defrule eliminar-instancias "elimina las instancias de los libros que no sean del generoRecomendado para el usuario"
;    ?lib <- (object (is-a Libro) (perteneceAGenero ?generoLibro))
;    (AbstractedBook (generos $?generosRecomendados))
;    (test (not (elementoEnLista ?generoLibro ?generosRecomendados)))
;    =>
;    (send ?lib delete)
; )

(defrule primera-recomendacion
   (declare (salience 51))
   (not (Recomendaciones (titulos-recomendados $?recomendados)))
   (AbstractedBook (generos $?generosRecomendados) (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas))
   ?lib <- (object (is-a Libro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas)))
   =>
   ;mirem si genero recomendado esta a la llista de perteneceAGenero
   (if (member$ (send ?lib get-perteneceAGenero) ?generosRecomendados) then ; pot anar a la part esquerra
        ;(printout t "primera_recomendacion " (send ?lib get-titulo) crlf)
        (assert (Recomendaciones (titulos-recomendados (create$ (send ?lib get-titulo)))))
   )
)

(defrule añadir-recomendaciones
   (declare (salience 50))
   ?rec <- (Recomendaciones (titulos-recomendados $?recomendados))
   (test (< (length$ ?recomendados) 3))
   (AbstractedBook (generos $?generosRecomendados) (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas))
   ?lib <- (object (is-a Libro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas)))
   (test (not (elementoEnLista (send ?lib get-titulo) ?recomendados)))
   =>
   ;mirem si genero recomendado esta a la llista de perteneceAGenero
   (if (member$ (send ?lib get-perteneceAGenero) ?generosRecomendados) then ;ho podem ficar a la part esquerra de la regla
        ;(if (not (member$ (send ?lib get-titulo) ?recomendados)) then ; nomes el posem si no esta a la llista
            (modify ?rec (titulos-recomendados $?recomendados (send ?lib get-titulo)))
        ;)
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