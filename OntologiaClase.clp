;;; ---------------------------------------------------------
;;; OntologiaClase.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology OntologiaClase.rdf
;;; :Date 02/12/2023 20:21:28

(defclass Persona
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot Edad
        (type INTEGER)
        (create-accessor read-write))
    (multislot Nombre
        (type STRING)
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
         (Nombre  "David_Benedicto")
    )

    ([Merce_Rodoera] of Autor
         (Edad  74)
    )

    ([Mirall_Trencat] of Libro
    )

    ([Pau_Martinez] of Usuario
         (Edad  20)
         (Nombre  "Pau_Martinez")
    )

    ([Uriol_Roca] of Usuario
         (Edad  19)
         (Nombre  "Uriol_Roca")
    )

    ([Geronimo_Estilton:_En_Narnia] of Libro
    )

)
