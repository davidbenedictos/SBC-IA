(defrule imprimir-mensaje-si-mayor-de-20
    ?persona <- (object (is-a Persona) (Edad ?e&:(> ?e 20)) (Nombre ?nombre))
    =>
    (printout t "La persona " ?nombre " tiene " ?e " años." crlf)
)
