    .text
main:   
        addi_c $t15, $t14, $t1, $t2, 2, 2
		addi_c $t13, $t12, $t3, $t4, 3, 3
        nop
        nop
        nop
        store_c $t15, $t14, 0($t1), 4($t4)  
        load_c $t11, $t10, 4($t2), 0($t1)
        syscall
