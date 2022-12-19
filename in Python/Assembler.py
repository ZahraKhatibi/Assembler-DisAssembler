from ast import operator


register_64_bit_list = ["rax","rcx","rdx","rbx","rsp","rbp","rsi","rdi","r8","r9","r10","r11","r12","r13","r14","r15"]
register_32_bit_list = ["eax","ecx","edx","ebx","esp","ebp","esi","edi","r8d","r9d","r10d","r11d","r12d","r13d","r14d","r15d"]
register_16_bit_list = ["ax","cx","dx","bx","sp","bp","si","di","r8w","r9w","r10w","r11w","r12w","r13w","r14w","r15w"]
register_8_bit_list = ["al","cl","dl","bl","ah","ch","dh","bh","r8b","r9b","r10b","r11b","r12b","r13b","r14b","r15b"]

register_64_code_dic = {

    "rax":"0000", "rcx":"0001", "rdx":"0010", "rbx":"0011", "rsp":"0100", "rbp":"0101", "rsi":"0110",  "rdi":"0111",
    "eax":"0000", "ecx":"0001", "edx":"0010", "ebx":"0011", "esp":"0100", "ebp":"0101", "esi":"0110", "edi":"0111",
    "ax":"0000", "cx":"0001", "dx":"0010", "bx":"0011", "sp":"0100", "bp":"0101", "si":"0110", "di":"0111",
    "al":"0000", "cl":"0001", "dl":"0010", "bl":"0011", "ah":"0100", "ch":"0101", "dh":"0110", "bh":"0111",
    "r8":"1000", "r9":"1001", "r10":"1010", "r11":"1011", "r12":"1100", "r13":"1101", "r14":"1110", "r15":"1111",
    "r8d":"1000", "r9d":"1001", "r10d":"1010", "r11d":"1011", "r12d":"1100", "r13d":"1101", "r14d":"1110", "r15d":"1111",
    "r8w":"1000", "r9w":"1001", "r10w":"1010", "r11w":"1011", "r12w":"1100", "r13w":"1101", "r14w":"1110", "r15w":"1111",
    "r8b":"1000", "r9b":"1001", "r10b":"1010", "r11b":"1011", "r12b":"1100", "r13b":"1101", "r14b":"1110", "r15b":"1111"
}

def find_opcode_for_two_oprand(opra , op1, op2):
    op1_type = check_oprand_type(op1)
    op2_type = check_oprand_type(op2)
    op1_size = check_oprand_size(op1)
    if op2_type == "register":
        op2_size = check_oprand_size(op2)
    oprand_code_dic = {"mov":"100010" , "add":"000000" , "adc":"000100" , "sub":"001010" , "sbb":"000110" , "and":"001000" ,
                       "or":"000010" , "xor": "001100" , "cmp":"001110" , "test":"100001" , "xchg":"100001" ,
                       "xadd": "00001111110000" ,"bsf": "00001111101111" ,"bsr":"00001111101111", "imul":"00001111101011"}
    
    op_code = oprand_code_dic[opra]

    if (op1_type == "register" and op2_type == "register"):
        if opra == "xchg":
            D = '1'
        else:
            D = '0'

        if opra == "imul":
            D = '1'
            W = '1'

        if op1_size == 8 :
            W = '0'
        else:
            W = '1'

        if opra == "bsf":
                    W = '0'
        if opra == "bsr":
                W = '1'
        return op_code + D + W

    if (op1_type == "register" and op2_type == "immediate"):

        if opra == "mov" and op1_size == 64:
            op_code = "110001"
            D = '1'
            S = ''
        elif opra == "mov" and op1_size != 64:
            op_code = '1011'
        else:
            op_code = "100000"

        if opra == "test":
            D = '1'
            S = ''
        elif opra == "mov" and op1_size != 64:
            D = ''
            S = ''
        else:
            if "0x" in op2:
                decimal_num = int(op2[2::],16)
            else:
                decimal_num = op2
            if decimal_num < 128 and op1_size != 8 :
                S = '1'
            else:
                S = '0'
            D = ''
        if op1_size == 8 :
            W = '0'
        else:
            W = '1'
        return op_code + S + D + W

    if (op1_type == "register" and op2_type == "memory" or op1_type == "memory" and op2_type == "register"):
        if op1_type == "register":
            D = '1'
        else:
            D = '0'

        if (op1_type == "register" and op1_size == 8) or (op2_type == "register" and op2_size == 8) :
            W = '0'
        else:
            W = '1'
        
        if opra in ["test","xadd","bsf","bsr"]:
            D = '0'
        
        if opra in ["xchg","xor","imul"]:
            D = '1'

        if opra in ["bsf"]:
            W = '0'

        if opra in ["bsr","imul"]:
            W = '1'


        return op_code + D + W

         

def check_oprand_type(oprand):
    if '[' in oprand:
        return "memory"

    elif "0x" == oprand[0:2] or oprand.isdigit():
        return "immediate"

    else:
        return "register"

def check_oprand_size(oprand):
    if check_oprand_type(oprand) == "register":
        if oprand in register_64_bit_list:
            return 64

        elif oprand in register_32_bit_list:
            return 32

        elif oprand in register_16_bit_list:
            return 16

        elif oprand in register_8_bit_list:
            return 8
        
def clean_oprand(oprand):
    if '[' in oprand:
        start_memory = oprand.index('[')
        oprand = oprand[start_memory : len(oprand)]
    return oprand

def address_prefix(op):
    op_data = imformation_from_memory(op)
    if op_data["base"] != "":
        if check_oprand_size(op_data["base"]) == 32:
            return True
    elif op_data["index"]!="":
        if check_oprand_size(op_data["index"]) == 32:
            return True
    if op_data["disp"] != "" and op_data["base"]+ op_data["index"] == "":
        return False
    return False  

def oprand_prefix(oprand_size):
    if oprand_size == 16: 
        return True
    return False
  
def handle_REX(opra, op1 , op2):
    rex_R = '0'
    rex_B = '0'
    rex_W = '0'
    rex_X = '0'
    if (check_oprand_type(op1) == "register" and check_oprand_type(op2) == "register"):
        r_m = register_64_code_dic[op1]
        reg_op = register_64_code_dic[op2]
        if (op1[0] == 'r' or op2[0]=="r"):
            if (opra in ["imul","bsr","bsf"]):
                rex_R = r_m[0]
                rex_B = reg_op[0]
            else:
                rex_R = reg_op[0]
                rex_B = r_m[0]

        if op1 in register_64_bit_list:
            rex_W = '1'

    if (check_oprand_type(op1)=="register" and check_oprand_type(op2) =="memory"):
        rex_R = register_64_code_dic[op1][0]
        op2_data = imformation_from_memory(op2)
        if op2_data["base"] != "":
            rex_B = register_64_code_dic[op2_data["base"]][0]
        if op2_data["index"] != "":
            rex_X = register_64_code_dic[op2_data["index"]][0]

        if op1 in register_64_bit_list:
            rex_W = '1'
        

    if (check_oprand_type(op1) == "register" and check_oprand_type(op2) == "immediate"):
        reg_op = register_64_code_dic[op1]
        rex_B = reg_op[0]
        if op1 in register_64_bit_list:
            rex_W = '1'  

    if rex_W + rex_R + rex_X + rex_B != '0000':
        return '0100'+ rex_W + rex_R + rex_X + rex_B

    return False

def handle_mod_r_m(opra , op1 , op2):
    sib = False
    if check_oprand_type(op1) == "register" and check_oprand_type(op2) == "register":
        r_m = register_64_code_dic[op1][1::]
        reg_op = register_64_code_dic[op2][1::]
        mod = '11'
        if (opra=="imul" or opra=="bsr" or opra=="bsf" ):
            reg_op = register_64_code_dic[op1][1::]
            r_m = register_64_code_dic[op2][1::]

    if (check_oprand_type(op1) == "register" and check_oprand_type(op2) == "immediate"):
        if (opra =="mov" and check_oprand_size(op1)!=64):
            mod = ''
            reg_op = register_64_code_dic[op1][1::]
            r_m = ''
        else:
            mod = '11'
            oprator_dic = {"mov":"000", "adc":"010","add":"000","and":"100","or":"001","sbb":"011","sub":"101","test":"000","cmp":"111"}
            reg_op = oprator_dic[opra]
            r_m = register_64_code_dic[op1][1::]

    if  check_oprand_type(op1) == "register" and check_oprand_type(op2) == "memory":
        reg_op = register_64_code_dic[op1][1::]
        memory_imf = imformation_from_memory(op2)
        if(memory_imf['disp']=='0x0'):
            memory_imf['disp']=''
        if memory_imf["index"] != "":
            sib = True                                                                                          
        elif memory_imf["base"] == "":
            r_m = "101"
        else:
            r_m = register_64_code_dic[memory_imf["base"]][1::]

        if memory_imf["disp"]!="" and memory_imf["base"]+memory_imf["index"] == "":
            r_m = "100"
            sib =  True
        if memory_imf["disp"] == "":
            mod = '00'
        elif memory_imf ["disp_size"] == 8:
            mod = '01'
        elif memory_imf ["disp_size"] == 32:
            mod = '10'
        else:
            mod = '11'
        
        if memory_imf["base"]!="":
            if(memory_imf["disp"]=="" and memory_imf["base"][len(memory_imf["base"])-2::]=="bp"):
                mod = '01'        
        else:
            mod = '00'

        if sib:
            sib_code = handle_sib(op2)
            r_m = "100"
            return mod + reg_op + r_m + sib_code

    if  check_oprand_type(op1) == "memory" and check_oprand_type(op2) == "register":
        reg_op = register_64_code_dic[op2][1::]
    
    return mod + reg_op + r_m

def handle_sib(op):
    op_data = imformation_from_memory(op)
    scale_code_dic = {"1":"00", "2":"01", "4":"10", "8":"11"}
    if op_data["index"] != "" and op_data["scale"] == "1":
        sib_index =  register_64_code_dic[op_data["index"]][1::]
        sib_scale = scale_code_dic["1"]
    elif op_data["index"] != "" and op_data["scale"] != "1":
        sib_index =  register_64_code_dic[op_data["index"]][1::]
        sib_scale = scale_code_dic[op_data["scale"]]
    elif op_data["index"] == "":
        sib_index = "100"
        sib_scale = "00"
    if op_data["base"] == "":
        sib_base = "101"
    else:
        sib_base = register_64_code_dic[op_data["base"]][1::]

    return sib_scale + sib_index + sib_base

def handle_data(op1,op2):
    lst = []
    re = ""
    if "0x" in op2:
        op2 = op2[2::]
    else:
        op2 = hex(int(op2))[2::]
    decimal_num = int(op2,16)
    if len(op2)%2==1:
        op2 = "0" + op2
    for i in range(0,len(op2),2):
        lst.append(op2[i:i+2])
    lst.reverse()
    re = ''.join(lst)
    if  len(op2) * 4 == check_oprand_size(op1) or len(op2)*4 < check_oprand_size(op1)//4:
        return re
    if int(decimal_num) < 128 :
        extend = 4
    else:
        extend = 8
    re += (extend-len(op2))*"0"
    return re

def handle_disp(op2):
    data_memory = imformation_from_memory(op2)
    size , data = data_memory["disp_size"] , data_memory["disp"]
    if data_memory["base"]=="" and data == ""  :
        return "00000000"    
    if size == 64:
        size = 32
    if data_memory["base"]=="":
        size = 32
    
    if data_memory["base"]!="" and data_memory["base"][len(data_memory["base"])-2::]=="bp" and data=="": 
        size = 8
    if data_memory["base"]!="" and data_memory["base"][len(data_memory["base"])-2::]=="bp" and data=="0x0": 
        size = 8
    if data_memory["base"]!="" and data_memory["base"][len(data_memory["base"])-2::]!="bp" and data=="0x0": 
        size = 0
        return ""
    re = ""
    lst = []
    op2 = data[2::]
    if len(op2)%2==1:
        op2 = "0" + op2
    extend = (size - (len(op2)*4))//4
    for i in range(0,len(op2),2):
        lst.append(op2[i:i+2])
    lst.reverse()
    re = ''.join(lst)

    re += extend * "0"
    return re
                
def convert_to_hex(bin_num):
    result = ""
    for i in range(0,len(bin_num),4):
        result += (str( hex(int(bin_num[i:i+4],2)))[2::])
    return result

def imformation_from_memory(op):
    size = op.split(" ")[0]
    base , disp , index , scale = "", "", "", ""
    op = clean_oprand(op)[1:-1]
    op_item = op.split("+")
    for i in op_item:
        if "0x" in i :
            disp = i
        elif "*" not in i and "0x" not in i and op_item.index(i)  !=0:
            index = i
            scale = "1"
        elif "*" in i:
            index, scale = i.split("*")[0], i.split("*")[1]
        else:
            base = i

    if size == "BYTE":
        size = 8
    if size == "WORD":
        size = 16
    elif size == "DWORD":
        size = 32
    elif size == "QWORD":
        size = 64
    if disp != "":
        decimal_num = int(disp[2::],16)     
        if decimal_num > 127:
            disp_size = 32 
        else:
            disp_size = 8
    else:
        if base[len(base)-2::]=="bp" and disp == "":
            disp_size = 32
        else:
            if disp =="":
                disp_size = 0
            elif len(disp[2::])*4<=8:
                disp_size = 8
            else:
                disp_size = 32
        
    memory_dic = {"size":size, "base":base, "index":index , "scale":scale, "disp" : disp, "disp_size":disp_size}
    return memory_dic 

def find_opcode_for_single_oprand(opra,op1):
    oprand_code_dic = {"inc":"1111111" , "neg":"1111011","not":"1111011","shr":"1101000", "shl":"1101000","idiv":"1111011","dec":"1111111","shm":"1100000","sh1":"1101000"}
    op_code = oprand_code_dic[opra]
    if check_oprand_type(op1)=="register":
        if check_oprand_size(op1) == 8 :
            W = '0'
        else:
            W = '1'
    elif check_oprand_type(op1)=="memory":
        op_size = imformation_from_memory(op1)["size"]
        if op_size == 8:
            W = "0"
        else:
            W = '1'
    return op_code + W

def find_mod_for_single_oprand(opra,op1):
    reg_op_dic = {"inc":"000" , "neg":"011","not":"010","shr":"101", "shl":"100","idiv":"111","dec":"001"}
    reg_op = reg_op_dic[opra]
    if check_oprand_type(op1) == "register":
        mod = "11"
        r_m = register_64_code_dic[op1][1::]

    if check_oprand_type(op1) == "memory":
        sib = False
        memory_imf = imformation_from_memory(op1)
        if memory_imf["index"] != "":
            sib = True                                                                                          
        elif memory_imf["base"] == "":
            r_m = "101"
        else:
            r_m = register_64_code_dic[memory_imf["base"]][1::]

        if memory_imf["disp"]!="" and memory_imf["base"]+memory_imf["index"] == "":
            r_m = "100"
            sib =  True
        if memory_imf["disp"] == "" or memory_imf["disp"] == "0x0":
            mod = '00'
        elif memory_imf ["disp_size"] == 8:
            mod = '01'
        elif memory_imf ["disp_size"] == 32:
            mod = '10'
        else:
            mod = '11'
        
        if memory_imf["base"]!="":
            if(memory_imf["disp"]=="" and memory_imf["base"][len(memory_imf["base"])-2::]=="bp"):
                mod = '01'        
        else:
            mod = '00'

        if sib:
            sib_code = handle_sib(op1)
            r_m = "100"
            return mod + reg_op + r_m + sib_code       
    return mod+reg_op+r_m

def REX_for_single_oprand(op1):
    rex_R = '0'
    rex_B = '0'
    rex_W = '0'
    rex_X = '0'
    if (check_oprand_type(op1) == "register"):
        rex_B = register_64_code_dic[op1][0]
        if op1 in register_64_bit_list:
            rex_W = '1'
                  
    if (check_oprand_type(op1) =="memory"):
        op1_data = imformation_from_memory(op1)
        if op1_data["base"] != "":
            rex_B = register_64_code_dic[op1_data["base"]][0]
        if op1_data["index"] != "":
            rex_X = register_64_code_dic[op1_data["index"]][0]
        if op1_data["size"] == 64:
            rex_W = '1'
    if rex_W + rex_R + rex_X + rex_B != '0000':
        return '0100'+ rex_W + rex_R + rex_X + rex_B

    return False

def handle_imm_data(op2):
    lst = []
    re = ""
    if "0x" in op2:
        op2 = op2[2::]
    else:
        op2 = hex(int(op2))[2::]
    decimal_num = int(op2,16)
    if len(op2)%2==1:
        op2 = "0" + op2
    for i in range(0,len(op2),2):
        lst.append(op2[i:i+2])
    lst.reverse()
    re = ''.join(lst)
    return re



expresion = input()

oprator = expresion.split(" ")[0]

re = "" 
if oprator in ["ret", "stc", "clc", "std", "cld","syscall"]:
    with_out_oprand_oprator_dic = {'ret':'11000011','stc':'11111001','clc':'11111000',
                                   'std':'11111101', 'cld':'11111100','syscall':'0000111100000101'}
    print(convert_to_hex (with_out_oprand_oprator_dic[oprator]))
    exit(0)

if "," in expresion:
    oprand1 , oprand2 = expresion[len(oprator)+1::].split(",")[0], expresion[len(oprator)::].split(",")[1]
    oprand1_type = check_oprand_type(oprand1)
    oprand1_size = check_oprand_size(oprand1)
    oprand2_type = check_oprand_type(oprand2)
    oprand2_size = check_oprand_size(oprand2)

    if (oprator=="shr" or oprator=="shl") and "," in expresion:
        if oprand1_type == "memory":
            if address_prefix(oprand1):
                re += '01100111'
            if imformation_from_memory(oprand1)["size"] == 16:
                re += '01100110'
            if REX_for_single_oprand(oprand1) != False:
                re += REX_for_single_oprand(oprand1)+ find_opcode_for_single_oprand("shm",oprand1) + find_mod_for_single_oprand(oprator,oprand1)
            else:
                re += find_opcode_for_single_oprand("shm",oprand1) + find_mod_for_single_oprand(oprator,oprand1)
            print(convert_to_hex(re)+handle_disp(oprand1)++ handle_imm_data(oprand2))

        else:
            if(oprand2=="1"):
                opr_sh = "sh1"
            else:
                opr_sh = "shm"
            if oprand_prefix(check_oprand_size(oprand1)):
                re += '01100110'
            if REX_for_single_oprand(oprand1) != False:
                re +=REX_for_single_oprand(oprand1)+ find_opcode_for_single_oprand(opr_sh,oprand1)+find_mod_for_single_oprand(oprator,oprand1)
            else:
                re += find_opcode_for_single_oprand(opr_sh,oprand1)+ find_mod_for_single_oprand(oprator,oprand1) 
            if oprand2 =="1":
                print(convert_to_hex(re))
            else:
                print(convert_to_hex(re) + handle_imm_data(oprand2))
        
        exit(0)


    elif (oprand1_type == "register" and oprand2_type == "register"):
        if oprand_prefix(oprand1_size):
            re += '01100110'
        if handle_REX(oprator , oprand1 , oprand2) != False:
            re += handle_REX(oprator, oprand1,oprand2) + find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand1,oprand2)
            print(convert_to_hex(re))

        else:
            re += find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand1,oprand2)
            print(convert_to_hex(re))

    elif (oprand1_type == "register" and oprand2_type == "immediate"):
        if oprand_prefix(oprand1_size):
            re += '01100110'

        if handle_REX(oprator , oprand1 , oprand2) != False:
            re += handle_REX(oprator, oprand1,oprand2) + find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand1,oprand2)
            print(convert_to_hex(re)+handle_data(oprand1,oprand2))

        else:
            re += find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand1,oprand2)
            print(convert_to_hex(re)+handle_data(oprand1,oprand2))

    elif (oprand1_type == "register" and oprand2_type == "memory"):
        if address_prefix(oprand2):
            re += '01100111'
        if oprand_prefix(oprand1_size):
            re += '01100110'
        if handle_REX(oprator,oprand1,oprand2) !=False:
            re += handle_REX(oprator,oprand1,oprand2)+ find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand1,oprand2)
        else:
            re += find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand1,oprand2)
        print(convert_to_hex(re)+handle_disp(oprand2))

    elif (oprand2_type == "register" and oprand1_type == "memory"):
        if address_prefix(oprand1):
            re += '01100111'
        if oprand_prefix(oprand2_size):
            re += '01100110'
        if handle_REX(oprator,oprand2,oprand1) !=False:
            re += handle_REX(oprator,oprand2,oprand1)+ find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand2,oprand1)
        else:
            re += find_opcode_for_two_oprand(oprator,oprand1,oprand2) + handle_mod_r_m(oprator,oprand2,oprand1)
        print(convert_to_hex(re)+handle_disp(oprand1))


else:
    oprand1 = expresion[len(oprator)+1::].split(",")[0]
    oprand1_type = check_oprand_type(oprand1)
    
    if (oprand1_type=="register"):
        if oprand_prefix(check_oprand_size(oprand1)):
            re += '01100110'
        if REX_for_single_oprand(oprand1) != False:
            re +=REX_for_single_oprand(oprand1)+ find_opcode_for_single_oprand(oprator,oprand1)+find_mod_for_single_oprand(oprator,oprand1)
        else:
            re += find_opcode_for_single_oprand(oprator,oprand1)+ find_mod_for_single_oprand(oprator,oprand1) 
        print(convert_to_hex(re))

    elif (oprand1_type=="memory"):
        if address_prefix(oprand1):
            re += '01100111'
        if imformation_from_memory(oprand1)["size"] == 16:
            re += '01100110'
        if REX_for_single_oprand(oprand1) != False:
            re += REX_for_single_oprand(oprand1)+ find_opcode_for_single_oprand(oprator,oprand1) + find_mod_for_single_oprand(oprator,oprand1)
        else:
            re += find_opcode_for_single_oprand(oprator,oprand1) + find_mod_for_single_oprand(oprator,oprand1)
        print(convert_to_hex(re)+handle_disp(oprand1))
