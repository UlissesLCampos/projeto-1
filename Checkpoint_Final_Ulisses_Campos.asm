; ULISSES LOMBARDI CAMPOS - NUSP 14781443
; Entrega final 


; Nesta entrega final, o programa controla o motor, conta as voltas pelo Timer 1 e também trata a mudança de direção. O Timer 1 foi usado como contador externo, recebendo os pulsos do sensor do motor no pino T1, que no 8051 corresponde ao P3.5. A contagem aparece no display de 7 segmentos e volta para zero quando chega em 10 voltas. Além disso, quando a chave SW0 muda, o motor troca de sentido e a contagem também é reiniciada.

CONT_VOLTAS EQU 40H        
; Variável usada para guardar a contagem atual
; Foi colocada em 40H para não usar a área da pilha

ORG 0000H
AJMP START                 
; Ao ligar ou resetar, o programa começa em START

ORG 001BH
AJMP ISR_TIMER1            
; Vetor de interrupção do Timer 1

ORG 0033H                  
; Início do programa principal


START:
MOV SP, #2FH              
; Define a pilha a partir de 30H

MOV P2, #0FFH              
; P2 será usado para leitura da chave SW0
MOV P1, #0FFH              
; Começa com o display apagado

; Configuração do display no EdSim51
SETB P0.7                  
; Habilita o decoder dos displays
CLR P3.3                   
; Seleciona o display 0
CLR P3.4                   
; Seleciona o display 0

; Estado inicial dos pinos usados no motor
CLR P3.0
CLR P3.1
SETB P3.5                  
; P3.5 é o T1, onde chegam os pulsos do sensor

CLR F0                     
; F0 guarda o sentido atual do motor
MOV CONT_VOLTAS, #00H      
; A contagem começa em zero

; TMOD = 50H configura o Timer 1 como contador externo no modo 1.Ele conta os pulsos externos que chegam pelo pino T1/P3.5.
MOV TMOD, #50H
ACALL RESET_TIMER1         
; Inicializa o contador já no valor correto

SETB ET1                   
; Habilita a interrupção do Timer 1
SETB EA                    
; Habilita as interrupções de forma geral

ACALL APLICA_DIRECAO       
; Aplica o sentido inicial do motor
ACALL ATUALIZA_DISPLAY     
; Mostra o zero no display


MAIN:
ACALL VERIFICA_CHAVE       
; Verifica se a chave SW0 mudou de posição

; Como o Timer 1 foi carregado com FFF6H, TL1 começa em F6H. Assim, quando TL1 vale F6H, a contagem real é 0. Quando vale F7H, a contagem é 1, e assim por diante até chegar em 9.

MOV A, TL1
CLR C
SUBB A, #0F6H
MOV CONT_VOLTAS, A

ACALL ATUALIZA_DISPLAY     
; Atualiza o número mostrado no display
SJMP MAIN                  
; Repete continuamente


; Rotina de interrupção do Timer 1. Como o contador começa em FFF6H, depois de 10 pulsos ele estoura.Quando ocorre o overflow, a interrupção é chamada e a contagem volta para zero.

ISR_TIMER1:
CLR TR1                    
; Para o contador para fazer o reset com segurança
MOV TH1, #0FFH             
; Recarrega a parte alta do contador
MOV TL1, #0F6H             
; Recarrega a parte baixa para contar 10 pulsos
MOV CONT_VOLTAS, #00H      
; Zera a variável mostrada no display
CLR TF1                    
; Limpa a flag de overflow do Timer 1
SETB TR1                   
; Liga novamente o contador
RETI                       
; Retorna da interrupção


; Esta rotina zera/reinicia o Timer 1. Ela é usada tanto no começo do programa quanto quando o motor muda de direção.

RESET_TIMER1:
CLR TR1
MOV TH1, #0FFH
MOV TL1, #0F6H
MOV CONT_VOLTAS, #00H
CLR TF1
SETB TR1
RET


; Esta rotina lê a chave SW0 em P2.0. Se a posição da chave for diferente do sentido salvo em F0, então é chamada a rotina de mudança de direção.

VERIFICA_CHAVE:
JB P2.0, CHAVE_ZERO        
; Se P2.0 = 1, considera estado 0
SETB C                     
; Se P2.0 = 0, considera estado 1
SJMP COMPARA_ESTADO

CHAVE_ZERO:
CLR C                      
; Carry recebe 0

COMPARA_ESTADO:
MOV A, #00H
JNB F0, F0_ZERO
INC A                      
; Se F0 = 1, A passa a valer 1

F0_ZERO:
JNC TESTA_ZERO             
; Se Carry = 0, testa estado zero
CJNE A, #01H, TROCA
RET                        
; Se já está no estado certo, não muda nada

TESTA_ZERO:
CJNE A, #00H, TROCA
RET

TROCA:
ACALL MUDA_DIRECAO
RET


; Esta rotina atualiza o sentido salvo em F0, aplica esse sentido nos pinos do motor e reinicia a contagem. O reset é importante para não somar voltas de sentidos diferentes.

MUDA_DIRECAO:
MOV F0, C
ACALL APLICA_DIRECAO
ACALL RESET_TIMER1
RET


; Define os estados de P3.0 e P3.1, que controlam o sentido do motor.
APLICA_DIRECAO:
JNB F0, SENTIDO_ZERO

CLR P3.0                   
; Sentido 1
SETB P3.1
RET

SENTIDO_ZERO:
SETB P3.0                  
; Sentido 0
CLR P3.1
RET


; Atualiza o display de 7 segmentos. Primeiro busca o padrão do número na tabela usando MOVC. Depois ajusta o ponto decimal de acordo com o sentido do motor.

ATUALIZA_DISPLAY:
MOV A, CONT_VOLTAS
MOV DPTR, #TABELA_7SEG
MOVC A, @A+DPTR

; No display usado no EdSim51, os segmentos são ativos em nível baixo. Por isso, para acender o ponto decimal, o bit 7 deve ir para 0. Para apagar o ponto decimal, o bit 7 deve ficar em 1.

JNB F0, DP_APAGADO

ANL A, #07FH               
; Acende o ponto decimal para um sentido
SJMP ENVIA_DISPLAY

DP_APAGADO:
ORL A, #080H               
; Apaga o ponto decimal para o outro sentido

ENVIA_DISPLAY:
MOV P1, A
RET


; Tabela dos números de 0 a 9 no display de 7 segmentos. Como o display é de ânodo comum, os segmentos acendem com nível lógico 0.

TABELA_7SEG:
DB 0C0H                    ; 0
DB 0F9H                    ; 1
DB 0A4H                    ; 2
DB 0B0H                    ; 3
DB 099H                    ; 4
DB 092H                    ; 5
DB 082H                    ; 6
DB 0F8H                    ; 7
DB 080H                    ; 8
DB 090H                    ; 9

END