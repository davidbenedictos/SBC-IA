;;; ---------------------------------------------------------
;;; /users/David/Desktop/sbc/SBC-IA/OntologiaLibros.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology /users/David/Desktop/sbc/SBC-IA/OntologiaLibros.ttl
;;; :Date 17/12/2023 16:50:10

(defclass Persona
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot nombre
        (type STRING)
        (create-accessor read-write))
)

(defclass Autor
    (is-a Persona)
    (role concrete)
    (pattern-match reactive)
)

(defclass Usuario
    (is-a Persona)
    (role concrete)
    (pattern-match reactive)
    (multislot tienePreferenciasDeGenero
        (type INSTANCE)
        (create-accessor read-write))
    (slot confianzaValoraciones
        (type INTEGER)
        (create-accessor read-write))
    (slot frecuenciaLectura
        (type INTEGER)
        (create-accessor read-write))
    (slot influenciaModasLiterarias
        (type INTEGER)
        (create-accessor read-write))
    (multislot lugaresLectura
        (type STRING)
        (create-accessor read-write))
    (slot momentoFavoritoLectura
        (type STRING)
        (create-accessor read-write))
    (slot preferenciaBestSellers
        (type INTEGER)
        (create-accessor read-write))
    (multislot preferenciaGeneros
        (type STRING)
        (create-accessor read-write))
    (slot tiempoDisponibleLectura
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Genero
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot tieneLibrosPopulares
        (type INSTANCE)
        (create-accessor read-write))
    (slot nombreGenero
        (type STRING)
        (create-accessor read-write))
)

(defclass Libro
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot escritoPor
        (type INSTANCE)
        (create-accessor read-write))
    (multislot perteneceAGenero
        (type INSTANCE)
        (create-accessor read-write))
    (slot autor
        (type STRING)
        (create-accessor read-write))
    (slot complejidad
        (type INTEGER)
        (create-accessor read-write))
    (slot fecha
        (type SYMBOL)
        (create-accessor read-write))
    (slot genero
        (type STRING)
        (create-accessor read-write))
    (slot idioma
        (type STRING)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
    (slot paginas
        (type INTEGER)
        (create-accessor read-write))
    (slot popularidad
        (type INTEGER)
        (create-accessor read-write))
    (slot titulo
        (type STRING)
        (create-accessor read-write))
    (slot valoracion
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Recomendacion
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot recomiendaLibro
        (type INSTANCE)
        (create-accessor read-write))
    (multislot listaLibrosRecomendados
        (type STRING)
        (create-accessor read-write))
    (multislot razonesRecomendacion
        (type STRING)
        (create-accessor read-write))
)

(definstances instances
    ([CienciaFiccion] of Genero
         (nombreGenero  "CienciaFiccion")
    )

    ([Drama] of Genero
         (nombreGenero  "Drama")
    )

    ([Fantasia] of Genero
         (nombreGenero  "Fantasia")
    )

    ([Historica] of Genero
         (nombreGenero  "Historica")
    )

    ([Misterio] of Genero
         (nombreGenero  "Misterio")
    )

    ([Romance] of Genero
         (nombreGenero  "Romance")
    )

    ([Suspense] of Genero
         (nombreGenero  "Suspense")
    )

)
