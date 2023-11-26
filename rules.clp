(defrule imprimir-mensaje-si-mayor-de-20
    (object (is-a Persona) (Edad ?e&:(> ?e 20)))
    =>
    (printout t "El usuario con " ?e " años." crlf)
)