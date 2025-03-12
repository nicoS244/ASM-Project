;Proyecto Final
;Estructura y Programación de Computadoras
;Nombre: Sarmiento Monroy Miguel Nicolás
;Grupo: 07
;Semestre: 2025 - 1
;Última edición: 29/11/2024
title RELOJ
.model small
.stack 64
.data
diez equ 10
exCode db 0
hora db 'HH:MM:SS:CS','$' ;Cadena en la cual se ira imprimiendo el reloj, cada casilla representa una unidad de medida, de izquierda a derecha son horas, minutos, segundos y centésimas de segundo.
vectorTiempo db 00,00,00,00 ;Vector de datos en el cual se guardan los datos del tiempo del sistema obtenidos a partir de la interrupción.
contadorAux dw 0 ;Variable que nos permite ir guardando los valores de CX para los loops utilizados en los lados izquierdo y derecho del recuadro.
auxSup dw 0 ;Variable auxiliar, sirve para guardar el número de veces que se imprime el carácter en la parte superior del recuadro.
auxInf dw 0 ;Variable auxiliar, sirve para guardar el número de veces que se imprime el carácter en la parte inferior del recuadro.
auxColumnaInf db 0 ;Variable auxiliar que nos permite guardar la columna el cual se ira actualizando a medida que se usa.
auxDer db 0 ;Valor que permite ir brincando de renglón en renglón al construir el lado derecho del recuadro.
auxIzq db 0 ;Valor que permite ir brincando de renglón en renglón al construir el lado izquierdo del recuadro.
.code
principal proc far
	mov ax, @data
	mov ds, ax
	mov es, ax
;===============================================================================================================================================================================
;Limpiar pantalla
	mov ah, 0FH
	int 10h
	mov ah, 0
	int 10h
;------------------------------------------------------------------------Impresión del recuadro---------------------------------------------------------------------------------
;===============================================================================================================================================================================
;Ciclo para imprimir la parte superior del recuadro
	mov ah, 02h ;Opción
	mov dh, 3 ;Renglón, valor constante definido mediante inspección visual.
	mov dl, 32 ;Columna, valor variable definido mediante inspección visual.
	mov bh, 00 ;Página
	int 10h ;Posiciona el cursor
	mov cx, 20
	parteSup:
	;Dentro de este ciclo se encuentra una interrupción que permite implementar una especie de delay para crear el efecto deseado en la animación
		mov auxSup, cx ;Guardamos el valor de cx actual.
		mov cx, 00h ;CX=0000
		mov dx, 9999h ;DX=9999
		;Mandamos a llamar a la opción 86h de la interrupción 15h, esta nos permite hacer una  o delay pausa por valor en microsegundos que se encuentra en los registros CX:DX,
		;según la conversión se trata de 39321 microsegundos, el valor fue escodigo mediante pruebas con distintos valores.
		mov ah, 86h
		int 15h 
		mov cx, auxSup ;Como CX cambio para la interrupción tenemos que recuperar el valor el cual esta guardado en auxSup, CX=CX Actual
		mov ah, 0eh ;Opción que nos permite imprimir un carácter, nos funciona ya que no necesita del valor de CX, solo el código ASCII del carácter a imprimir.
		mov al, 254 ;Código ASCII del carácter, en este caso el carácter es ■.
		int 10h ;Invocamos a la interrupción para imprimir en pantalla.
		loop parteSup ;Sentencia para indicar el ciclo que en este caso se realizará 20 veces.
;===============================================================================================================================================================================
;Imprime lado derecho del recuadro
	mov cx, 11 ;CX=11, número de veces que se realizará el ciclo, el número fue escogido mediante evaluaciones visuales.
	mov auxDer, 3 ;Este valor representa el renglón en el cual se empieza a dibujar el lado derecho del cuadrado, nuevamente fue escogido mediante evaluaciones visuales.
	ladoDerecho:
		mov contadorAux, cx ;Al igual que para la parte superior guardamos el valor de CX actual.
		mov ah, 02h ;Opción
		mov dh, auxDer ;Renglón
		mov dl, 52 ;Columna en la que termino la impresión de la parte superior del recuadro.
		mov bh, 00 ;Página
		int 10h ;Posiciona el cursor
		mov cx, 00h ;CX=0000
		mov dx, 9999h ;DX=9999
		;Mandamos a llamar a la opción 86h de la interrupción 15h, esta nos permite hacer una pausa por valor en microsegundos que se encuentra en los registros CX:DX,
		;según la conversión se trata de 39321 microsegundos, el valor fue escodigo mediante pruebas con distintos valores.
		mov ah, 86h 
		int 15h 
		mov ah, 0eh ;Opción que nos permite imprimir un carácter, nos funciona ya que no necesita del valor de CX, solo el código ASCII del carácter a imprimir.
		mov al, 254 ;Código ASCII del carácter, en este caso el carácter es ■.
		int 10h ;Invocamos a la interrupción para imprimir en pantalla.
		inc auxDer ;Incrementamos el valor del renglón para la siguiente iteración.
		mov cx, contadorAux ;Recuperamos el valor para la cuenta del loop CX =CX actual.
		loop ladoDerecho ;Sentencia para indicar el ciclo que en este caso se realizará 11 veces.
;===============================================================================================================================================================================
;Ciclo para imprimir la parte inferior del recuadro, tiene un funcionamiento igual al de la parte superior del recuadro la diferencia radica en el sentido de la impresión, este se
;modifico de manera que ahora fuera en sentido inverso, de derecha a izquierda.
	mov ah, 02h ;Opción
	mov dh, 13 ;Renglón, valor constante definido mediante inspección visual.
	mov dl, 52 ;Columna, valor  variable, definido mediante cálculos.
	mov bh, 00 ;Página
	int 10h ;Posiciona el cursor
	mov cx, 20
	mov auxColumnaInf, dl ;Variable auxiliar que nos permite guardar la columna inicial para usarla posteriormente en el ciclo.
	parteInf:
		mov auxInf, cx ;Guardamos el valor actual de CX para usarlo posteriormente.
		mov cx, 00h
		mov dx, 9999h
		;Mandamos a llamar a la opción 86h de la interrupción 15h, esta nos permite hacer una pausa por valor en microsegundos que se encuentra en los registros CX:DX,
		;según la conversión se trata de 39321 microsegundos, el valor fue escodigo mediante pruebas con distintos valores.
		mov ah, 86h
		int 15h
		mov cx, auxInf ;Recuperamos el valor actual de CX
		mov ah, 02h ;Indicamos la opción debido a que habrá un reposicionamiento del cursor con nuevas coordenadas.
		;Reingresamos el valor constante del renglón en la parte alta del registro DX, dicha parte fue alterada en la línea 84 al indicar el tiempo de espera para la
		;opción 86h de la interrupción 15h
		mov dh, 13
		dec auxColumnaInf ;Decrementamos el valor de la columna actual para poder crear el efecto deseado.
		mov dl, auxColumnaInf ;Reasignamos el valor de la columna para la siguiente iteración, DL = DL Actual - 1
		mov auxColumnaInf, dl ;Guardamos el valor actual de columna para la siguiente iteración.
		int 10h ;Reposicionamos el cursor con las nuevas coordenadas definidas.
		;FInalmente imprimimos en pantalla.
		mov ah, 0eh 
		mov al, 254
		int 10h
		loop parteInf
;===============================================================================================================================================================================
;Imprime lado izquierdo del recuadro, de igual manera que el lado derecho pero en sentido contrario, ahora de abajo hacia arriba
	mov cx, 11
	mov auxIzq, 13 ;Este valor representa el renglón en el cual se empezará a dibujar, este mismo valor ira decrementando a medida que avanza el ciclo.
	ladoIzquierdo:
		mov contadorAux, cx ;Guardamos el valor actual de CX.
		mov ah, 02h ;Opción
		mov dh, auxIzq ;Renglón, valor variable que ira decrementando.
		mov dl, 32 ;Columna
		mov bh, 00 ;Página
		int 10h ;Posiciona el cursor
		mov cx, 00h
		mov dx, 9999h
		;Mandamos a llamar a la opción 86h de la interrupción 15h, esta nos permite hacer una pausa por valor en microsegundos que se encuentra en los registros CX:DX,
		;según la conversión se trata de 39321 microsegundos, el valor fue escodigo mediante pruebas con distintos valores.
		mov ah, 86h
		int 15h
		;Imprimimos en pantalla.
		mov al, 254
		mov ah, 0eh
		int 10h
		dec auxIzq ;Decrementamos el valor del renglón de manera que la siguiente impresión se haga en el renglón inmediato superior siguiendo el sentido deseado.
		mov cx, contadorAux ;Recuperamos el valor actual de CX para seguir iterando.
		loop ladoIzquierdo
;===============================================================================================================================================================================
;Remover el apuntador
	mov ah, 01h
	mov cx, 02607h
	int 10h
	anima:
;===============================================================================================================================================================================
;Obtener el tiempo del sistema mediante la opción 02Ch de la interrupción 21h.
		mov ah, 02Ch
		int 21h
;===============================================================================================================================================================================
;Cast de número a cadena
;Construyendo un vector con tiempo numérico, cada elemento del vector corresponde a una unidad de medida del tiempo, en este caso el primer espacio del vector copia el 
;valor de horas, el segundo el de minutos, el tercero el de segundos y el cuarto el de centésimas de segundo.
		mov [vectorTiempo], ch
		mov [vectorTiempo+1], cl
		mov [vectorTiempo+2], dh
		mov [vectorTiempo+3], dl
		mov cx, 04
		;Inicializamos los dos apuntadores que nos ayudarán a pasar los valores de "vectorTiempo" a la cadena "hora".
		mov si, offset hora ;Iniciando apuntador al inicio de la cadena "hora", la cual se imprimirá posteriormente.
		mov di, offset vectorTiempo ;Iniciando el apuntador al inicio del vector "vectorTiempo" del cual tomaremos los valores para pasarlos a la cadena "hora".
	consCadena:
		xor ax,ax ;Liberamos el espiritu de AX, ceros en AX.
		mov al, [di] ;Al = Valor al que apunta DI en ese momento.
		mov bl, diez ;BL = 10, constante definida en el segmento de datos.
		div bl ;Al realizar esta división podemos separar decenas y unidades en el registro AX, quedando las decenas en la parte alta del registro y las unidades en la parte baja del registro.
		xor ax, 3030h ;Esta operación nos permite convertir los valores obtenidos previamente a su equivalente en ASCII
		;Guardamos los carácteres en ASCII en donde apunta SI en ese momento, primero guardamos decenas y después unidades.
		mov [si], al
		mov [si+1], ah
		add si, 03 ;Movemos el apuntador 3 posiciones, esto para pasar los valores de decenas y unidades de la unidad de tiempo así como el carácter ":" que se encuentra en los espacios intermedios de la cadena.
		inc di ;Movemos el apuntador al siguiente valor de "vectorTiempo" para la siguiente iteración.
		loop consCadena ;El ciclo se repite 4 veces, en cada una se obtiene un valor para las unidades de tiempo.
;===============================================================================================================================================================================
;Ubicamos el cursor para imprimir en pantalla, aproximadamente a la mitad del recuadro previamente dibujado.
	xor ax, ax
	mov ah, 02h ;Opción
	mov dh, 8 ;Renglón
	mov dl, 37 ;Columna
	mov bh, 00 ;Página
	int 10h
;===============================================================================================================================================================================
;Imprimimos la cadena "hora".
	mov ah, 09
	mov dx, offset hora
	int 21h
;===============================================================================================================================================================================
	in al, 60h ;Ve por el valor que hay en el puerto 60h, es decir, revisa el número de tecla ingresada en el teclado.
	dec al ;AL = AL - 1, el objetivo de esta función es verificar si se presiono la tecla que permite terminar la ejecución, en este caso la tecla "esc"
	;Salto que evalua el valor de AL, si la resta realizada resulto en cero, es decir, se presiono tecla de escape el programa termina, en caso de no haberla presionado
	;el programa salta de regreso a la etiqueta "anima" para seguir imprimiendo el reloj en pantalla.
	jnz anima 
;===============================================================================================================================================================================
;Limpia pantalla antes de terminar la ejecución.
	mov ah, 0FH
	int 10h
	mov ah, 0
	int 10h
	salida:
	mov ah, 04ch
	mov al, exCode
	int 21h
principal endp
end