(defrule imprimir-mensaje-si-mayor-de-20
    ?usuario <- (Usuario (Edad ?edad&:(> ?edad 20)))
    =>
    (printout t "El usuario con más de 20 años es: " ?usuario " con edad " ?edad crlf)
)
