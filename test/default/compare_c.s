		.text
main:
    	addi_c $t15, $t14, $t1, $t2, 2, 2
		addi_c $t13, $t12, $t3, $t4, 3, 3
        compare_c $t11, $t10, $t15, $t14, $t13, $t12
		syscall
