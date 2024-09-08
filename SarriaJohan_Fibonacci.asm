.data
    prompt:      .asciiz "¿Cuántos números de la serie Fibonacci desea generar?: "
    resultMsg:   .asciiz "La serie Fibonacci es: "
    sumMsg:      .asciiz "\nLa suma de la serie es: "
    newline:     .asciiz "\n"

.text
    .globl main

main:
    # Solicitar la cantidad de números a generar
    li $v0, 4                 # syscall para imprimir cadena
    la $a0, prompt            # cargar la dirección del mensaje
    syscall

    li $v0, 5                 # syscall para leer entero
    syscall
    move $t0, $v0             # Guardar la cantidad de números en $t0

    # Inicializar los primeros dos números de la serie Fibonacci
    li $t1, 0                 # $t1 será el número Fibonacci actual (f0)
    li $t2, 1                 # $t2 será el siguiente número Fibonacci (f1)
    li $t3, 0                 # Suma total de los números de la serie
    li $t4, 0                 # Contador de iteraciones

    # Mostrar el mensaje de la serie
    li $v0, 4
    la $a0, resultMsg
    syscall

fibonacci_loop:
    # Si ya se han generado todos los números, pasar a mostrar el resultado
    bge $t4, $t0, print_sum

    # Imprimir el número Fibonacci actual
    move $a0, $t1
    li $v0, 1
    syscall

    # Imprimir una coma y un espacio después del número
    li $v0, 4
    la $a0, newline
    syscall

    # Sumar el número actual a la suma total
    add $t3, $t3, $t1

    # Calcular el siguiente número de la serie Fibonacci
    add $t5, $t1, $t2         # $t5 = f0 + f1
    move $t1, $t2             # Actualizar f0 con el valor de f1
    move $t2, $t5             # Actualizar f1 con el valor de la suma

    # Incrementar el contador de iteraciones
    addi $t4, $t4, 1
    j fibonacci_loop          # Repetir hasta generar la cantidad deseada

print_sum:
    # Imprimir el mensaje de la suma
    li $v0, 4
    la $a0, sumMsg
    syscall

    # Imprimir la suma de la serie
    move $a0, $t3
    li $v0, 1
    syscall

    # Salto de línea final
    li $v0, 4
    la $a0, newline
    syscall

    # Salir del programa
    li $v0, 10                # syscall para salir
    syscall
