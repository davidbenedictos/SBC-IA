(deftemplate Persona
    (slot nombre)
    (slot edad)
)

(deffacts gente
    (Persona (nombre "Uri") (edad 5))
    (Persona (nombre "Pau") (edad 25))
    (Persona (nombre "Benson") (edad 60))
)

(defrule recomiendaMayores
    (Persona (nombre ?nom) (edad ?e&:(> ?e 20)))
    => 
    (printout t "Te recomiendo: 'Asi es la puta vida' by Jordi Wild." crlf)
)

(defrule recomiendaMenores
    (Persona (nombre ?nom) (edad ?e&:(> ?e 20)))
    => 
    (printout t "Te recomiendo: 'Los cuentos de Papa Giorgio' by Papa Giorgio." crlf)
)

