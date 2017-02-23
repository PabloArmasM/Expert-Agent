;;;; PARA LA VUELTA AL PASADO, UNA VEZ QUE SE FINALICE (SOLO GENERE CICLOS), CREAR UNA LISTA CON LOS NODOS QUE SE PUEDEN VISITAR Y SE DEBEN VISITAR, 
;;;SI ALGUNO DE ESTOS NO ESTAN, ENTONCES TENEMOS QUE IR HASTA EL NODO QUE SE PUEDA VOLVER A MOVER PAR LLEGAR A ESTE.

(deffunction interseccion (?a ?b) 
   (bind ?r (create$)) 
   (foreach ?e ?a 
        (if (and (member$ ?e ?b) (not (member$ ?e ?r))) 
             then (bind ?r (create$ ?r ?e)))) 
 (return ?r))


;;;Calculo de los nodos que aportan beneficios


(defrule caculoBeneficioA
        (declare (salience 1000))
        (fase calculo)
        (camino (id ?id)(coste ?coste)(nodos ?nodoActual ?nodoSig)(vueltaAtras 0))
        (nodo (nombre ?nodoActual) (produccion ?X&:(> (- ?X ?coste) 0)) (grado ?y)(vueltaAtras ?c) (tipoNodo ?i))
        =>
        (assert (nodoCB ?nodoActual))
)

(defrule caculoBeneficioB
        (declare (salience 1000))
        (fase calculo)
        ?f<-(nodosBeneficios $?a)
        (camino (id ?id)(coste ?coste)(nodos ?nodoSig ?nodoActual)(vueltaAtras 0))
        (nodo (nombre ?nodoActual) (produccion ?X&:(> (- ?X ?coste) 0)) (grado ?y)(vueltaAtras ?c) (tipoNodo ?i))
        =>
        (assert (nodoCB ?nodoActual))
)

;; Eliminamos los repetidos ;;
(defrule finCalculoBeneficio
        (declare (salience -1))
        ?f<-(fase calculo)
        =>
       (retract ?f)
       (assert (fase creacionVector))
)

(defrule crearVectorBeneficio
        (declare (salience 950))
        (fase creacionVector)
        ?f<-(nodosBeneficios $?a)
        ?x<-(nodoCB ?b)
        =>
        (retract ?f)
        (retract ?x)
        (assert (nodosBeneficios $?a ?b))
)

(defrule eliminaRepetidos
        (declare (salience 900))
        (fase creacionVector)
        ?f<-(nodosBeneficios $?ini ?X $?medio ?Y&:(eq ?X ?Y) $?fin)
        =>
        (retract ?f)
        (assert (nodosBeneficios $?ini ?X $?medio $?fin))
)

(defrule finCreacionVector
        (declare (salience -1))
        ?f<-(fase creacionVector)
        =>
       (retract ?f)
)

;;; Regla que se activa para los nodos con grados mayor de 1, esto hace que se puedan activar las reglas de seleccion y comparacion (seleccionNodo - seleccion igual Nodo)

(defrule activacionSeleccionPrimaria
        (not (fase final))
        (solucion $?a ?nodoActual)
        (nodo (nombre ?nodoActual) (produccion ?X) (grado ?y&:(> ?y 1))(vueltaAtras ?c) (tipoNodo ?i))
        =>
        (assert (fase seleccionPrimaria))
)


;;CASOS SI ALGUNO TIENE MÁS BENEFICIOS QUE EL OTRO;;

;;; CASO QUE SOLO QUEDE UNA ALTERNATIVA  PORQUE POR LOS OTROS CAMINOS SE HAN PASADO ;;; 

;; Estas regals se lanzan cuando solo queda un camino disponible, es decir, que los otros caminos se hayan visitado, escogen al unico camino que no ha sido visitado.
;; tiene la misma comparación con los caminos es decir, colocados de nodo actual a nodo siguiente y la opcion b al contrario.
(defrule seleccionCandidatoA ;;Comparación con el camino b - a
        (fase seleccionPrimaria)
        (solucion $?a ?nodoActual)
        ?f<-(camino (id ?id)(coste ?coste)(nodos ?nodoActual ?nodoSig)(vueltaAtras 0))
        ?n<-(nodo (nombre ?nodoSig) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo ?i))
        =>
        (assert (candidato obtenido))
        (assert (nodoCandidato (nombre ?nodoSig)(coste (- ?pro ?coste))))
)


(defrule seleccionCandidatoB ;;Comparación con el camino b - a 
        (fase seleccionPrimaria)
        (solucion $?a ?nodoActual)
        ?f<-(camino (id ?id)(coste ?coste)(nodos ?nodoSig ?nodoActual)(vueltaAtras 0))
        ?n<-(nodo (nombre ?nodoSig) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo ?i))
        =>
        (assert (candidato obtenido))
        (assert (nodoCandidato (nombre ?nodoSig)(coste (- ?pro ?coste))))
)


;;Regla que se activa para indicar que ya se tiene un candidato y que se a acabado la seleccion primaria
(defrule seleccionAcabada
        (declare (salience -1))
        ?f<-(fase seleccionPrimaria)
        ?f2<-(candidato obtenido)
        =>
        (retract ?f)
        (retract ?f2)
        (assert (fase posSeleccionPreferencia))        
)

;; /// SELECCION por preferencia sobre los nodos que se aislan /////


(defrule prioridadNodosConVecinosVisitadosA
        (fase posSeleccionPreferencia)
        (solucion $?a ?ultimo)
        (nodoCandidato (nombre ?nodo) (coste ?coste))
        (nodo (nombre ?nodo) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo 0))
        (camino (id ?id2)(coste ?coste2)(nodos ?nodo2 ?nodo)(vueltaAtras ?vue))
        (nodo (nombre ?nodo2&:(neq ?ultimo ?nodo2)) (produccion ?pro2) (grado ?grado2) (vueltaAtras 1) (tipoNodo ?x))
        =>
        (assert (nodoPrioridad ?nodo))
)


(defrule prioridadNodosConVecinosVisitadosB
        (fase posSeleccionPreferencia)
        (solucion $?a ?ultimo)
        (nodoCandidato (nombre ?nodo) (coste ?coste))
        (nodo (nombre ?nodo) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo 0))
        (camino (id ?id2)(coste ?coste2)(nodos ?nodo ?nodo2)(vueltaAtras ?vue))
        (nodo (nombre ?nodo2&:(neq ?ultimo ?nodo2)) (produccion ?pro2) (grado ?grado2) (vueltaAtras 1) (tipoNodo ?x))
        =>
        (assert (nodoPrioridad ?nodo))
)


;; Comprobacion de que no se ha visitado ;;

(defrule solucionQueNoEsteEnElConjunto
        (declare (salience 1000))
        (fase posSeleccionPreferencia)
        (solucion $?a ?alguno $?fin)
        ?f<-(nodoPrioridad ?alguno)
        =>
        (retract ?f)
)

;; Verificacion si tiene vecinos no visitados ;;

(defrule verificaNodoConVecinosA
        (fase posSeleccionPreferencia)
        (solucion $?a ?ultimo)
        ?f<-(nodoPrioridad ?nodo)
        (nodo (nombre ?nodo) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo 0))
        (camino (id ?id2)(coste ?coste2)(nodos ?nodo2 ?nodo)(vueltaAtras ?vue))
        (nodo (nombre ?nodo2&:(neq ?ultimo ?nodo2)) (produccion ?pro2) (grado ?grado2) (vueltaAtras 0) (tipoNodo ?x))
        =>
        (retract ?f)
)

(defrule verificaNodoConVecinosB
        (fase posSeleccionPreferencia)
        (solucion $?a ?ultimo)
        ?f<-(nodoPrioridad ?nodo)
        (nodo (nombre ?nodo) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo 0))
        (camino (id ?id2)(coste ?coste2)(nodos ?nodo2 ?nodo)(vueltaAtras ?vue))
        (nodo (nombre ?nodo2&:(neq ?ultimo ?nodo2)) (produccion ?pro2) (grado ?grado2) (vueltaAtras 0) (tipoNodo ?x))
        =>
        (retract ?f)
)

(defrule finPosSeleccionPreferencia
        (declare (salience -100))
        ?f<-(fase posSeleccionPreferencia)
        =>
        (retract ?f)
        (assert (fase posSeleccion))
)
;;; PosSeleccion con prioridad ;;;

(defrule posSeleccionPrioridad
        (declare (salience 500))
        (fase posSeleccion)
        ?f1<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?nP<-(nodoPrioridad ?nodo)
        ?f2<-(nodoCandidato (nombre ?nodo2) (coste ?coste2&:(> ?coste ?coste2)))
        ?nP2<-(nodoPrioridad ?nodo2)
        =>
        (retract ?f2)
        (retract ?nP2)
)


(defrule posSeleccionIgualPrioridad
        (declare (salience 500))
        (fase posSeleccion)
        ?f1<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?nP<-(nodoPrioridad ?nodo)
        ?f2<-(nodoCandidato (nombre ?nodo2) (coste ?coste2&:(= ?coste ?coste2)))
        ?nP2<-(nodoPrioridad ?nodo2)
        (test (neq ?f1 ?f2))
        =>
        (retract ?f2)
        (retract ?nP2)
)


;; Reglas para eliminar a los nodoCandidatos sin prioridad ;;

(defrule elimnaNoPrioritarios
        (declare (salience 400))
        ?f1<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?nP<-(nodoPrioridad ?nodo)
        ?f2<-(nodoCandidato (nombre ?nodo2) (coste ?coste2))
        (test (neq ?f1 ?f2))
        =>
        (retract ?f2)
)

;; Esta regla se activa con la anterior (fase posSeleccion) y lo que hace es ir eliminando aquellos nodosCandidatos que tienen un coste mayor, por lo
;; tanto se queda con los mejores nodos.
(defrule posSeleccion
        (declare (salience 200))
        (fase posSeleccion)
        ?f1<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?f2<-(nodoCandidato (nombre ?nodo2) (coste ?coste2&:(> ?coste ?coste2)))
        =>
        (retract ?f2)
)


(defrule posSeleccionIgual
        (declare (salience 200))
        (fase posSeleccion)
        ?f1<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?f2<-(nodoCandidato (nombre ?nodo2) (coste ?coste2&:(= ?coste ?coste2)))
        (test (neq ?f1 ?f2))
        =>
        (retract ?f2)
)

;; Para evitar los ciclos, se marcan los caminos por donde se han pasado, la unica forma de volver sobre sus pies es en los nodos de grado1

;;Estas dos reglas lo que hacen es una vez que ya hay un nodo ganador, se marca como que se ha recogido la produccion, se le marca como 0, y al camino
;;se le marca como que ya ha sido visitado.
(defrule ultimoSuperA
        ?f<-(fase posSeleccion)
        ?f2<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?so<-(solucion $?a ?ultimo)
        ?n<-(nodo (nombre ?nodo) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo ?i))
        ?ca<-(camino (id ?id2)(coste ?coste2)(nodos ?ultimo ?nodo)(vueltaAtras ?vue))
        =>
        (retract ?f)
        (retract ?f2)
        (retract ?so)
        (assert (solucion $?a ?ultimo ?nodo))
        (modify ?n (produccion 0)(vueltaAtras 1))
        (modify ?ca (vueltaAtras 1))
)

(defrule ultimoSuperB
        ?f<-(fase posSeleccion)
        ?f2<-(nodoCandidato (nombre ?nodo) (coste ?coste))
        ?so<-(solucion $?a ?ultimo)
        ?n<-(nodo (nombre ?nodo) (produccion ?pro) (grado ?grado) (vueltaAtras ?vuelta) (tipoNodo ?i))
        ?ca<-(camino (id ?id2)(coste ?coste2)(nodos ?nodo ?ultimo)(vueltaAtras ?vue))
        =>
        (retract ?f)
        (retract ?f2)
        (retract ?so)
        (assert (solucion $?a ?ultimo ?nodo))
        (modify ?n (produccion 0)(vueltaAtras 1))
        (modify ?ca (vueltaAtras 1))
)

;;////////// REGLA GRADO 1 ///////////;;
;;Estas reglas son para los nodos de grado1, ya que solo tienen una forma de seguir la ruta y es volver por donde vino.
;;Se selecciona de la solucion el nodo anterior y el nodo actual, se comprueba que el nodo actual tenga grado 1 y se vuelve a crear una solucion con el camino correcto.
(defrule casoNodoGrado1
        (fase seleccionPrimaria)
        (not (fase final))
        ?f<-(solucion $?a ?nodoAnterior ?nodoActual)
        ?n<-(nodo (nombre ?nodoActual) (produccion ?X) (grado 1)(vueltaAtras ?c) (tipoNodo ?i))
        =>
        (retract ?f)
        (assert (solucion $?a ?nodoAnterior ?nodoActual ?nodoAnterior))
        (modify ?n (produccion 0)(vueltaAtras 1))
)

;;//// PRIORIZACION DE ACCESO A LOS SECTORES DE GRADO1 ///////;;

;Se prioriza el acceso a los nodos de grado uno, se comprueba que el nodo sea de grado1 y que tenga un beneficio mayor de 0, si no es rentable no se va
(defrule prioridadGrado1A
        (declare (salience 500))
        (fase seleccionPrimaria)
        ?f<-(solucion $?a ?nodoActual)
        ?ca<-(camino (id ?id)(coste ?coste)(nodos ?nodoActual ?nodoSig)(vueltaAtras 0))
        ?n<-(nodo (nombre ?nodoSig) (produccion ?pro&:(> (- ?pro ?coste) 0)) (grado 1) (vueltaAtras 0) (tipoNodo 0))
        =>
        (retract ?f)
        (assert (solucion $?a ?nodoActual ?nodoSig))
        (modify ?ca (vueltaAtras 1))
        (modify ?n (produccion 0)(vueltaAtras 1))
)

(defrule prioridadGrado1B
        (declare (salience 500))
        (fase seleccionPrimaria)
        ?f<-(solucion $?a ?nodoActual)
        ?ca<-(camino (id ?id)(coste ?coste)(nodos ?nodoSig ?nodoActual)(vueltaAtras 0))
        ?n<-(nodo (nombre ?nodoSig) (produccion ?pro&:(> (- ?pro ?coste) 0)) (grado 1) (vueltaAtras 0) (tipoNodo 0))
        =>
        (retract ?f)
        (assert (solucion $?a ?nodoActual ?nodoSig))
        (modify ?ca (vueltaAtras 1))
        (modify ?n (produccion 0)(vueltaAtras 1))
)

;; //Opción antibloqueo// ;;

(defrule antibloqueoA
        (declare (salience -101))
        (not (candidato obtenido))
        (not (fase final))
        (fase seleccionPrimaria)
        ?f<-(solucion $?a ?nodoAnterior ?nodoActual)
        ?ca<-(camino (id ?id)(coste ?coste)(nodos ?nodoAnterior ?nodoSig)(vueltaAtras 0))
        =>
        (retract ?f)
        (assert (solucion $?a ?nodoAnterior ?nodoActual ?nodoAnterior))
)


(defrule antibloqueoB
        (declare (salience -101))
        (not (candidato obtenido))
        (not (fase final))
        (fase seleccionPrimaria)
        ?f<-(solucion $?a ?nodoAnterior ?nodoActual)
        ?ca<-(camino (id ?id)(coste ?coste)(nodos ?nodoSig ?nodoAnterior)(vueltaAtras 0))
        =>
        (retract ?f)
        (assert (solucion $?a ?nodoAnterior ?nodoActual ?nodoAnterior))
)

;;////REGLA DE SALIDA////;;
;; Si no quedan más reglas que ejecutar sale.

(defrule compruebaResultado
        (declare (salience -200))
        (solucion $?a)
        (nodosBeneficios $?b)
        =>        
        (assert (fase comprobacion))
        (bind ?f (interseccion $?a $?b))
        (assert (cantidadInt (length$ ?f)))
        (assert (cantidadSol (length$ $?b)))
)

(defrule todosVisitados
        ?f<-(fase comprobacion)
        ?a<-(cantidadSol ?cantidadSol)
        ?c<-(cantidadInt ?cantidadInt&:(= ?cantidadInt ?cantidadSol))
        =>
        (retract ?f)
        (retract ?a)
        (retract ?c)
        (assert (fase final))
)

(defrule faltanPorVisitar
        ?f<-(fase comprobacion)
        ?a<-(cantidadSol ?cantidadSol)
        ?c<-(cantidadInt ?cantidadInt&:(neq ?cantidadInt ?cantidadSol))
        =>
        (retract ?f)
        (retract ?a)
        (retract ?c)
        (assert (fase marchaAtras))
)

(defrule resultado
        (declare (salience 1000))
        (fase final)
        (solucion $?a)
        =>
        (printout t "Solución obtenida: " $?a crlf)
)

;;;; Marcha atras ;;;;


(defrule marchaAtras
        ?c<-(fase marchaAtras)
        ?f<-(solucion $?a ?nodoAnterior ?nodoActual)
        =>
        (retract ?c)
        (retract ?f)
        (assert (solucion $?a ?nodoAnterior))
)


;;///// INICIALIZACIÓN ////;; 
;; Esta inicializacion solo es valida cuando se inicia en un nodo de grado uno. Se comprueba que la solucion solo tenga un elemento y que sea de grado 1
;; se mira que camino tiene que seguir, y se marca el camino y se le pone la produccion a 0.
(defrule iniGrado1A
        ?f<-(solucion ?nodoActual)
        ?ca<-(camino (id ?id)(coste ?coste)(nodos ?nodoActual ?nodoSig)(vueltaAtras 0))
        ?n<-(nodo (nombre ?nodoActual) (produccion ?X) (grado 1)(vueltaAtras ?c) (tipoNodo ?i))
        =>
        (retract ?f)
        (assert (solucion ?nodoActual ?nodoSig))
        (modify ?n (produccion 0))
        (modify ?ca (vueltaAtras 1))
)

(defrule iniGrado1B
        ?f<-(solucion ?nodoActual)
        ?ca<-(camino (id ?id)(coste ?coste)(nodos ?nodoSig ?nodoActual)(vueltaAtras 0))
        ?n<-(nodo (nombre ?nodoActual) (produccion ?X) (grado 1)(vueltaAtras ?c) (tipoNodo ?i))
        =>
        (retract ?f)
        (assert (solucion ?nodoActual ?nodoSig))
        (modify ?n (produccion 0))
        (modify ?ca (vueltaAtras 1))
)


;;; ///Elimina las intersecciones innecesarias //// ;;;;

(defrule quitaIntersecciones
        (declare (salience 10))
        (fase final)
        ?f<-(solucion $?a ?ultimo)
        (nodo (nombre ?ultimo) (produccion ?X) (grado ?z)(vueltaAtras ?c) (tipoNodo 1))
        =>
        (retract ?f)
        (assert (solucion $?a))

)
