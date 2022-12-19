%include "in_out.asm"

section .date
oprator_list				db  "100010:mov,000000:add,000100:adc,001010:sub,\
000110:sbb,001000:and,000010:or,001100:xor,001110:cmp,100001:test,100001:xchg,111111:inc,\
111101:neg,111101:not,110100:shr,110100:shl,111101:idiv,111111:dec,"

oprator_reg_111101			db  "101:imul,111:idiv,011:neg,010:not,",NL
oprator_reg_111111			db  "001:dec,000:inc,",NL

oprator_two_oprandi			db "000000:add,000100:adc,001010:sub,\
000110:sbb,001000:and,000010:or,001100:xor,001110:cmp,100001:test,100010:mov,\
00001111101011:imul,00001111110000:xadd,00001111101111:bsf,100010:mov,000000:add,000100:adc,001010:sub,\
000110:sbb,001000:and,000010:or,001100:xor,001110:cmp,100001:test,100001:xchg,111111:inc,\
111101:neg,111101:not,110100:shr,110100:shl,111101:idiv,111111:dec",NL

zero_oprand_opcode_list		db  "11000011:ret,11111001:stc,11111000:clc,11111101:std,011111100:cld,0000111100000101:syscall,",NL
oprand_prefix				db  "66",NL
address_prefix				db  "67",NL
zero_f_str				db  "0f",NL
opcode111101				db  "111101",NL
opcode111111				db  "111111",NL
test_or_xchg				db  "100001",NL
bsf_or_bsr				db  "00001111101111",NL
bsf_str				db  "bsf",NL
bsr_str				db  "bsr",NL
test_str				db  "test",NL
xchg_str				db  "xchg",NL
section .bss
	input			resb	100
	prefix_adrs_flg	resq	1
	prefix_opr_flg		resq	1				
	rex			resq	1
	rex_w			resb	10
	rex_r			resb	10
	rex_x			resb	10
	rex_b			resb	10
	oprator		resb	50
	opcode			resb	50
	d_opcode		resb	10
	w_opcode		resb	10
	mod			resb	10
	reg			resb	10
	r_m			resb	10
	mov_alter		resq	1
	three_byte_opcode	resq	1
	sib			resq	1
	disp			resb	100
	scale			resb	10
	index			resb	10
	base			resb	10
	base_flg		resb	10
	input_bin		resb	100
	result			resb	100
	temp1			resb	100
	temp2			resb	100
	number_of_oprand	resq	1
	index_register		resq	10
	

section .text
	global _start
	
%macro find_in_list 2
	push rdx
	push r15
	push rsi
	push rdx
	push r8
	mov rsi , %1
	mov rdi , %2
	len rdi
	mov r15, 0
	mov rax , 0	
	%%find_in_list_for1:
		cmp byte[rsi],0xA
		je %%end_find_in_list
		cmp rdx , 0
		je %%yes_find_in_list
		cmp byte[rsi] , ','
		je %%reset_find_in_list_for1
		mov r8b , byte[rdi]
		cmp byte[rsi] , r8b
		jne %%reset_find_in_list_for2
		dec rdx
		inc rsi
		inc rdi
		jmp %%find_in_list_for1	
	%%reset_find_in_list_for1:
		inc r15
		inc rsi
		mov rdi , %2
		len rdi
		jmp %%find_in_list_for1
			
	%%reset_find_in_list_for2:
		cmp byte[rsi] , ','
		je %%reset_find_in_list_for1
		inc rsi
		jmp %%reset_find_in_list_for2	
		
	%%yes_find_in_list:
		mov rax , 1
	%%end_find_in_list:
		mov rbx , r15
		pop r8
		pop rsi
		pop rdi
		pop r15
		pop rdx
%endmacro	
%macro len 1
	push rdi
	push r14
	push r15
	push rcx	
	mov rdx,0
	mov rdi,%1
	%%len_for:
	    mov bl,byte [rdi]
	    cmp bl,0xA
	    je %%end_len
	    inc rdx
	    inc rdi
	    jmp %%len_for
	%%end_len:
	    pop rcx
	    pop r15
	    pop r14
	    pop rdi    
%endmacro

%macro concat 2
	push rdi
	push r8
	push r9
	push rax
	push rsi
	mov rdi , %1
	len rdi
	mov rsi , %1	
	mov r8  , rdx
	mov rdi , %2
	add rsi , rdx
	len rdi
	%%while1: 	
		cmp rdx , 0
		je %%end_func
		xor rax,rax
		mov al , [rdi]	
		mov [rsi], rax
		inc rsi
		inc rdi
		dec rdx
		jmp %%while1
	
	%%end_func:
		mov byte [rsi], 0xA
	pop rsi	
	pop rax
	pop r8
	pop r9
	pop rdi
%endmacro

%macro search_in_dic 3 ;dic ;key ;memory to save valu of key
	push rsi
	push rdi
	push rcx
	push r15
	push r8
	push rax
	mov rsi , %1
	mov rdi , %2
	mov rcx , %3
	len rdi
	mov r15 , 0
	%%check_search_in_dic:
		cmp rdx , 0
		je %%print_search_in_dic
		cmp byte[rsi] , ','
		je %%reset_search_in_dic1
		mov r8b , byte[rdi]
		cmp byte[rsi] , r8b
		jne %%reset_search_in_dic2
		dec rdx
		inc rsi
		inc rdi
		jmp %%check_search_in_dic
		
	%%reset_search_in_dic1:
		inc r15
		inc rsi
		mov rdi , %2
		len rdi
		jmp %%check_search_in_dic
		
	%%reset_search_in_dic2:
		cmp byte[rsi] , ','
		je %%reset_search_in_dic1
		inc rsi
		jmp %%reset_search_in_dic2
	%%print_search_in_dic:
		inc rsi
		cmp byte[rsi] , ','
		je %%end_search_in_dic
		xor rax,rax
		mov al,byte[rsi]
		mov byte[rcx], al
		inc rcx
		jmp %%print_search_in_dic
	%%end_search_in_dic:
		mov byte[rcx], 0xA
		pop rax
		pop r8
		pop r15
		pop rcx
		pop rdi
		pop rsi
%endmacro

%macro hexToBin 2	;hex_arr ; memory_to_save
    push rax
    push rbx 
    push rcx 
    push rdx 
    push rsi 
    push rdi 

    mov rsi,%1
    mov rdi,%2
    mov rbx,2
    mov rax,0
    mov rcx,4
	%%body_htb:
	    mov al,[rsi]
	    cmp al,0xA
	    je %%end_htb
	    cmp al,97
	    jge %%letter_htb
	    jmp %%digit_htb
	%%letter_htb:
	    sub al,87
	    jmp %%next_htb
	%%digit_htb:
	    sub al,48
	    jmp %%next_htb
	%%next_htb:
	    cmp rcx,0
	    je %%next2_htb
	    mov rdx,0
	    div rbx
	    add dl,48
	    dec rcx
	    mov [rdi+rcx],dl
	    jmp %%next_htb
	%%next2_htb:
	    mov rcx,4
	    inc rsi
	    add rdi,4
	    jmp %%body_htb
	%%end_htb:
	    mov byte [rdi],0xA

    pop rdi 
    pop rsi 
    pop rdx 
    pop rcx 
    pop rbx 
    pop rax

%endmacro 

%macro cut_from 2 ;get str and index and save str[index+1:]
	push r15
	push r14
	push rcx
	push rdx
	push rsi
	push rdi
	mov r15,%1
	mov r14,%2
	mov rdi,r15
	len rdi
	mov rcx,rdx
	sub rcx,r14 ;save iterates of rcx
	lea rsi,[r15+r14] ;str[index+1]
	mov rdi,r15
	rep movsb
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop r14
	pop r15
%endmacro

%macro cut_from_zero 3 ;str,index,return_str
	push r15
	push r14
	push rcx
	push rdx
	push rsi
	push rdi
	
	mov r15,%1
	mov r14,%2
	mov r13,%3
	mov rcx,r14
	mov rsi,r15
	mov rdi,r13
	rep movsb
	mov byte[r14+r13],0xA
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop r14
	pop r15

%endmacro

%macro check_equal 2 ;str ; oprator ; memory to save yes or no
	push rdi
	push rsi
	push rax
	push rdx
	push r8
	push r9
	
	xor rbx,rbx
	mov rdi , %1
	len rdi
	mov r8,rdx	;length of str
	mov rsi , %1
	mov rdi , %2
	len rdi
	mov r9,rdx	;length of oprator
	cmp r9,r8
	jne %%no_check_equal
	je %%check_equal_for
	
	%%check_equal_for:
		cmp r8,0
		je %%yes_check_equal
		xor rax,rax
		mov al, byte[rdi]
		cmp byte[rsi],al
		jne %%no_check_equal
		inc rsi
		inc rdi
		dec r8
		jmp %%check_equal_for
		
	%%yes_check_equal:
		mov rbx,1
		jmp %%end_check_equal
	%%no_check_equal:
		mov rbx,0
	%%end_check_equal:
		pop r9
		pop r8
		pop rdx
		pop rax
		pop rsi
		pop rdi
%endmacro
%macro move_str2_to_str 2
	push r12
	push r13
	push rax	
	mov r12, %1
	mov r13, %2	
	%%move_str2_to_str_loop1:
		cmp byte[r13],0xA
		je %%end_move_str2_to_str
		xor rax,rax
		mov al , byte[r13]
		mov byte[r12],al
		inc r12
		inc r13
		jmp %%move_str2_to_str_loop1
	%%end_move_str2_to_str:
		mov byte[r12],0xA
		;mov byte[r12+1],0xA
		pop rax
		pop r12
		pop r13
%endmacro
%macro print 1              
	push rax
	push rsi
	mov rax,0
	mov rsi,%1
	%%body_print:
		mov al,[rsi]
		call putc
		cmp al,0xA
		je %%end_print
		inc rsi
		jmp %%body_print
	%%end_print:
		pop rsi
	    	pop rax
%endmacro


_start:
	call set_mem
	call read_input
	hexToBin input,input_bin
	call handle_zero_oprand
zahra:
	call parse_input
	call handle_oprator
	;check_equal mod,str11
	;cmp rbx,1
	jmp exit
	
	
handle_oprator:
	check_equal opcode, opcode111101
	cmp rbx , 1
	je handle_oprator_set_opcode_oprator_reg_111101
	check_equal opcode, opcode111111
	cmp rbx , 1
	je handle_oprator_set_opcode_oprator_reg_111111
	cmp byte[three_byte_opcode],3
	je handle_oprator_set_opcode_3_byte
	jne handle_oprator_set_opcode_oprator
	
	
	
	handle_oprator_set_opcode_oprator_reg_111101:
		search_in_dic oprator_reg_111101,reg,oprator
		mov byte[number_of_oprand] , 1
		jmp end_handle_oprator
	handle_oprator_set_opcode_oprator_reg_111111:
		search_in_dic oprator_reg_111111,reg,oprator
		mov byte[number_of_oprand] , 1
		jmp end_handle_oprator
		
	handle_oprator_set_opcode_oprator:
		search_in_dic oprator_two_oprandi,opcode,oprator
		check_equal oprator,test_str
		cmp rbx,1
		je check_test_or_xchg
		jne end_handle_oprator
		
	
	handle_oprator_set_opcode_3_byte:
		check_equal opcode,bsf_or_bsr
		cmp rbx,1
		je check_bsr_or_bsf
		jne handle_oprator_set_opcode_oprator
		
	check_bsr_or_bsf:
		mov byte [w_opcode],1
		je oprator_is_bsr
		move_str2_to_str oprator,bsf_str
		jmp end_handle_oprator
	
	oprator_is_bsr:
		move_str2_to_str oprator,bsr_str
		jmp end_handle_oprator
		
	check_test_or_xchg:
		mov byte [d_opcode],1
		je oprator_is_xchg
		move_str2_to_str oprator,test_str
		jmp end_handle_oprator
		
	oprator_is_xchg:
		move_str2_to_str oprator,xchg_str
		jmp end_handle_oprator
		
	end_handle_oprator:
		print oprator
		ret
		
handle_reg_to_reg:
	push r8
	call find_index_register
	concat rex_r, reg
	move_str2_to_str reg,rex_r	
	concat rex_b, r_m
	move_str2_to_str r_m,rex_b	
	check_equal oprator,bsr_str
	add r8,rbx
	check_equal oprator,imul_str
	add r8,rbx
	check_equal oprator,bsf_str
	add r8,rbx
	
	cmp r8,0
	je handle_reg_to_reg_state
	move_str2_to_str temp1 , reg
	move_str2_to_str reg , r_m
	move_str2_to_str t_m , temp1
	


find_index_register:
	cmp byte[prefix_opr_flg] , 1
	je find_index_register_set_index1
	cmp byte[rex_w],'1'
	je find_index_register_set_index3
	cmp byte[w_opcode], 0
	jne find_index_register_set_index2
	check_equal oprator,bsf_str
	cmp rbx , 1
	je find_index_register_set_index0
	jmp find_index_register_set_index2
	
	find_index_register_set_index1:
		mov byte[index_register],1
		jmp end_find_index_register
	find_index_register_set_index2:
		mov byte[index_register],2
		jmp end_find_index_register
	find_index_register_set_index3:
		mov byte[index_register],3
		jmp end_find_index_register
	find_index_register_set_index0:
		mov byte[index_register],0
		jmp end_find_index_register
	end_find_index_register:
		ret
	
	
parse_input:
	cut_from_zero input, 2,temp1
	check_equal address_prefix, temp1
	cmp rbx , 1
	jne parse_input_pre_oprand
	mov byte [prefix_adrs_flg] , 1
	cut_from input , 2
	mov byte [temp1], 0xA
	
   parse_input_pre_oprand:
   	cut_from_zero input, 2,temp1
   	check_equal oprand_prefix , temp1
	cmp rbx , 1
	jne parse_input_rex
	mov byte [prefix_opr_flg] , 1
	cut_from input , 2
	mov byte[temp1], 0xA
	
   parse_input_rex:
   	cut_from_zero input, 1,temp1
   	cmp byte[temp1],'4'
   	jne parse_input_opcode_3_byte
   	cut_from input , 1
   	cut_from_zero input, 1,temp1
   	hexToBin temp1 , temp2
   	mov byte [rex],1
   	xor rax , rax 
   	mov al , byte [temp2]
   	mov byte [rex_w] , al
      	mov al , byte [temp2+1]
   	mov byte [rex_r] , al
      	mov al , byte [temp2+2]
   	mov byte [rex_x] , al
      	mov al , byte [temp2+3]
   	mov byte [rex_b] , al
   	mov byte [temp1] , 0xA
   	mov byte [temp2] , 0xA
   	cut_from input , 1

   	
   parse_input_opcode_3_byte:
   	cut_from_zero input, 2,temp1
   	check_equal temp1, zero_f_str
  	cmp rbx , 1
  	jne parse_input_opcode_normal
  	mov byte[three_byte_opcode] , 1
  	cut_from_zero input, 4,temp1
  	hexToBin temp1, temp2
  	cut_from_zero temp2, 14,opcode
  	cut_from temp2 , 14
  	cut_from_zero temp2, 1, d_opcode
  	cut_from temp2 , 1
  	cut_from_zero temp2, 1,w_opcode
  	cut_from input , 4
  	jmp parse_input_mod_reg_r_m
  	
    parse_input_opcode_normal:
      	cut_from_zero input, 2,temp1
  	hexToBin temp1, temp2
  	cut_from_zero temp2, 6,opcode
  	cut_from temp2 , 6
  	cut_from_zero temp2, 1, d_opcode
  	cut_from temp2 , 1
  	cut_from_zero temp2, 1,w_opcode
  	cut_from input , 2
    	
  	
    parse_input_mod_reg_r_m:
        cut_from_zero input, 2,temp1
  	hexToBin temp1, temp2
  	cut_from_zero temp2, 2,mod
  	cut_from temp2 , 2
  	cut_from_zero temp2, 3, reg
  	cut_from temp2 , 3
  	cut_from_zero temp2, 3,r_m
  	cut_from input , 2
    	
	ret
	

	
handle_zero_oprand:
	find_in_list zero_oprand_opcode_list,input_bin
	cmp rax, 1
	jne end_handle_zero_oprand
	search_in_dic zero_oprand_opcode_list,input_bin,result
	print result
	end_handle_zero_oprand:
	ret

read_input:
	mov rax, 0         
	mov rdi, 0       
	mov rsi, input
	mov rdx, 100      
	syscall
	ret
	
set_mem:
	mov byte[rex],0
	mov byte[prefix_opr_flg] , 0
	mov byte[prefix_adrs_flg] , 0
	mov byte[three_byte_opcode], 0
	mov byte[sib] , 0
	mov byte[base_flg] , 0
	mov byte[oprator],0xA
	mov byte[rex_r],'0'
	mov byte[rex_r+1],0xA
	mov byte[rex_b],'0'
	mov byte[rex_b+1],0xA
	mov byte[rex_w],'0'
	mov byte[rex_w+1],0xA
	mov byte[rex_x],'0'
	mov byte[rex_x+1],0xA
	ret
exit:
  mov   rax , 1
  mov   rbx , 0
  int   0x80