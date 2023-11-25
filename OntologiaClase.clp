;;; ---------------------------------------------------------
;;; OntologiaClase.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology OntologiaClase.rdf
;;; :Date 25/11/2023 19:43:43

(defclass Persona
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Autor
    (is-a Persona)
    (role concrete)
    (pattern-match reactive)
    (multislot escribe
        (type INSTANCE)
        (create-accessor read-write))
)

(defclass Usuario
    (is-a Persona)
    (role concrete)
    (pattern-match reactive)
    (multislot leGusta
        (type INSTANCE)
        (create-accessor read-write))
    (multislot topObjectProperty
        (type INSTANCE)
        (create-accessor read-write))
)

(defclass Género
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Libro
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot seClasifica
        (type INSTANCE)
        (create-accessor read-write))
)

(defclass Perfil_de_Lectura
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Recomendación
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Valoración
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(definstances instances
)
