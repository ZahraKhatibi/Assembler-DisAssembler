scale_decode_dic = { "00":"1", "01":"2", "10":"4", "11":"8"}
register_64_code_dic = {
    "0000":["al","ax","eax","rax"], "0001":["cl","cx","ecx","rcx"], "0010":["dl","dx","edx","rdx"], "0011":["bl","bx","ebx","rbx"],
    "0100":["ah","sp","esp","rsp"], "0101":["ch","bp","ebp","rbp"], "0110":["dh","si","esi","rsi"], "0111":["bh","di","edi","rdi"],
    "1000":["r8b","r8w","r8d","r8"], "1001":["r9b","r9w","r9d","r9"], "1010":["r10b","r10w","r10d","r10"], "1011":["r11b","r11w","r11d","r11"],
    "1100":["r12b","r12w","r12d","r12"], "1101":["r13b","r13w","r13d","r13"], "1110":["r14b","r14w","r14d","r14"], "1111":["r15b","r15w","r15d","r15"],
    "0":["","","",""]}
    
mem_str = {0:"BYTE PTR [", 1:"WORD PTR [", 2:"DWORD PTR [", 3:"QWORD PTR ["}

def find_oprator (imf_dec):
    oprator_code_dic = {"100010":"mov" ,"000000": "add" ,"000100": "adc" , "001010":"sub" , "000110":"sbb" ,"001000":"and" , "000010":"or" ,
                           "001100":"xor" , "001110" :"cmp" , "100001":"test" , "100001":"xchg" ,"111111" :"inc", "111101": "neg" ,"111101":"not",
                           "110100":"shr", "110100":"shl","111101":"idiv", "111111":"dec"}
    imf_dec["num_of_oprand"] = -1
    imf_dec["immd8"] = False
    imf_dec["oprator"] = ''

    if imf_dec["3byte_opcode"]:
        oprator_code_dic = {"00001111101011":"imul", "00001111110000":"xadd" }
        if imf_dec["op_code"]+imf_dec["op_D"]+imf_dec["op_w"] == '0000111110111100':
            imf_dec["oprator"] = "bsf"

        elif imf_dec["op_code"]+imf_dec["op_D"]+imf_dec["op_w"] == '0000111110111101':
            imf_dec["oprator"] = "bsr"

        else:
            imf_dec["oprator"] = oprator_code_dic[imf_dec["op_code"]]

    elif imf_dec["mov_alter"]:
        imf_dec["oprator"] = 'mov'

    elif imf_dec["op_code"] not in ["10000","110000"]:

        imf_dec["oprator"] = oprator_code_dic[imf_dec["op_code"]]
        if imf_dec["op_code"] == "110001" and imf_dec["reg_o"] == "000":    imf_dec["oprator"] ="mov"
        if imf_dec["op_code"] == "111111":
            if imf_dec["reg_o"] == "000":   imf_dec["oprator"] = "inc"
            if imf_dec["reg_o"] == "001":   imf_dec["oprator"] = "dec"   
        if imf_dec["op_code"] == "100001":
            if imf_dec["op_D"] == "0" :   imf_dec["oprator"] = "test"
            else :   imf_dec["oprator"] = "xchg"   
        if imf_dec["op_code"] == "111101":
            if imf_dec["reg_o"] == "011":   imf_dec["oprator"] = "neg"
            if imf_dec["reg_o"] == "010":   imf_dec["oprator"] = "not"
            if imf_dec["reg_o"] == "111":   imf_dec["oprator"] = "idiv"

        if imf_dec["op_code"] == "110100":
            if imf_dec["reg_o"] == "100":   imf_dec["oprator"] = "shl"
            if imf_dec["reg_o"] == "101":   imf_dec["oprator"] = "shr"
    else:
        if imf_dec["op_code"] == "10000":
            if imf_dec["reg_o"] == "000":   imf_dec["oprator"] = "add"
            if imf_dec["reg_o"] == "001":   imf_dec["oprator"] = "or"
            if imf_dec["reg_o"] == "010":   imf_dec["oprator"] = "adc"
            if imf_dec["reg_o"] == "011":   imf_dec["oprator"] = "sbb"
            if imf_dec["reg_o"] == "100":   imf_dec["oprator"] = "and"
            if imf_dec["reg_o"] == "101":   imf_dec["oprator"] = "sub"
            if imf_dec["reg_o"] == "110":   imf_dec["oprator"] = "xor"
            if imf_dec["reg_o"] == "111":   imf_dec["oprator"] = "cmp"

        if imf_dec["op_code"] == "110000" and imf_dec["reg_o"] == "101":    imf_dec["oprator"] = "shr"
        if imf_dec["op_code"] == "110000" and imf_dec["reg_o"] == "100":    imf_dec["oprator"] = "shl"
        imf_dec["immd8"] = True

    if imf_dec["oprator"] in ["mov" ,"add" , "adc" , "sub" , "sbb" ,"and" ,"or" , "xor" , "cmp" , "test" , "xchg", "xadd" ,"imul","bsr","bsf"]:
        imf_dec["num_of_oprand"] = 2

    elif imf_dec["oprator"] in ["inc","neg", "not", "shr", "shl","idiv", "dec"]:
        imf_dec["num_of_oprand"] = 1
    return imf_dec

def reg_to_reg(imf_dic):

    reg_o = imf_dic["rex_r"] + imf_dic["reg_o"] 
    r_m = imf_dic["rex_b"] + imf_dic["r_m"]

    if    imf_dic["prefix_oprand"] == True :   index = 1
    elif      imf_dic["op_w"] == "0" and imf_dic["oprator"] != "bsf" :   index = 0
    elif    imf_dic["rex_w"] =="1":    index = 3 
    else:   index = 2
    
    if imf_dic["oprator"] in ["imul","bsf","bsr"]:
        reg_o,r_m = r_m , reg_o
    if imf_dic["num_of_oprand"]==2:
        if imf_dic["op_D"] =="0" or imf_dic["oprator"] in ["xchg","imul"] :
            print(imf_dic["oprator"]+" "+register_64_code_dic[r_m][index]+","+register_64_code_dic[reg_o][index])
        else:   
            print(imf_dic["oprator"]+" "+register_64_code_dic[reg_o][index]+","+register_64_code_dic[r_m][index])

    elif imf_dic["oprator"][0:2]=="sh":
        if imf_dic["op_code"]=="110100":    print(imf_dic["oprator"]+" "+register_64_code_dic[r_m][index]+",1")
        else: 
            print(imf_dic["oprator"]+" "+register_64_code_dic[r_m][index]+","+hex(int(imf_dic["shift_count"],16)))

    elif imf_dic["op_D"] =="1" or imf_dic["oprator"]=="test" :
        print(imf_dic["oprator"]+" "+register_64_code_dic[r_m][index])

def handle_disp(s):
    if s=="":
        return ""
    lst = []
    for i in range(0,len(s),2):
        lst.append(s[i:i+2])
    lst.reverse()
    re = ''.join(lst)
    re = hex(int(re,16))
    return re

def print_mem(imf_dic,index_reg,index_mem):
    if imf_dic["prefix_address"]==True:
        index_sib = 2
    else:
        index_sib = 3
    base,index,scale,r_m = "","","",""
    if (imf_dic["sib"]):
        reg_o =register_64_code_dic[imf_dic["rex_r"] + imf_dic["reg_o"]][index_reg]
        base =register_64_code_dic [imf_dic["rex_b"] + imf_dic["base"]][index_sib]
        index = register_64_code_dic[imf_dic["rex_x"] + imf_dic["index"]][index_sib]
        scale = imf_dic["scale"] 
    else:       
        reg_o = register_64_code_dic[imf_dic["rex_r"] + imf_dic["reg_o"]][index_reg]
        r_m = register_64_code_dic[imf_dic["rex_b"] + imf_dic["r_m"]][index_sib]
        base = r_m

    if imf_dic["base_flg"] and imf_dic["disp"] !="" : base =""
    disp = handle_disp(imf_dic["disp"])
    if scale =="":  scale = "00"
    if index !="":  index = index +"*"+scale_decode_dic[imf_dic["scale"]]
    if disp !="" and index+base!="":   disp = "+"+disp
    if base !="" and index !="":    index = "+"+index
    if imf_dic["num_of_oprand"]==2:
        if base != "":
            if imf_dic["op_D"]=="1" or imf_dic["oprator"] in ["bsf","bsr"]: print(imf_dic["oprator"]+" "+ reg_o +","+mem_str[index_mem]+base+index+disp+"]")
            else:  print(imf_dic["oprator"]+" "+mem_str[index_mem]+base+index+disp+"]"+","+reg_o)
        else:
            if imf_dic["op_D"]=="1" or imf_dic["oprator"] in ["bsf","bsr"]:   print(imf_dic["oprator"]+" "+ reg_o +","+mem_str[index_mem]+index+disp+"]")
            else:   print(imf_dic["oprator"]+" "+mem_str[index_mem]+index+disp+"]" +"," + reg_o)
    else:
        
        if base != "":
            if imf_dic["oprator"][0:2]=="sh":
                print(imf_dic["oprator"]+" "+mem_str[index_mem]+base+index+disp+"]"+",1")
            else: print(imf_dic["oprator"]+" "+mem_str[index_mem]+base+index+disp+"]")
        else:
            if imf_dic["oprator"][0:2]=="sh": print(imf_dic["oprator"]+" "+mem_str[index_mem]+index+disp+"]"+",1")
            else:   print(imf_dic["oprator"]+" "+mem_str[index_mem]+index+disp+"]")

def mem_to_reg(imf_dic):

    if      imf_dic["prefix_oprand"] == True :   index_reg = 1
    elif    imf_dic["op_w"] == "0" and imf_dic["oprator"] != "bsf" :   index_reg = 0
    elif    imf_dic["rex_w"] =="1":    index_reg = 3 
    else:   index_reg = 2
     
    print_mem(imf_dic,index_reg,index_reg)

def convert_to_bin(exp):
    re = ''
    for i in range(0,len(exp)):
        b = bin(int(exp[i],16))[2::]
        if len(b)<4:
            b = (4-len(b))*"0" + b
        re += b
    return re

imformation_dic = {"prefix_address":False , "prefix_oprand":False , "rex":False, "rex_w":"0" , "rex_r":"0", "rex_x":"0" , "rex_b":"0" ,
                   "op_code":"", "op_D":"" , "op_w":"", "mod":"", "reg_o":"","r_m":"" , "mov_alter":False , "3byte_opcode":False,
                   "shift_count":"", "sib":False , "disp":"", "scale":"","index":"","base":"","base_flg":False}
exprestion = input()

if convert_to_bin(exprestion) in ['11000011','11111001','11111000','11111101','11111100','0000111100000101']:
    with_out_oprand_oprator_dic = {'11000011':'ret','11111001':'stc','11111000':'clc', '11111101':'std','11111100':'cld','0000111100000101':'syscall'}
    print(with_out_oprand_oprator_dic[convert_to_bin(exprestion)])
    exit(0)
if exprestion[0:2]=="67":
    imformation_dic["prefix_address"] = True
    exprestion = exprestion[2::]

if exprestion[0:2]=="66":
    imformation_dic["prefix_oprand"] = True
    exprestion = exprestion[2::]

if exprestion[0]=="4":
    REX_BYTE = convert_to_bin( exprestion[1])
    imformation_dic["rex"] = True
    imformation_dic["rex_w"] = REX_BYTE[0]
    imformation_dic["rex_r"] = REX_BYTE[1]
    imformation_dic["rex_x"] = REX_BYTE[2]
    imformation_dic["rex_b"] = REX_BYTE[3]
    exprestion = exprestion[2::]

if exprestion[0]=="b":
    imformation_dic["mov_alter"] = True
    OP_BYTE = convert_to_bin( exprestion[0:2])
    imformation_dic["op_code"]  = OP_BYTE[0:4]
    imformation_dic["op_D"] = OP_BYTE[4]
    imformation_dic["op_w"] = OP_BYTE[5]
    imformation_dic["reg_o"] = OP_BYTE[5::]  
    exprestion = exprestion[2::]


elif exprestion[0:2]=="0f":
    imformation_dic["3byte_opcode"] = True
    OP_BYTE = convert_to_bin( exprestion[0:4])
    imformation_dic["op_code"] = OP_BYTE[0:14]
    imformation_dic["op_D"] = OP_BYTE[14]
    imformation_dic["op_w"]= OP_BYTE[15]
    exprestion = exprestion[4::]

else:
    OP_BYTE = convert_to_bin( exprestion[0:2])
    imformation_dic["op_code"]= OP_BYTE[0:6]
    imformation_dic["op_D"] = OP_BYTE[6]
    imformation_dic["op_w"] = OP_BYTE[7]
    exprestion = exprestion[2::]

if(True):
    MOD_BYTE = convert_to_bin( exprestion[0:2])
    imformation_dic["mod"] = MOD_BYTE[0:2]
    imformation_dic["reg_o"] = MOD_BYTE[2:5]
    imformation_dic["r_m"] = MOD_BYTE[5::]
    exprestion = exprestion[2::]
imformation_dic = find_oprator(imformation_dic)

if  imformation_dic["mod"] =="11":
    if imformation_dic["oprator"][0:2]=="sh":
        imformation_dic["shift_count"] = exprestion[0::]
    reg_to_reg(imformation_dic)
    exit(0)

if imformation_dic["r_m"] =="100":
    imformation_dic["sib"] = True
    SIB_BYTE = convert_to_bin( exprestion[0:2])
    imformation_dic["scale"] = SIB_BYTE[0:2]
    imformation_dic["index"] = SIB_BYTE[2:5]
    imformation_dic["base"] = SIB_BYTE[5::]
    imformation_dic["disp"] = exprestion[2::]
    exprestion = exprestion[2::]
    if imformation_dic["mod"] == "00":  imformation_dic["base_flg"] = True
else:
    if imformation_dic["mod"] == "00" :
        imformation_dic["base"] =imformation_dic["r_m"]
    else:
        imformation_dic["base"] = imformation_dic["r_m"]
        imformation_dic["disp"] = exprestion[0::]

if imformation_dic["mod"] !="00" or (imformation_dic["mod"] =="00" and imformation_dic["index"]+imformation_dic["base"] == ""):
    imformation_dic["disp"] = exprestion[0::]
#print(imformation_dic)
mem_to_reg(imformation_dic)
