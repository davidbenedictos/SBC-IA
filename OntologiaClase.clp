;;; ---------------------------------------------------------
;;; OntologiaClase.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology OntologiaClase.rdf
;;; :Date 25/11/2023 20:13:20

(defclass Persona
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot Edad
        (type INTEGER)
        (create-accessor read-write))
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
    (multislot esFan
        (type INSTANCE)
        (create-accessor read-write))
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
    ([Arturo_Perez_Reverte] of Autor
         (Edad  72)
    )

    ([Belico] of Género
    )

    ([Cyberpunk] of Género
    )

    ([David_Benedicto] of Usuario
         (Edad  21)
    )

    ([Merce_Rodoera] of Autor
         (Edad  74)
    )

    ([Mirall_Trencat] of Libro
    )

    ([Pau_Martinez] of Usuario
         (Edad  20)
    )

    ([Uriol_Roca] of Usuario
         (Edad  19)
    )

    ([Geronimo_Estilton:_En_Narnia] of Libro
    )

)
