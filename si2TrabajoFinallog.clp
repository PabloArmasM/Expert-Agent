(deffacts datos
        (nodosBeneficios)
        (fase calculo)
        (solucion A)
)

(deftemplate nodoCandidato
        (slot nombre
                (type SYMBOL))
        (slot coste
                (type INTEGER))
        )

(deftemplate nodo
	(slot nombre
		(type SYMBOL))
        (slot produccion
                (type INTEGER))
        (slot grado
                (type INTEGER))
        (slot vueltaAtras
                (type INTEGER))
        (slot tipoNodo
                (type INTEGER)) ;; 0 -- nodo normal, 1 -- nodo interseccion
)


(deftemplate camino
	(slot id
		(type INTEGER))
        (slot coste
                (type INTEGER))
	(multislot nodos
		(type SYMBOL))
        (slot vueltaAtras
                (type INTEGER))
)

(deffacts nodos
        (nodo
                (nombre A)
                (produccion 5)
                (grado 1)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre B)
                (produccion 5)
                (grado 1)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre C)
                (produccion 5)
                (grado 1)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre D)
                (produccion 5)
                (grado 1)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre E)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre F)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre G)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre H)
                (produccion 5)
                (grado 1)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre I)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre J)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre K)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre L)
                (produccion 5)
                (grado 2)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo
                (nombre M)
                (produccion 5)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 0)
        )(nodo 
                (nombre intA)
                (produccion 0)
                (grado 4)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intB)
                (produccion 0)
                (grado 4)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intC)
                (produccion 0)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intD)
                (produccion 0)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intE)
                (produccion 0)
                (grado 4)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intF)
                (produccion 0)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intG)
                (produccion 0)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intH)
                (produccion 0)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 1)
        )(nodo 
                (nombre intI)
                (produccion 0)
                (grado 3)
                (vueltaAtras 0)
                (tipoNodo 1)
        )
)

(deffacts caminos
        (camino
                (id 1)
                (coste 2)
                (nodos A intA)
                (vueltaAtras 0)
        )(camino 
                (id 2)
                (coste 3)
                (nodos intA B)
                (vueltaAtras 0)
        )(camino 
                (id 3)
                (coste 4)
                (nodos intA intB)
                (vueltaAtras 0)
        )(camino 
                (id 4)
                (coste 3)
                (nodos intA L)
                (vueltaAtras 0)
        )(camino 
                (id 5)
                (coste 3)
                (nodos intB C)
                (vueltaAtras 0)
        )(camino 
                (id 6)
                (coste 3)
                (nodos intB intI)
                (vueltaAtras 0)
        )(camino 
                (id 7)
                (coste 3)
                (nodos intB intC)
                (vueltaAtras 0)
        )(camino 
                (id 8)
                (coste 3)
                (nodos intC D)
                (vueltaAtras 0)
        )(camino 
                (id 9)
                (coste 3)
                (nodos intC intD)
                (vueltaAtras 0)
        )(camino 
                (id 10)
                (coste 3)
                (nodos intD E)
                (vueltaAtras 0)
        )(camino 
                (id 11)
                (coste 3)
                (nodos E intE)
                (vueltaAtras 0)
        )(camino 
                (id 12)
                (coste 3)
                (nodos intE intI)
                (vueltaAtras 0)
        )(camino 
                (id 13)
                (coste 3)
                (nodos intI intH)
                (vueltaAtras 0)
        )(camino 
                (id 14)
                (coste 3)
                (nodos intH L)
                (vueltaAtras 0)
        )(camino 
                (id 15)
                (coste 3)
                (nodos intE F)
                (vueltaAtras 0)
        )(camino 
                (id 16)
                (coste 3)
                (nodos intE M)
                (vueltaAtras 0)
        )(camino 
                (id 17)
                (coste 3)
                (nodos intF M)
                (vueltaAtras 0)
        )(camino 
                (id 18)
                (coste 3)
                (nodos intF G)
                (vueltaAtras 0)
        )(camino 
                (id 19)
                (coste 3)
                (nodos intG G)
                (vueltaAtras 0)
        )(camino 
                (id 20)
                (coste 3)
                (nodos intG H)
                (vueltaAtras 0)
        )(camino 
                (id 21)
                (coste 3)
                (nodos I intG)
                (vueltaAtras 0)
        )(camino 
                (id 22)
                (coste 3)
                (nodos I J)
                (vueltaAtras 0)
        )(camino 
                (id 23)
                (coste 3)
                (nodos J K)
                (vueltaAtras 0)
        )(camino 
                (id 24)
                (coste 3)
                (nodos K intH)
                (vueltaAtras 0)
        )(camino 
                (id 25)
                (coste 3)
                (nodos intD M)
                (vueltaAtras 0)
        )(camino 
                (id 26)
                (coste 3)
                (nodos intF F)
        )
)
















