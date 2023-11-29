		.text
main:
    	addi_c $t15, $t14, $t1, $t2, 2, 2
		addi_c $t13, $t12, $t3, $t4, 3, 3
        conj_c $t15, $t14, $t15, $t14, 0, 0
        conj_c $t13, $t12, $t13, $t12, 0, 0
		syscall
