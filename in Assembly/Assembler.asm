%include "in_out.asm"
section .date
registr_list 				db 	"rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15,\
eax,ecx,edx,ebx,esp,ebp,esi,edi,r8d,r9d,r10d,r11d,r12d,r13d,r14d,r15d,\
ax,cx,dx,bx,sp,bp,si,di,r8w,r9w,r10w,r11w,r12w,r13w,r14w,r15w,\
al,cl,dl,bl,ah,ch,dh,bh,r8b,r9b,r10b,r11b,r12b,r13b,r14b,r15b"

r_m_register				db 	 "rax:000,rcx:001,rdx:010,rbx:011,rsp:100,rbp:101,rsi:110,rdi:111,\
eax:000,ecx:001,edx:010,ebx:011,esp:100,ebp:101,esi:110,edi:111,\
ax:000,cx:001,dx:010,bx:011,sp:100,bp:101,si:110,di:111,\
al:000,cl:001,dl:010,bl:011,ah:100,ch:101,dh:110,bh:111,\
r8:000,r9:001,r10:010,r11:011,r12:100,r13:101,r14:110,r15:111,\
r8d:000,r9d:001,r10d:010,r11d:011,r12d:100,r13d:101,r14d:110,r15d:111,\
r8w:000,r9w:001,r10w:010,r11w:011,r12w:100,r13w:101,r14w:110,r15w:111,\
r8b:000,r9b:001,r10b:010,r11b:011,r12b:100,r13b:101,r14b:110,r15b:111,"

two_oprand_opcode_list 		db	"mov:100010,add:000000,adc:000100,sub:001010,sbb:000110,and:001000,or:000010,xor:001100,cmp:001110,\
test:100001,xchg:100001,xadd:00001111110000,bsf:00001111101111,bsr:00001111101111,imul:00001111101011,shr:1101000,shl:1101000,"


zero_oprand_opcode_list		db	"ret:11000011,stc:11111001,clc:11111000,std:11111101,cld:011111100,syscall:0000111100000101,"
one_oprand_opcode_list 		db 	"inc:1111111,neg:1111011,not:1111011,shr:1101000,shl:1101000,idiv:1111011,dec:1111111,shm:1100000,"
one_oprand_reg_opcode_list 		db 	"inc:000,neg:011,not:010,shr:101,shl:100,idiv:111,dec:001,"
xchg_str				db	"xchg" , NL
imul_str				db	"imul", NL
bsf_str				db	"bsf", NL
bsr_str				db	"bsr", NL
test_str				db	"test", NL
xadd_str				db	"xadd", NL
xor_str				db	"xor", NL
inc_str				db	"inc", NL
zero_disp_str				db	"0x0", NL
blank					db	" ",NL
path					db	"/home/zahra/Desktop/project/test.txt",0
pathBin				db	"/home/zahra/Desktop/project/resultBin.txt",0
pathHex				db	"/home/zahra/Desktop/project/resultHex.txt",0
	
section .bss
	input 			resb 	100
	oprator 		resb 	100
	oprand 		resb 	100
	oprand1 		resb 	100
	oprand2 		resb 	500
	zero_opcode		resb	200
	opcode			resb	100
	mod_reg_r_m		resb	400
	one_reg		resb 	100
	rex			resb	100
	r_m			resb	100
	reg			resb	100
	oprand_type		resq	10
	oprand1_type		resq	10
	oprand2_type		resq	10
	oprand_size		resq	10
	oprand1_size		resq	10
	oprand2_size		resq	10
	input_len 		resq 	10
	zero_oprand 		resq 	10
	one_oprand 		resq 	10
	two_oprand 		resq 	10
	comma_index		resq 	10
	space_index		resq	10
	w_opcode		resq	10
	d_opcode		resq	10
	mod			resb	30
	index_register1	resq	10
	row_register1		resq	10
	index_register2	resq	10
	row_register2		resq	1
	rex_r			resb	100
	rex_b			resb	100
	rex_w			resb	100
	rex_x			resb	100
	rex_flag		resq	10
	result			resb	1000
	oprand_prefix		resb	1000
	address_prefix		resb	1000
	memory_size		resq	10
	temp1			resb	400
	temp2			resb	400
	temp3			resb	100
	disp			resb	400
	index			resb	400
	base			resb	100
	sib_flag		resq	10
	sib			resb	300
	disp_size		resq	10
	scale_number		resq	10
	scale			resb	100
	sib_index		resb	100
	sib_base		resb	100
	prefix_adrs_flag	resq	10
	base_size		resq	10
	index_size		resq	10
	disp_result		resb	80
	disp_result_bin	resb	100
	prefix_oprnd_flag	resb	10
	n			resb	10
	file_desc		resq	1
	file_desc_bin		resq	1
	file_desc_hex		resq	1
	file_input		resb	10000
	zero_str		resb	100
	
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

%macro binToHex 1
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push rsi
    push rdi

    mov rsi,%1
    mov rdi,%1
%%start_bTH:
    cmp byte [rsi],0xA
    je %%end_bTH
    mov rax,8
    mov rbx,2
    mov rcx,4
    mov r8,0
%%loop_bTH:
    cmp rcx,0
    je %%after_bTH
    mov dl,[rsi]
    cmp dl,'1'
    je %%add_bTH
    jmp %%next_bTH
%%add_bTH:
    add r8,rax
%%next_bTH:
    dec rcx
    mov rdx,0
    div rbx
    inc rsi
    jmp %%loop_bTH
%%after_bTH:
    cmp r8,10
    jl %%digit_bTH
    add r8,87
    mov byte [rdi],r8b
    inc rdi
    jmp %%start_bTH
%%digit_bTH:
    add r8,48
    mov byte [rdi],r8b
    inc rdi
    jmp %%start_bTH
%%end_bTH:
    mov byte [rdi],0xA
    pop rdi
    pop rsi
    pop r8
    pop rdx 
    pop rcx 
    pop rbx 
    pop rax 
%endmacro


%macro extend_disp 0
	push rsi
	push rdi
	push r15
	push rax
	push r14
	push r13

	mov rsi , disp_result
	mov byte[rsi] , 0xA
	mov r15 , 0
	mov rdi , disp
	len rdi
	mov r14 ,rdx
	sub r14 , 2
	%%extend_disp_loop:
		mov rdi , disp
		len rdi
		cmp rdx , 3
		jl %%end_extend_disp
		sub rdx , 2
		mov al , byte[rdi+rdx]
		mov byte[rsi+r15],al
		inc r15
		inc rdx
		mov al , byte[rdi+rdx]
		mov byte[rsi+r15],al
		dec rdx
		mov byte[rdi+rdx],0xA
		inc r15
		jmp %%extend_disp_loop
	%%end_extend_disp:
		mov byte[rsi+r14],0xA
		mov rax ,[disp_size]
		mov r12 , 4
		xor rdx,rdx
		div r12
		mov rdi , disp_result
		len rdi
		sub rax , rdx
		%%extend_disp_final:
			cmp rax , 0
			je %%end_extend_disp_final
			mov byte[rsi+r14],'0'
			inc r14
			dec rax
			jmp %%extend_disp_final
			
		%%end_extend_disp_final:
			;inc r14
			mov byte[rsi+r14],0xA
			mov rdi, disp_result
			len rdi
			cmp rdx , 7
			je %%divonam_kardiiii
			cmp rdx , 3
			je %%divonam_kardiiii
			cmp rdx , 1
			je %%divonam_kardiiii
			jne %%tamomesh_kon
		%%divonam_kardiiii:
			mov byte[zero_str],'0'
			mov byte[zero_str+1],0xA
			concat zero_str, disp_result
			mov byte[disp_result] , 0xA
			move_str2_to_str disp_result , zero_str
		%%tamomesh_kon:	
		pop r13
		pop r14
		pop rax
		pop r15
		pop rdi
		pop rsi
%endmacro	
%macro check_prefix_address 0
	push rax
	mov byte[prefix_adrs_flag] , 0
	cmp byte[base],'Z'
	je %%check_prefix_address_elif
	check_size  base, base_size ,temp1 , temp2
	cmp byte[base_size] , 32
	je %%check_prefix_address_set_true
	jmp %%end_check_prefix_address
	
	%%check_prefix_address_elif:
		cmp byte[index],'Z'
		je %%end_check_prefix_address
		check_size  index, index_size ,temp1 , temp2
		cmp byte[index_size] , 32
		je %%check_prefix_address_set_true
		jmp %%end_check_prefix_address
		
	%%check_prefix_address_set_true:
		mov byte[prefix_adrs_flag] , 1
	
	%%end_check_prefix_address:
		pop rax
%endmacro	
%macro check_size_disp 0
	push rcx
	push rdx
	push rsi
	push rdi
	mov rdi, disp
	%%check_size_disp_lable2:
	cmp byte[base],'Z'
	je %%check_size_disp_set32
	
	cmp byte[disp],'Z'
	je %%check_size_disp_set0
	check_equal disp, zero_disp_str
	cmp rbx, 1
	je %%check_size_disp_set0
	len rdi
	cmp rdx , 4
	jg %%check_size_disp_set32
	cmp rdx , 3
	je %%check_size_disp_set8
	cmp byte[disp+2], 55
	jg %%check_size_disp_set32
	jmp %%check_size_disp_set8
	
	%%check_size_disp_set0:
		mov byte[disp_size] , 0
		mov byte[disp],'Z'
		;mov byte[disp+1],'Z'
		mov byte[disp+1],0xA
		check_size base,base_size,index_register1 , row_register1
		cmp byte[index_register1],5
		je %%check_size_disp_set8
		jmp %%end_check_size_disp
	%%check_size_disp_set8:
		mov byte[disp_size] , 8
		jmp %%end_check_size_disp
	%%check_size_disp_set32:
		mov byte[disp_size] , 32
		cmp byte[base],'Z'
		jne  %%end_check_size_disp
		mov byte[disp],'Z'
		mov byte[disp+1],0xA
		jmp %%end_check_size_disp
	%%end_check_size_disp:
		pop rdi
		pop rsi
		pop rdx
		pop rcx
%endmacro

%macro parse_memory 1 ;oprand
	push rdx
	push rcx
	push rax
	push rdi
	push rsi
	
	mov rdi , %1
	len rdi
	mov rsi , %1
	mov byte[rsi+rdx-1],'+'
	mov rdi , temp1
	%%parse_memory_loop1:
		cmp byte[rsi] , '['
		je %%start_parse_memory
		inc rsi
		jmp %%parse_memory_loop1
	%%start_parse_memory:
		inc rsi
	
	%%find_plus_parse_memory:
		cmp byte[rsi] , 0xA
		je %%end_string_parse_memory
		cmp byte[rsi],'+'
		je %%i_find_plus_parse_memory
		xor rax,rax
		mov al,byte[rsi]
		mov byte[rdi],al
		inc rsi
		inc rdi
		jmp %%find_plus_parse_memory
		
	%%i_find_plus_parse_memory:
		mov byte[rdi],0xA
		cmp byte[temp1], '0'
		je %%find_disp_parse_memory
		find_char_in_str temp1 , '*'
		cmp rcx, 1
		je %%find_index_parse_memory
		jne %%find_base_parse_memory

	%%find_base_parse_memory:
		cmp byte[temp1],0xA
		je %%end_string_parse_memory
		move_str2_to_str base,temp1
		mov byte[temp1],0xA
		mov rdi , temp1
		inc rsi
		jmp %%find_plus_parse_memory
				
	%%find_index_parse_memory:
		slise_index_scale temp1
		mov byte[temp1],0xA
		mov rdi, temp1
		inc rsi
		jmp %%find_plus_parse_memory
			
	%%find_disp_parse_memory:
		move_str2_to_str disp,temp1
		mov byte[temp1],0xA
		mov rdi , temp1
		inc rsi
		jmp %%find_plus_parse_memory
		
	%%end_string_parse_memory:
		check_prefix_address
		check_size_disp
		extend_disp
		pop rsi
		pop rdi
		pop rax
		pop rcx
		pop rdx
%endmacro

%macro slise_index_scale 1 ;index*scale
	push rsi
	push rdi
	push rax
	mov rsi , %1
	mov rdi , index
	%%slise_index_scale_loop1:
		cmp byte[rsi], '*'
		je %%slise_index_scale_loop2
		xor rax,rax
		mov al , byte[rsi]
		mov byte[rdi],al
		inc rdi
		inc rsi
		jmp %%slise_index_scale_loop1
		
	%%slise_index_scale_loop2:
		mov byte[rdi] , 0xA
		cmp byte[rsi+1] , '1'
		je %%slise_index_scale_set_scale00
		cmp byte[rsi+1] , '2'
		je %%slise_index_scale_set_scale01
		cmp byte[rsi+1] , '4'
		je %%slise_index_scale_set_scale10
		cmp byte[rsi+1] , '8'
		je %%slise_index_scale_set_scale11
		
		
		%%slise_index_scale_set_scale00:		
			mov byte[scale_number] , 1
			mov byte[scale],'0'
			mov byte[scale+1],'0'
			jmp %%end_slise_index_scale
			
		%%slise_index_scale_set_scale01:
			mov byte[scale_number] , 2
			mov byte[scale],'0'
			mov byte[scale+1],'1'
			jmp %%end_slise_index_scale
			
		%%slise_index_scale_set_scale10:
			mov byte[scale_number] , 4
			mov byte[scale],'1'
			mov byte[scale+1],'0'
			jmp %%end_slise_index_scale
			
		%%slise_index_scale_set_scale11:
			mov byte[scale_number] , 8
			mov byte[scale],'1'
			mov byte[scale+1],'1'
			jmp %%end_slise_index_scale		
				
	%%end_slise_index_scale:
		mov byte[scale+2] , 0xA
		pop rax
		pop rdi
		pop rsi
%endmacro
%macro find_char_in_str 2 ;str ;char
	push rsi
	push rdi
	push rax
	mov rsi , %1
	mov al , %2
	mov rcx , 0
	%%find_char_in_str_loop:
		cmp byte[rsi],0xA
		je %%end_find_char_in_str 
		cmp byte[rsi], al
		je %%yes_find_char_in_str
		inc rsi
		jmp %%find_char_in_str_loop
	%%yes_find_char_in_str:
		mov rcx , 1
		jmp %%end_find_char_in_str
	%%end_find_char_in_str:
		pop rax
		pop rdi
		pop rsi	
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

%macro size_memory 2 ;oprand ;memory to save size
	push rdi
	push rsi
	mov rsi , %1
	mov rdi , %2
	cmp byte[rsi] , 'B'
	je %%parse_memory_set_size8
	cmp byte[rsi] , 'W'
	je %%parse_memory_set_size16
	cmp byte[rsi] , 'D'
	je %%parse_memory_set_size32
	cmp byte[rsi] , 'Q'
	je %%parse_memory_set_size64
	
	%%parse_memory_set_size8:
		mov byte[rdi],8
		jmp %%endparse_memory
		
	%%parse_memory_set_size16:
		mov byte[rdi],16
		jmp %%endparse_memory
		
	%%parse_memory_set_size32:
		mov byte[rdi],32
		jmp %%endparse_memory
		
	%%parse_memory_set_size64:
		mov byte[rdi],64
		jmp %%endparse_memory
	%%endparse_memory:
	pop rsi
	pop rdi		
%endmacro

%macro check_type 2 ;oprand ;memory to save type
	push rsi
	push rdi
	mov rsi, %1
	mov rdi , %1
	mov rsi , %2
	len rdi
	dec rdx
	cmp byte[rdi] , '0'
	je %%imm_type
	cmp byte[rdi+rdx] , ']'
	je %%mem_type
	jne %%reg_type
	
	%%imm_type: 
		mov byte[rsi], 3
		jmp %%end_check_type		
	%%mem_type:
		mov byte[rsi], 2
		jmp %%end_check_type	
	%%reg_type:
		mov byte[rsi], 1
		jmp %%end_check_type		
	%%end_check_type:
		pop rdi
		pop rsi	
%endmacro

%macro check_size 4 ;oprand ;memory to save size ; memory to save index ; memory to save row
	push rsi
	push rdi
	push rax
	push rdx
	push rcx
	push r8
	push r15
	push r14
	push r13
	
	mov rsi , registr_list
	mov rdi , %1
	mov rcx , %2
	mov r13 , %3
	mov r14 , %4
	
	len rdi
	mov r15 , 0
	%%check_size_for1:
		cmp rdx , 0
		je %%end_check_size
		cmp byte[rsi] , ','
		je %%reset_check_size_for1
		mov r8b , byte[rdi]
		cmp byte[rsi] , r8b
		jne %%reset_check_size_for2
		dec rdx
		inc rsi
		inc rdi
		jmp %%check_size_for1
		
	%%reset_check_size_for1:
		inc r15
		inc rsi
		mov rdi , %1
		len rdi
		jmp %%check_size_for1
		
	%%reset_check_size_for2:
		cmp byte[rsi] , ','
		je %%reset_check_size_for1
		inc rsi
		jmp %%reset_check_size_for2
		
	%%end_check_size:
		mov rax , r15
		xor rdx , rdx
		mov rbx , 16
		div rbx
		mov [r14],rax
		mov [r13],rdx
		cmp rax , 0
		je  %%check_size64
		cmp rax , 1
		je  %%check_size32
		cmp rax , 2
		je  %%check_size16
		jne %%check_size8
		
	%%check_size64:
		mov byte[rcx] , 64
		jmp %%end_check_size2
		
	%%check_size32:
		mov byte[rcx] , 32
		jmp %%end_check_size2
		
	%%check_size16:
		mov byte[rcx] , 16
		jmp %%end_check_size2
		
	%%check_size8:
		mov byte[rcx] , 8
		jmp %%end_check_size2
				
	%%end_check_size2:
		pop r13
		pop r14
		pop r15
		pop r8
		pop rcx
		pop rdx
		pop rax
		pop rdi
		pop rsi		
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

%macro concat_string 3
	push rdi
	push r8
	push r9
	push rax	
	mov rdi , %1
	len rdi
	mov rsi , %3	
	mov r8 , rdx
	%%while1: 	
		cmp rdx , 0
		je %%continue1
		mov al , [rdi]	
		mov [rsi], rax
		inc rsi
		inc rdi
		dec rdx
		jmp %%while1	
	%%continue1:	
		mov rdi , %2
		len rdi	
	%%while2:
		cmp rdx, 0
		je %%end_func
		mov al , [rdi]
		mov [rsi] , al
		inc rsi
		inc rdi
		dec rdx
		jmp %%while2
	
	%%end_func:
		mov byte [rsi], 0xA
		mov rsi , %3	
	pop rax
	pop r8
	pop r9
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

%macro openFile 1 ;file path
  push_all 
  mov r15,%1
  mov rax, sys_open
  mov rsi, O_RDWR | O_CREAT | O_APPEND
  mov rdx, sys_IRUSR | sys_IWUSR
  mov rdi,r15
  syscall
  pop_all
%endmacro

%macro closeFile 1	;discreptor
    push_all
    mov r15,%1
    mov rdi,r15
    mov rax, sys_close
    syscall
    pop_all
%endmacro
    
%macro readFile 2 ;file desc ;buffer inputed
  push_all
  mov rdi,%1
  mov rsi,%2
  mov rdx,10000
  mov rax,sys_read
  syscall
  pop_all
%endmacro

%macro writeFilebin 2 ;desc ; buffer
	push_all
  	mov r15,%1
	mov r14,%2
	
	mov rdi , r14
	len rdi
	mov r13 , rdx
	mov rdi,r15
	mov rsi,r14
	mov rbx,r14
	lea rdx,[r13]
	mov rax,sys_write
	syscall
	pop_all
%endmacro

%macro writeFilehex 2 ;desc ; buffer
	push_all
  	mov r15,%1
	mov r14,%2
	
	mov rdi , r14
	len rdi
	mov r13 , rdx
	inc r13
	mov rdi,r15
	mov rsi,r14
	mov rbx,r14
	lea rdx,[r13]
	mov rax,sys_write
	syscall
	pop_all
%endmacro

%macro push_all 0
	push r15
	push r14
	push rdi
	push rsi
	push rbx
	push rdx
%endmacro

%macro pop_all 0
	pop rdx
	pop rbx
	pop rsi
	pop rdi
	pop r14
	pop r15
%endmacro

%macro slise_file 1 ;input_file
	push rsi
	push rdi
	push r13	
	mov rsi , %1
	mov rdi, input
	mov r8 , 0
   %%slise_file_loop:
	cmp byte[rsi] , 0
	je %%end_macro_slise_file
	cmp byte[rsi],0xA
	je %%end_macro_slise_file
	mov al , byte[rsi]
	mov byte[rdi] , al
	inc rsi
	inc rdi
	inc r8
	jmp %%slise_file_loop
	%%end_macro_slise_file:
		mov byte[rdi],0xA
		mov rdi , file_input
		len rdi
		cut_from file_input , r8
	pop r13
	pop rdi
	pop rsi	
%endmacro
%macro cut_from 2 ;get str and index and save str[index+1:]
	push_all
	mov r15,%1
	mov r14,%2
	mov rdi,r15
	call GetStrlen
	mov rcx,rdx
	sub rcx,r14 ;save iterates of rcx
	lea rsi,[r15+r14+1] ;str[index+1]
	mov rdi,r15
	rep movsb
	pop_all
%endmacro


section .text
	global _start
	
_start:
	openFile path
	mov [file_desc],rax
	openFile pathBin
	mov [file_desc_bin],rax
	openFile pathHex
	mov [file_desc_hex],rax
	readFile [file_desc],file_input
zahra:	
	slise_file file_input
	print input
	cmp byte[input],0xA
	je exit
	call set_my_mem
	call read_input
	mov rsi,input
	call find_oprator
	cmp byte[zero_oprand],1
	je handle_zero_oprand
	cmp byte[one_oprand],1
	je handle_one_oprand
	cmp byte[two_oprand],1
	je hendle_two_oprand
	jmp zahra

print_result:
	print_prefix_addres:
		cmp byte[prefix_adrs_flag],1
		jne print_prefix_oprand
		call set_address_prefix
		concat result, address_prefix
		jmp print_prefix_oprand
	print_prefix_oprand:
		cmp byte[prefix_oprnd_flag],1
		jne print_rex
		call set_oprand_prefix
		concat result , oprand_prefix
		jmp print_rex
	print_rex:
		cmp byte[rex_flag],1
		jne print_opcode
		concat result,rex
		jmp print_opcode
	print_opcode:
		concat result , opcode
		concat result , mod_reg_r_m

	print_dispmnt:
		hexToBin disp_result , disp_result_bin
		concat result , disp_result_bin
	
	writeFilebin [file_desc_bin],result
	mov rsi , result
	call printString
	binToHex result
	concat result, blank
	concat result, input
	writeFilehex [file_desc_hex],result
	print result	
	ret
	
handle_zero_oprand:
	search_in_dic zero_oprand_opcode_list,input,zero_opcode
	mov rsi , zero_opcode
	call printString
	writeFilebin [file_desc_bin],zero_opcode
	binToHex zero_opcode
	concat zero_opcode, blank
	concat zero_opcode, input
	writeFilehex [file_desc_hex],zero_opcode
	print zero_opcode
	jmp zahra

handle_one_oprand:
	call find_oprator
	call find_one_oprand
	check_type oprand,oprand1_type
	cmp byte[oprand1_type] , 1
	je handle_one_oprand_register
	cmp byte[oprand1_type] , 2
	je handle_one_oprand_memory
	jmp zahra
	
handle_one_oprand_memory:	
	size_memory oprand,memory_size
	parse_memory oprand
	call hendle_opcpde_one_oprand
	call handle_mod_r_m_one_oprand
	call handle_rex_one_oprand_memory
	call print_result
	jmp zahra
	
handle_one_oprand_register:
	check_size oprand,oprand1_size,index_register1 , index_register1
	cmp byte[oprand1_size] , 16
	je handle_one_oprand_register_oprand_prefix
	jmp handle_one_oprand_register_state
	
	handle_one_oprand_register_oprand_prefix:
		mov byte[prefix_oprnd_flag],1
	handle_one_oprand_register_state:
	call hendle_opcpde_one_oprand		;opcode
	call handle_mod_r_m_one_oprand	;mod_reg_r_m
	call handle_rex_one_oprand		;rex
	call print_result
	jmp zahra
			
hendle_opcpde_one_oprand:
	search_in_dic one_oprand_opcode_list,oprator,opcode
	call handle_w_one_oprand
	concat opcode,w_opcode
	ret
		
handle_w_one_oprand:	
	cmp byte[oprand1_type],1
	je handle_w_one_oprand_register
	cmp byte[oprand1_type],2
	je handle_w_one_oprand_memory
	
	handle_w_one_oprand_register:
		cmp byte[oprand1_size],8
		je set_zero_handle_w_one_oprand
		mov byte[w_opcode], '1'
		jmp end_handle_w_one_oprand
			
		set_zero_handle_w_one_oprand:
			mov byte[w_opcode], '0'
			jmp end_handle_w_one_oprand
				
	handle_w_one_oprand_memory:
		cmp byte[memory_size],8
		je set_zero_handle_w_one_oprand
		mov byte[w_opcode], '1'
		jmp end_handle_w_one_oprand		
		
	end_handle_w_one_oprand:
		mov byte[w_opcode+1] , 0xA
		ret
		
handle_mod_r_m_one_oprand:
	cmp byte[two_oprand],1
	je handle_mod_r_m_one_oprand_fake
	search_in_dic one_oprand_reg_opcode_list,oprator,reg
	jmp here
		
	handle_mod_r_m_one_oprand_fake:
		search_in_dic r_m_register,oprand2,reg
	
	here:
	cmp byte[oprand1_type],1
	je handle_mod_r_m_one_oprand_register
	jne handle_mod_r_m_one_oprand_memory
	
	handle_mod_r_m_one_oprand_register:	
		mov byte[mod],'1'
		mov byte[mod+1],'1'
		mov byte[mod+2], 0xA
		concat mod,reg
		search_in_dic r_m_register,oprand,r_m
		concat_string mod,r_m,mod_reg_r_m
		jmp end_handle_mod_r_m_one_oprand
	
	handle_mod_r_m_one_oprand_memory:
		cmp byte[index] , 'Z'
		jne handle_mod_r_m_one_oprand_memory_set_one_sib
		cmp byte[base],'Z'
		je handle_mod_r_m_one_oprand_memory_set_r_m_101
		search_in_dic r_m_register,base,r_m
		jmp go_place1
		
	handle_mod_r_m_one_oprand_memory_set_one_sib:
		call set_sib_flag
		jmp go_place1
	handle_mod_r_m_one_oprand_memory_set_r_m_101:
		call set_r_m_101
		jmp go_place1
		
	go_place1:	
		cmp byte[disp],'Z'
		je go_place2
		cmp byte[index],'Z'
		jne go_place2
		cmp byte[base],'Z'
		jne go_place2
		call set_sib_flag
		call set_r_m_100
		jmp go_place2
	go_place2:
		cmp byte[disp],'Z'
		jne go_place3
		call set_mod_00
		jmp go_place4
	go_place3:
		check_equal disp, zero_disp_str
		cmp rbx, 1
		jne go_place4
		call set_mod_00
		jmp go_place6	
	go_place4:
		cmp byte[disp_size],8
		jne go_place5
		call set_mod_01
		jmp go_place6
	go_place5:
		;call newLine
		cmp qword[disp_size],32
		jne go_place6
		call set_mod_10
		jmp go_place6
	go_place6:
		cmp byte[base],'Z'
		je go_place7
		cmp byte[disp],'Z'
		jne go_place7
		check_size	base,base_size,index_register1 , row_register1
		cmp byte[index_register1],5
		jne go_place7
		call set_mod_01
		jmp go_place8
	go_place7:
		cmp byte[base],'Z'
		jne go_place8
		call set_mod_00
		jmp go_place8
	go_place8:
		cmp byte[sib_flag] , 1
		je end_handle_mod_r_m_one_oprand_with_sib
		concat mod , reg
		concat_string mod,r_m,mod_reg_r_m
		jmp end_handle_mod_r_m_one_oprand
		
	end_handle_mod_r_m_one_oprand_with_sib:
		call set_r_m_100
		concat mod, reg
		call handle_sib
		concat r_m , sib
		concat_string mod,r_m, mod_reg_r_m		
	end_handle_mod_r_m_one_oprand:
		ret
handle_sib:
	cmp byte[index],'Z'
	je handle_sib_without_index
	search_in_dic r_m_register,index,sib_index
	jmp handle_sib_set_sib_base
	
	handle_sib_without_index:
		mov byte[sib_index], '1'
		mov byte[sib_index+1], '0'
		mov byte[sib_index+2], '0'
		mov byte[sib_index+3], 0xA
		jmp handle_sib_set_sib_base

	handle_sib_set_sib_base:
		cmp byte[base],'Z'
		je handle_sib_without_base
		search_in_dic r_m_register,base,sib_base
		jmp end_handle_sib
		
		handle_sib_without_base:
			mov byte[sib_base], '1'
			mov byte[sib_base+1], '0'
			mov byte[sib_base+2], '1'
			mov byte[sib_base+3], 0xA
			jmp end_handle_sib
	end_handle_sib:
		concat scale, sib_index
		concat_string scale,sib_base,sib
		ret
			
set_sib_flag:
	mov byte[sib_flag],1
	ret
	
handle_rex_two_oprand_memory:
	call handle_set_defult_rex
	check_size oprand2,oprand2_size ,index_register2,row_register2
	cmp byte[index_register2],8
	jl handle_rex_two_oprand_memory_set_rex_b
	mov byte[rex_flag] ,1
	mov byte[rex_r],'1'
	jmp handle_rex_two_oprand_memory_set_rex_b
	
	handle_rex_two_oprand_memory_set_rex_b:
		cmp byte[base], 'Z'
		je handle_rex_two_oprand_memory_set_rex_x
		check_size base , base_size,index_register1,row_register1
		cmp byte[index_register1],8
		jl handle_rex_two_oprand_memory_set_rex_x
		mov byte[rex_flag],1
		mov byte[rex_b] , '1'
		jmp handle_rex_two_oprand_memory_set_rex_x
	handle_rex_two_oprand_memory_set_rex_x:
		cmp byte[index] , 'Z'
		je handle_rex_two_oprand_memory_set_rex_w
		check_size index , index_size,index_register1,row_register1
		cmp byte[index_register1],8
		jl handle_rex_two_oprand_memory_set_rex_w
		mov byte[rex_flag] ,1
		mov byte[rex_x],'1'
		jmp handle_rex_two_oprand_memory_set_rex_w
	handle_rex_two_oprand_memory_set_rex_w:
		check_size oprand2 , oprand2_size,index_register2,row_register2
		cmp byte[row_register2],0
		jne end_handle_rex_two_oprand_memory
		mov byte[rex_flag] ,1
		mov byte[rex_w],'1'
		jmp end_handle_rex_two_oprand_memory	
		end_handle_rex_two_oprand_memory:
		concat rex_w , rex_r 
		concat rex_x, rex_b 
		concat rex_w, rex_x
		concat rex, rex_w
		ret
	
		
handle_rex_one_oprand_memory:
	call handle_set_defult_rex
	cmp byte[base], 'Z'
	jne handle_rex_one_oprand_memory_set_rex_b
	je handle_rex_one_oprand_memory_set_rex_x
	handle_rex_one_oprand_memory_set_rex_b:
		check_size base,base_size ,index_register1,row_register1
		cmp byte[index_register1],8
		jl handle_rex_one_oprand_memory_set_rex_x
		mov byte[rex_flag] ,1
		mov byte[rex_b],'1'
		jmp handle_rex_one_oprand_memory_set_rex_x
	handle_rex_one_oprand_memory_set_rex_x:
		check_size index , index_size,index_register1,row_register1
		cmp byte[index_register1],8
		jl handle_rex_one_oprand_memory_set_rex_w
		mov byte[rex_flag] ,1
		mov byte[rex_x],'1'
		jmp handle_rex_one_oprand_memory_set_rex_w
	handle_rex_one_oprand_memory_set_rex_w:
		cmp byte[memory_size],64
		jne end_handle_rex_one_oprand_memory
		mov byte[rex_flag] ,1
		mov byte[rex_w],'1'
		jmp end_handle_rex_one_oprand_memory
		
	end_handle_rex_one_oprand_memory:
		concat rex_w , rex_r 
		concat rex_x, rex_b 
		concat rex_w, rex_x
		concat rex, rex_w
		ret
		
handle_rex_one_oprand:
	call handle_set_defult_rex
	
	cmp byte[index_register1], 8
	jl  set_zero_for_rex_b
	jnl set_one_for_rex_b
	
	set_zero_for_rex_b:
		mov byte[rex_b],'0'
		jmp set_rex_w_one_oprand
		
	set_one_for_rex_b:
		mov byte[rex_flag] , 1
		mov byte[rex_b],'1'
		jmp set_rex_w_one_oprand
	
	set_rex_w_one_oprand:
		cmp byte[row_register1], 0
		je  set_one_for_rex_w
		jne set_zero_for_rex_w
		
		set_zero_for_rex_w:
			mov byte[rex_w],'0'
			jmp end_handle_rex_one_oprand
			
		set_one_for_rex_w:
			mov byte[rex_flag] , 1
			mov byte[rex_w],'1'
			jmp end_handle_rex_one_oprand
			
	end_handle_rex_one_oprand:	
		concat rex_w , rex_r 
		concat rex_x, rex_b 
		concat rex_w, rex_x
		concat rex, rex_w	
		ret


hendle_two_oprand:
	call find_oprator
	call find_two_oprand
	check_type oprand1,oprand1_type
	check_type oprand2,oprand2_type
	xor rax , rax
	add rax , [oprand1_type]
	add rax , [oprand2_type]	
	cmp rax,2
	je hendle_two_oprand_register_to_register
	cmp rax , 3
	je hendle_two_oprand_mem_to_reg
	jmp zahra

hendle_two_oprand_register_to_register: 
	check_size oprand1,oprand1_size , index_register1 , row_register1
	check_size oprand2,oprand2_size , index_register2 , row_register2
	
	cmp byte[oprand1_size] , 16
	je handle_two_oprand_register_oprand_prefix
	jmp handle_two_oprand_register_state
	
	handle_two_oprand_register_oprand_prefix:
		mov byte[prefix_oprnd_flag],1
	handle_two_oprand_register_state:
		
	call hendle_opcpde_two_oprand	
	call handle_mod_r_m_two_oprand
	call handle_rex_two_oprand	
	call print_result
	jmp zahra

hendle_two_oprand_mem_to_reg:
	mov byte [d_opcode],'0'
	mov byte [d_opcode+1],0xA
	cmp byte[oprand2_type],2
	je helper
	jne not_helper
	helper:
		 call replace_mem_with_reg
	not_helper:
		check_size oprand2,oprand2_size,index_register2 , row_register2
		cmp qword[row_register2] , 2
		je hendle_two_oprand_mem_to_reg_oprand_prefix
		jne hendle_two_oprand_mem_to_reg_state
		
		hendle_two_oprand_mem_to_reg_oprand_prefix:
			mov byte[prefix_oprnd_flag],1
			;call newLine
			
			
	hendle_two_oprand_mem_to_reg_state:	
		size_memory oprand1,memory_size
		parse_memory oprand1
		call hendle_opcpde_two_oprand
		call handle_mod_r_m_one_oprand
		call handle_rex_two_oprand_memory
		call print_result	
	jmp zahra
		
replace_mem_with_reg:
	mov byte[d_opcode],'1'
	mov byte[d_opcode+1], 0xA
	move_str2_to_str temp2 , oprand1
	move_str2_to_str oprand1 , oprand2
	move_str2_to_str oprand2 , temp2
	check_type oprand1,oprand1_type
	check_type oprand2,oprand2_type
	ret
	

hendle_opcpde_two_oprand:
	search_in_dic two_oprand_opcode_list,oprator,opcode
	call handle_D_W_opcpde_two_oprand
	concat opcode,d_opcode
	concat opcode,w_opcode
	ret
	
handle_D_W_opcpde_two_oprand:
	cmp byte[oprand1_type] , 1
	je handle_D_W_opcpde_two_oprand_reg_to_reg
	cmp byte[oprand1_type] , 2
	je handle_D_W_opcpde_two_oprand_mem_to_reg
	jne zahra
	
	handle_D_W_opcpde_two_oprand_reg_to_reg:
		mov byte[d_opcode], '0'
		check_equal xchg_str,oprator
		cmp rbx , 1
		je set_one_D_opcode_two_oprand
		check_equal imul_str,oprator
		cmp rbx , 1
		je set_one_D_opcode_two_oprand
		jne set_w_opcode_two_oprand	

		set_one_D_opcode_two_oprand:
			mov byte[d_opcode], '1'
			jmp set_w_opcode_two_oprand	
		
		set_w_opcode_two_oprand:
			cmp byte[oprand1_size],8
			je set_zero_handle_w_two_oprand
			mov byte[w_opcode], '1'
			;mov byte[w_opcode+1] , 0xA
			jmp exeption_handle_w_two_oprand
				
			set_zero_handle_w_two_oprand:
				mov byte[w_opcode], '0'
				;mov byte[w_opcode+1] , 0xA
				jmp exeption_handle_w_two_oprand
			
			exeption_handle_w_two_oprand:
				check_equal imul_str,oprator
				cmp rbx,1
				je set_one_exeption_handle_w_two_oprand
				check_equal bsf_str,oprator
				cmp rbx,1
				je set_zero_exeption_handle_w_two_oprand
				check_equal bsr_str,oprator
				cmp rbx,1
				je set_one_exeption_handle_w_two_oprand
				jmp end_handle_w_d_two_oprand
			
			set_one_exeption_handle_w_two_oprand:
				mov byte[w_opcode], '1'
				jmp end_handle_w_d_two_oprand
			set_zero_exeption_handle_w_two_oprand:
				mov byte[w_opcode], '0'
				jmp end_handle_w_d_two_oprand	
				
	handle_D_W_opcpde_two_oprand_mem_to_reg:
		check_size oprand2,oprand1_size,index_register2, row_register2 
		cmp byte[oprand2_size],8
		je set_one_handle_w_two_oprand_mem_to_reg
		mov byte[w_opcode], '1'
		jmp handle_D_W_opcpde_two_oprand_mem_to_reg_exeption
				
		set_one_handle_w_two_oprand_mem_to_reg:
			mov byte[w_opcode], '1'
			jmp handle_D_W_opcpde_two_oprand_mem_to_reg_exeption
			
		handle_D_W_opcpde_two_oprand_mem_to_reg_exeption:
			check_equal bsr_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_zero
			
			check_equal bsf_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_zero
			
			check_equal xadd_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_zero
			
			check_equal test_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_zero

			check_equal xchg_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_one
			
			check_equal xor_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_one
			
			check_equal imul_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_one	
			jne go_to_handle_other_exeption1
			
		go_to_handle_other_exeption1:
			check_equal bsf_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_w_zero
			
			check_equal bsr_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_w_one
			
			check_equal imul_str,oprator
			cmp rbx,1
			je handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_w_one
			jne end_handle_w_d_two_oprand
			
		
		handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_zero:
			mov byte[d_opcode],'0'
			jmp go_to_handle_other_exeption1
		handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_d_one:
			mov byte[d_opcode],'1'
			jmp go_to_handle_other_exeption1
		
		handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_w_one:
			mov byte[w_opcode],'1'
			jmp end_handle_w_d_two_oprand
		handle_D_W_opcpde_two_oprand_mem_to_reg_exeption_set_w_zero:
			mov byte[w_opcode],'0'
			jmp end_handle_w_d_two_oprand
					
			end_handle_w_d_two_oprand:
				;call newLine
				mov byte[w_opcode+1] , 0xA
				mov byte[d_opcode+1] , 0xA
				ret

handle_mod_r_m_two_oprand:
	push r8
	mov r8, 0
	search_in_dic r_m_register,oprand1,r_m	
	search_in_dic r_m_register,oprand2,reg

	mov byte[mod],'1'
	mov byte[mod+1],'1'
	mov byte[mod+2], 0xA
	mov byte[mod_reg_r_m] , 0xA
	check_equal bsf_str,oprator
	add r8,rbx
	check_equal bsr_str,oprator
	add r8,rbx
	check_equal imul_str,oprator
	add r8,rbx
	cmp r8,0
	je normal_handle_mod_r_m_two_oprand
	jne exeption_handle_mod_r_m_two_oprand

	normal_handle_mod_r_m_two_oprand:
		concat mod_reg_r_m, mod
		concat mod_reg_r_m, reg
		concat mod_reg_r_m,r_m
		jmp end_handle_mod_r_m_two_oprand
	
	exeption_handle_mod_r_m_two_oprand:
		concat mod_reg_r_m, mod
		concat mod_reg_r_m, r_m
		concat mod_reg_r_m,reg
		jmp end_handle_mod_r_m_two_oprand

	end_handle_mod_r_m_two_oprand:
		pop r8
		ret
handle_rex_two_oprand:
	push r8
	call handle_set_defult_rex
	cmp byte[index_register1], 8
	jl  set_zero_for_rex_b_reg_to_reg
	jnl set_one_for_rex_b_reg_to_reg
	
	set_zero_for_rex_b_reg_to_reg:
		mov byte[rex_b],'0'
		jmp set_rex_w_reg_to_reg
		
	set_one_for_rex_b_reg_to_reg:
		mov byte[rex_flag] , 1
		mov byte[rex_b],'1'
		jmp set_rex_w_reg_to_reg
	
	set_rex_w_reg_to_reg:
		cmp byte[row_register1], 0
		je  set_one_for_rex_w_reg_to_reg
		jne set_zero_for_rex_w_reg_to_reg
		
		set_zero_for_rex_w_reg_to_reg:
			mov byte[rex_w],'0'
			jmp set_rex_r_reg_to_reg
			
		set_one_for_rex_w_reg_to_reg:
			mov byte[rex_flag] , 1
			mov byte[rex_w],'1'
			jmp set_rex_r_reg_to_reg
			
	set_rex_r_reg_to_reg:
			cmp byte[index_register2], 8
			jl  set_zero_for_rex_r_reg_to_reg
			jnl set_one_for_rex_r_reg_to_reg
			
			set_zero_for_rex_r_reg_to_reg:
				mov byte[rex_r],'0'
				jmp handle_rex_two_oprand_concat
				
			set_one_for_rex_r_reg_to_reg:
				mov byte[rex_flag] , 1
				mov byte[rex_r],'1'
				jmp handle_rex_two_oprand_concat
				
	handle_rex_two_oprand_concat:	
		xor r8, r8
		check_equal bsf_str,oprator
		add r8,rbx
		check_equal bsr_str,oprator
		add r8,rbx
		check_equal imul_str,oprator
		add r8,rbx
		cmp r8,0
		je normal_concat_handle_rex_two_oprand
		jne exeption_concat_handle_rex_two_oprand
	
	normal_concat_handle_rex_two_oprand:
		concat rex_w , rex_r 
		concat rex_x, rex_b 
		concat rex_w, rex_x
		concat rex, rex_w
		jmp end_handle_rex_two_oprand	
	
	exeption_concat_handle_rex_two_oprand:
		concat rex_w , rex_b
		concat rex_x, rex_r
		concat rex_w, rex_x
		concat rex, rex_w
		jmp end_handle_rex_two_oprand				
			
	end_handle_rex_two_oprand:
		pop r8			
		ret
			
read_input:
	;mov rax, 0         
	;mov rdi, 0       
	;mov rsi, input
	;mov rdx, 100      
	;syscall
	call find_input_len
	call find_comma
	call find_space
	ret
			
find_input_len:
	push rdi
	push rdx
	mov rdi, input
	len rdi
	mov [input_len],rdx
	pop rdx
	pop rdi
	ret
	
find_space:
	push rax
	push rbx
	
	mov rax , [input_len]
	mov rbx , 0
	find_space1:
		cmp rbx , rax
		je  no_find_space
		cmp byte[input+rbx] , ' '
		je yes_find_space
		inc rbx
		jmp find_space1
		
	yes_find_space:
		mov [space_index], rbx
		cmp byte [two_oprand], 1
		je find_space_and_comma
		jne find_space_only
	no_find_space:
		mov byte[zero_oprand] , 1
		jmp end_find_space
		
	find_space_and_comma:
		mov byte[one_oprand] , 0
		jmp end_find_space
	find_space_only:
		mov byte[one_oprand] , 1
		jmp end_find_space		
			
	end_find_space:
		pop rbx
		pop rax
		ret
		
find_comma:
	push rax
	push rbx
	mov rax , [input_len]
	mov rbx , 0
	find_comma1:
		cmp rbx , rax
		je  no_find_comma
		cmp byte[input+rbx] , ','
		je yes_find_comma
		inc rbx
		jmp find_comma1
		
	yes_find_comma:
		mov [comma_index], rbx
		mov byte[two_oprand] , 1
		jmp end_find_comma
	no_find_comma:
		mov byte[two_oprand] , 0
		jmp end_find_comma
			
	end_find_comma:
		pop rbx
		pop rax
		ret
	  
find_oprator:
	push r9
	push rax
	push rbx
	push r8
	mov r9,[space_index]
		find_oprator2:
		  mov rax,oprator
		  mov rbx,input
		  find_oprator3:
			  cmp r9,0
			  je end_find_oprator
			  mov r8b,byte[rbx]
			  mov byte[rax],r8b
			  inc rax
			  inc rbx
			  dec r9
			  jmp find_oprator3
	end_find_oprator: 
	  mov byte[rax],0xA   		
	  pop r8
	  pop rbx
	  pop rax
	  pop r9
	  ret
	  
find_one_oprand:
	push r9
	push rax
	push rbx
	push r8
	push r10 	
	mov r9 , [space_index]
	inc r9
	mov r10 , [input_len]
	mov rax,oprand
	mov rbx,input
	find_one_oprand2:
		  cmp r9,r10
		  je end_find_one_oprand
		  mov r8b,byte[rbx+r9]
		  mov byte[rax],r8b
		  inc rax
		  inc r9
		  jmp find_one_oprand2
	end_find_one_oprand: 
	  mov byte[rax],0xA	
	  pop r10   		
	  pop r8
	  pop rbx
	  pop rax
	  pop r9
	  ret
	
find_two_oprand:
	push r8
	push r9
	push r10 
	push rax
	push rbx
	mov r9 ,  [space_index]
	inc r9
	mov r10 , [comma_index]
	mov rax,oprand1
	mov rbx,input
	find_two_oprand2:
		  cmp r9,r10
		  je set_oprand2
		  mov r8b,byte[rbx+r9]
		  mov byte[rax],r8b
		  inc rax
		  inc r9
		  jmp find_two_oprand2
		  
	set_oprand2:
		mov byte[rax],0xA
		mov r9 ,  [comma_index]
		inc r9
		mov r10 , [input_len]	
		mov rax,oprand2
		mov rbx,input
		find_two_oprand3:
			  cmp r9,r10
			  je end_find_two_oprand
			  mov r8b,byte[rbx+r9]
			  mov byte[rax],r8b
			  inc rax
			  inc r9
			  jmp find_two_oprand3			
	
	end_find_two_oprand:
	 mov byte[rax],0xA 	  
	  pop rbx
	  pop rax
	  pop r10   	
	  pop r9
	  pop r8
	  ret

handle_set_defult_rex:
	mov byte[rex_flag] , 0
	mov byte[rex],'0'
	mov byte[rex+1],'1'
	mov byte[rex+2],'0'
	mov byte[rex+3],'0'
	mov byte[rex+4],0xA	
	mov byte[rex_r],'0'
	mov byte[rex_r+1],0xA
	mov byte[rex_b],'0'
	mov byte[rex_b+1],0xA
	mov byte[rex_w],'0'
	mov byte[rex_w+1],0xA
	mov byte[rex_x],'0'
	mov byte[rex_x+1],0xA
	ret
	
set_oprand_prefix:
	mov byte[oprand_prefix],'0'
	mov byte[oprand_prefix+1],'1'
	mov byte[oprand_prefix+2],'1'
	mov byte[oprand_prefix+3],'0'
	mov byte[oprand_prefix+4],'0'
	mov byte[oprand_prefix+5],'1'
	mov byte[oprand_prefix+6],'1'
	mov byte[oprand_prefix+7],'0'
	mov byte[oprand_prefix+8],0xA
	ret
set_address_prefix:
	mov byte[address_prefix],'0'
	mov byte[address_prefix+1],'1'
	mov byte[address_prefix+2],'1'
	mov byte[address_prefix+3],'0'
	mov byte[address_prefix+4],'0'
	mov byte[address_prefix+5],'1'
	mov byte[address_prefix+6],'1'
	mov byte[address_prefix+7],'1'
	mov byte[address_prefix+8],0xA
	ret
	
set_my_mem:
	mov byte[prefix_oprnd_flag],0
	mov byte[prefix_adrs_flag] , 0
	mov byte[result],0xA
	mov byte[address_prefix],0xA
	mov byte[oprand_prefix],0xA
	mov byte[rex_flag] , 0
	mov byte[rex],0xA
	mov byte[sib_flag] , 0
	mov byte[sib],0xA
	mov byte[base] , 'Z'
	mov byte[base+1] , 0xA
	mov byte[index] , 'Z'
	mov byte[index+1] , 0xA
	mov byte[disp] , 'Z'
	mov byte[disp+1] , 0xA
	mov byte[disp_result],0xA
	mov byte[zero_oprand],0xA
	ret

set_r_m_101:
	mov byte[r_m],'1'
	mov byte[r_m+1],'0'
	mov byte[r_m+2],'1'
	mov byte[r_m+3],0xA
	ret
set_r_m_100:
	mov byte[r_m],'1'
	mov byte[r_m+1],'0'
	mov byte[r_m+2],'0'
	mov byte[r_m+3],0xA
	ret
set_mod_00:
	mov byte[mod],'0'
	mov byte[mod+1],'0'
	mov byte[mod+2],0xA
	ret
set_mod_01:
	mov byte[mod],'0'
	mov byte[mod+1],'1'
	mov byte[mod+2],0xA
	ret
set_mod_10:
	mov byte[mod],'1'
	mov byte[mod+1],'0'
	mov byte[mod+2],0xA
	ret
exit:
  closeFile [file_desc]
  closeFile [file_desc_bin]
  closeFile [file_desc_hex]
  mov   rax , 1
  mov   rbx , 0
  int   0x80