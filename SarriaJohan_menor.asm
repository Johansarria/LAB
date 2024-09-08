.data
    prompt:    .asciiz "¿CUANTOS NUMEROS DESEA COMPARAR, DEBE SER ENTRE 3 Y 5 ?: "
    errorMsg:  .asciiz "ERROR, DEBE INGRESAR UN NUMERO ENTRE 3 y 5.\n"
    numPrompt: .asciiz "INGRESE UN NUMERO: "
    resultMsg: .asciiz "EL NUMERO MENOR ES: "


.text
    .globl main

main:
    # Solicitar la cantidad de números a comparar
    li $v0, 4                 # syscall para imprimir cadena
    la $a0, prompt            # cargar la dirección del mensaje
    syscall

    li $v0, 5                 # syscall para leer entero
    syscall
    move $t0, $v0             # Guardar la cantidad de números en $t0

    # Verificar si la cantidad de números está entre 3 y 5
    blt $t0, 3, invalid_input # Si es menor a 3, error
    bgt $t0, 5, invalid_input # Si es mayor a 5, error

    # Inicializar el menor número a un valor muy alto
    li $t1, 2147483647        # $t1 tendrá el número menor

    # Bucle para leer los números y encontrar el menor
    li $t2, 0                 # Contador de números leídos

input_loop:
    bge $t2, $t0, print_result # Si ya hemos leído suficientes números, mostrar el resultado

    # Solicitar número
    li $v0, 4                 # syscall para imprimir cadena
    la $a0, numPrompt          # cargar la dirección del mensaje
    syscall

    # Leer número ingresado
    li $v0, 5                 # syscall para leer entero
    syscall
    move $t3, $v0             # Guardar el número ingresado en $t3

    # Comparar si el número ingresado es menor que el actual menor
    bge $t3, $t1, next_number  # Si el número ingresado no es menor, pasar al siguiente

    # Actualizar el menor número
    move $t1, $t3

next_number:
    addi $t2, $t2, 1          # Incrementar el contador de números leídos
    j input_loop              # Volver a leer el siguiente número

invalid_input:
    # Mensaje de error si el número de entradas no es válido
    li $v0, 4                 # syscall para imprimir cadena
    la $a0, errorMsg           # cargar la dirección del mensaje de error
    syscall
    j main                    # Volver a empezar

print_result:
    # Imprimir el menor número
    li $v0, 4                 # syscall para imprimir cadena
    la $a0, resultMsg          # cargar la dirección del mensaje de resultado
    syscall

    move $a0, $t1             # Cargar el menor número en $a0
    li $v0, 1                 # syscall para imprimir entero
    syscall

    # Salir del programa
    li $v0, 10                # syscall para salir
    syscall
