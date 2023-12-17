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
    (slot justificacionRespuesta (type INTEGER))
)

(deffacts generosExistentes
    (generos "Fantasia" "Romance" "Misterio" "CienciaFiccion" "Drama" "Suspense" "Historica")
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
    ;(bind ?puntuacionPoesia (pregunta-numerica "Poesia: " 0 10))

    ; Otros aspectos
    (printout t crlf "Siendo 1 nada y 5 mucho: " crlf)
    (bind ?importanciaPopularidad (pregunta-numerica "¿Cómo de importante es para ti la popularidad de un libro: " 1 5))
    (bind ?importanciaValoracion (pregunta-numerica "¿Cómo de importante es para ti la valoración de los críticos sobre un libro: " 1 5))

    (printout t crlf "¿Cuál es el momento en el que sueles leer?" crlf)
    (printout t "Opción 0: En ratos muertos, como por ejemplo en el transporte público" crlf)
    (printout t "Opción 1: Cuando tienes mucho rato disponible, como por ejemplo en el sofá de casa un domingo " crlf)
    (bind ?momentoFavorito (pregunta-numerica "Opción favorita: " 0 1))

    (printout t crlf "¿Te gustaría ver el porqué de tu recomendación?: " crlf)
    (printout t "Opción 0: NO" crlf)
    (printout t "Opción 1: SI" crlf)
    (bind ?justificacionRespuesta (pregunta-numerica "Opción favorita: " 0 1))
   
    (assert (User (edad ?edad) (frecuenciaLectura ?frecuenciaLectura) (tiempoDisponibleLectura ?tiempoDisponibleLectura) 
    (importanciaPopularidad ?importanciaPopularidad) (importanciaValoracion ?importanciaValoracion) (momentoFavorito ?momentoFavorito)
        (puntuacionGenero ?puntuacionFantasia ?puntuacionRomance ?puntuacionMisterio ?puntuacionCienciaFiccion ?puntuacionDrama 
            ?puntuacionSuspense ?puntuacionHistorica) (justificacionRespuesta ?justificacionRespuesta))); ?puntuacionPoesia)))

    (printout t crlf "*** Información personal guardada correctamente. ***" crlf crlf)
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
    (slot justificacionRespuesta (type INTEGER)); 1-> Si, 0->No
)

(defrule crear-abstracted-user "abstraemos datos del usuario" 
    (declare (salience 100))
    (User (edad ?edad) (frecuenciaLectura ?frecLectura) (tiempoDisponibleLectura ?tiempoDisp) (momentoFavorito ?momFav) 
        (importanciaPopularidad ?impPop) (importanciaValoracion ?impVal) (justificacionRespuesta ?justRes))
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
                            (importanciaValoracion ?valoracionAbstracto)
                            (justificacionRespuesta ?justRes)))
    (if (eq ?justRes 1) 
        then
        (printout t "Información abstraida del usuario: " crlf)                        
        (printout t "Edad abstraida: " ?edadAbstracta crlf)   
        (printout t "Frecuencia de lectura abstraida: " ?frecLecturaAbstracta crlf)   
        (printout t "Tiempo de lectura disponible abstraido: " ?tiempoDispAbstracto crlf)
        (printout t "Sesion de lectura abstraida: " ?sesionesLectura crlf)     
        (printout t "Importancia por la popularidad abstraida: " ?popularidadAbstracto crlf) 
        (printout t "Importancia por las valoraciones abstraida: " ?valoracionAbstracto crlf crlf)      
    )                           
)

(defrule numeros "lista de umeros del 1 al puntuacionGenero.length" 
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
    (if (not (member$ (nth$ ?x ?g) ?gFav)) then
        (modify ?aUser (generosFavoritos $?gFav (nth$ ?x ?g)))
        (printout t "Genero favorito abstraido: " (nth$ ?x ?g) crlf)  
    )
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

(deftemplate AbstractedBook
    (multislot generos (type STRING))
    (slot complejidad (type INTEGER) (default -1))
    (slot paginas (type INTEGER) (default -1))
    (slot valorado (type INTEGER) (default -1))
    (slot popular (type INTEGER) (default -1))
)

(defrule ajustar-por-generos
    (declare (salience 39))
    (AbstractedUser (generosFavoritos $?gFav))
    =>
    (assert (AbstractedBook (generos ?gFav)))
)

(defrule ajustar-por-valoracion
    (declare (salience 33))
    (AbstractedUser (importanciaValoracion ?impVal) (justificacionRespuesta ?justRes))
    ?ab <- (AbstractedBook (valorado ?v&:(eq ?v -1))) ;todavía no se ha inicializado
    =>
    (switch ?impVal
        (case "mucha" then 
            (if (eq ?justRes 1) then (printout t crlf "Como importancia valoracion: " ?impVal ", valoración mínima para usuario: " 9 crlf))
            then (modify ?ab (valorado 9))   
        )
        (case "normal" then 
            (if (eq ?justRes 1) then (printout t crlf "Como importancia valoracion: " ?impVal ", valoración mínima para usuario: " 5 crlf))
             then (modify ?ab (valorado 5))  
        )
        (case "poca" then 
            (if (eq ?justRes 1) then (printout t crlf "Como importancia valoracion: " ?impVal ", valoración mínima para usuario: " 0 crlf))
            then (modify ?ab (valorado 0))   
        )
    )
    
)

(defrule ajustar-por-popularidad
    (declare (salience 33))
    (AbstractedUser (importanciaPopularidad ?impPop) (justificacionRespuesta ?justRes))
    ?ab <- (AbstractedBook (popular ?p&:(eq ?p -1))) ;todavía no se ha inicializado
    =>
    (switch ?impPop
        (case "mucha" then 
            (if (eq ?justRes 1) then (printout t "Como importancia popularidad: " ?impPop ", popularidad mínima para usuario: " 9 crlf))
            then (modify ?ab (popular 9))   
        )
        (case "normal" then 
            (if (eq ?justRes 1) then (printout t "Como importancia popularidad: " ?impPop ", popularidad mínima para usuario: " 5 crlf))
             then (modify ?ab (popular 5))  
        )
        (case "poca" then 
            (if (eq ?justRes 1) then (printout t "Como importancia popularidad: " ?impPop ", popularidad mínima para usuario: " 0 crlf))
            then (modify ?ab (popular 0))   
        )
    )
)

(defrule ajustar-por-frecuencia
    (declare (salience 33))
    (AbstractedUser (frecuenciaLectura ?frecuencia) (sesionesLectura ?sesiones) (justificacionRespuesta ?justRes))
    ?ab <- (AbstractedBook (complejidad ?c&:(eq ?c -1))) ;todavía no se ha inicializado
    =>
    (switch ?frecuencia
        (case "mucha" then 
            (if (eq ?sesiones "largas") 
                then 
                (if (eq ?justRes 1) then (printout t "Como frecuencia: " ?frecuencia " y sesiones: " ?sesiones ", complejidad máxima para usuario: 10" crlf))
                (modify ?ab (complejidad 10))    
            else 
                (if (eq ?justRes 1) then (printout t "Como frecuencia: " ?frecuencia " y sesiones: " ?sesiones ", complejidad máxima para usuario: 8" crlf))
                (modify ?ab (complejidad 8))
            ) 
        )
        (case "normal" then 
            (if (eq ?sesiones "largas") 
                then 
                (if (eq ?justRes 1) then (printout t "Como frecuencia: " ?frecuencia " y sesiones: " ?sesiones ", complejidad máxima para usuario: 8" crlf))
                (modify ?ab (complejidad 8))
            else 
                (if (eq ?justRes 1) then (printout t "Como frecuencia: " ?frecuencia " y sesiones: " ?sesiones ", complejidad máxima para usuario: 6" crlf))
                (modify ?ab (complejidad 6))
            ) 
        )
        (case "poca" then 
            (if (eq ?sesiones "largas") 
                then 
                (if (eq ?justRes 1) then (printout t "Como frecuencia: " ?frecuencia " y sesiones: " ?sesiones ", complejidad máxima para usuario: 6" crlf))
                (modify ?ab (complejidad 6))
            else 
                (if (eq ?justRes 1) then (printout t "Como frecuencia: " ?frecuencia " y sesiones: " ?sesiones ", complejidad máxima para usuario: 4" crlf))
                (modify ?ab (complejidad 4))
            ) 
        )
    )
)

(defrule ajustar-por-tiempo
    (declare (salience 31))
    (AbstractedUser (tiempoDisponibleLectura ?tiempo) (sesionesLectura ?sesiones) (justificacionRespuesta ?justRes))
    ?ab <- (AbstractedBook (paginas ?p&:(eq ?p -1))) ;todavía no se ha inicializado
    =>
    (switch ?tiempo
        (case "mucho" then 
            (if (eq ?sesiones "largas") 
                then 
                (if (eq ?justRes 1) then (printout t "Como tiempo: " ?tiempo " y sesiones: " ?sesiones ", páginas máximas para usuario: 2000" crlf))
                (modify ?ab (paginas 2000))
            else 
                (if (eq ?justRes 1) then (printout t "Como tiempo: " ?tiempo " y sesiones: " ?sesiones ", páginas máximas para usuario: 1000" crlf))
                (modify ?ab (paginas 1000))
            ) 
        )
        (case "normal" then 
            (if (eq ?sesiones "largas") 
                then 
                (if (eq ?justRes 1) then (printout t "Como tiempo: " ?tiempo " y sesiones: " ?sesiones ", páginas máximas para usuario: 650" crlf))
                (modify ?ab (paginas 650))
            else 
                (if (eq ?justRes 1) then (printout t "Como tiempo: " ?tiempo " y sesiones: " ?sesiones ", páginas máximas para usuario: 350" crlf))
                (modify ?ab (paginas 350))
            ) 
        )
        (case "poco" then 
            (if (eq ?sesiones "largas") 
                then 
                (if (eq ?justRes 1) then (printout t "Como tiempo: " ?tiempo " y sesiones: " ?sesiones ", páginas máximas para usuario: 300" crlf))
                (modify ?ab (paginas 300))
            else 
                (if (eq ?justRes 1) then (printout t "Como tiempo: " ?tiempo " y sesiones: " ?sesiones ", páginas máximas para usuario: 200" crlf))
                (modify ?ab (paginas 200))
            ) 
        )
    )
    (focus REFINAMIENTO)
)

; (defrule imprimir-generos
;     (declare (salience 20))
;     (AbstractedBook (generos $?g))
;     =>
;     (loop-for-count (?i 1 (length$ ?g)) do
;         (printout t "Genero del libro: " (nth$ ?i ?g) crlf)
;     )
;     (focus REFINAMIENTO)
; )


; **************************
; * MÓDULO DE REFINAMIENTO *  
; **************************

(defmodule REFINAMIENTO (import ASOCIACION ?ALL) (export ?ALL))

(deftemplate Recomendaciones
    (multislot titulos-recomendados (type STRING))
)

(defrule eliminar-instancias "Recomendaremos libros de los generos recomendados para el usuario"
    (declare (salience 52))
    (AbstractedBook (generos $?generosRecomendados))
    ?lib <- (object (is-a Libro) (perteneceAGenero ?generoLibro&:(not (elementoEnLista ?generoLibro ?generosRecomendados))))
    =>
    (send ?lib delete)
)

(defrule primera-recomendacion
    (declare (salience 51))
    (not (Recomendaciones (titulos-recomendados $?recomendados)))
    (AbstractedUser (justificacionRespuesta ?justRes))
    (AbstractedBook (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas)
     (popular ?popularidadImportancia) (valorado ?valoracionImportancia))
    ?lib <- (object (is-a Libro) (titulo ?nombreLibro) (escritoPor ?autor) (perteneceAGenero ?generoLibro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas))
     (popularidad ?popularidad&:(>= ?popularidad ?popularidadImportancia)) (valoracion ?valoracion&:(>= ?valoracion ?valoracionImportancia)))
    =>
    (if (eq ?justRes 1) then (printout t crlf "Recomendación añadida por coincidir con características del usuario. Titulo: " ?nombreLibro ", Genero: " ?generoLibro ", Autor: " ?autor ", Popularidad: "?popularidad ", Valoracion: " ?valoracion ", Complejidad: " ?complejidad ", Num pags: " ?pags crlf))
    (assert (Recomendaciones (titulos-recomendados (create$ ?nombreLibro))))
    (send ?lib delete)
)

(defrule añadir-recomendaciones
    (declare (salience 50))
    ?rec <- (Recomendaciones (titulos-recomendados $?recomendados&:(< (length$ ?recomendados) 3)))
    (AbstractedUser (justificacionRespuesta ?justRes))
    (AbstractedBook (complejidad ?complejidadRecomendada) (paginas ?pagsRecomendadas)
        (popular ?popularidadImportancia) (valorado ?valoracionImportancia))
    ?lib <- (object (is-a Libro) (titulo ?nombreLibro) (escritoPor ?autor) (perteneceAGenero ?generoLibro) (complejidad ?complejidad&:(<= ?complejidad ?complejidadRecomendada)) (paginas ?pags&:(<= ?pags ?pagsRecomendadas))
        (popularidad ?popularidad&:(>= ?popularidad ?popularidadImportancia)) (valoracion ?valoracion&:(>= ?valoracion ?valoracionImportancia)))
    =>
    (if (eq ?justRes 1) then (printout t "Recomendación añadida por coincidir con características del usuario. Titulo: " ?nombreLibro ", Genero: " ?generoLibro ", Autor: " ?autor ", Popularidad: "?popularidad ", Valoracion: " ?valoracion ", Complejidad: " ?complejidad ", Num pags: " ?pags crlf))
    (modify ?rec (titulos-recomendados $?recomendados ?nombreLibro))
    (send ?lib delete)
)

(defrule primera-no-recomendacion "si no hay libros que cumplan las condiciones, recomendaremos los 3 libros mas populares"
    (declare (salience 40))
    (not (Recomendaciones (titulos-recomendados $?recomendados)))
    (AbstractedUser (justificacionRespuesta ?justRes))
    ?lib <- (object (is-a Libro) (titulo ?nombreLibro) (escritoPor ?autor) (perteneceAGenero ?generoLibro) (popularidad ?popularidadLibro))
    (forall (object (is-a Libro) (popularidad ?popularidad2)) (test (<= ?popularidad2 ?popularidadLibro))) 
    =>
    (assert (Recomendaciones (titulos-recomendados (create$ ?nombreLibro))))
    (if (eq ?justRes 1) then (printout t crlf "Recomendación añadida por pertenecer a uno de sus géneros favoritos y ser popular, titulo: " ?nombreLibro ", Genero: " ?generoLibro ", Autor: " ?autor ", Popularidad: "?popularidadLibro crlf))
    (send ?lib delete)
)

(defrule añadir-no-recomendacion "Si no hay más libros que cumplan las condiciones, recomendaremos los mas populares"
    (declare (salience 39))
    ?rec <- (Recomendaciones (titulos-recomendados $?recomendados&:(< (length$ ?recomendados) 3)))
    (AbstractedUser (justificacionRespuesta ?justRes))
    ?lib <- (object (is-a Libro) (titulo ?nombreLibro) (escritoPor ?autor) (perteneceAGenero ?generoLibro)(popularidad ?popularidadLibro))
    (forall (object (is-a Libro) (popularidad ?popularidad2)) (test (<= ?popularidad2 ?popularidadLibro))) 
    =>
    (modify ?rec (titulos-recomendados $?recomendados ?nombreLibro))
    (if (eq ?justRes 1) then (printout t  "Recomendación añadida por pertenecer a uno de sus géneros favoritos y ser popular, titulo: " ?nombreLibro ", Genero: " ?generoLibro ", Autor: " ?autor ", Popularidad: "?popularidadLibro crlf))
    (send ?lib delete)
)

(defrule no-mas-recomendaciones
    (declare (salience 30))
    =>
    (focus RESPUESTA)
)

;*************************
;** MÓDULO DE RESPUESTA **  
;*************************

(defmodule RESPUESTA (import REFINAMIENTO ?ALL) (export ?ALL))

(defrule imprimir-respuesta
    (Recomendaciones (titulos-recomendados $?titulos))
    =>
    (printout t crlf crlf "Te podría gustar: " crlf)
    (foreach ?titulo ?titulos
        (printout t " - " ?titulo crlf))
)

(defrule no-hay-recomendaciones
    (not (Recomendaciones (titulos-recomendados $?titulos&:(> (length$ ?titulos) 0))))
    =>
    (printout t "No hay recomendaciones disponibles." crlf)
)