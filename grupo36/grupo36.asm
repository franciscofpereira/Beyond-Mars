
; * IST-UL
; * Modulo: grupo36.asm
;
; * Grupo 36, turno L07
;   
; * Alunos: 
;           * Francisco Ferro Pereira - 107502           
;           * Tiago Bernardo - 107546
;           * Miguel Martins - 105935 
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
COMANDOS   EQU	6000H    ; endereço de base dos comandos do MediaCenter

; Comandos Hardware
DISPLAYS   EQU 0A000H    ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H    ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H    ; endereço das colunas do teclado (periférico PIN)
TECLA_C    EQU 0CH       ; endereço da tecla C
TECLA_D    EQU 0DH       ; endereço da tecla D
TECLA_E    EQU 0EH       ; endereço da tecla E
TECLA_0    EQU 0H        ; endereço da tecla 0
TECLA_1    EQU 1H        ; endereço da tecla 1
TECLA_2    EQU 2H        ; endereço da tecla 2
LINHA_INICIAL  EQU 1     ; valor da primeira linha do teclado
LINHA_FINAL EQU 8        ; valor da ultima linha do teclado

MASCARA    EQU 0FH       ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_BITS_ALEATORIOS EQU 0F0H

; Comandos MediaCenter
TOCA_SOM	        EQU COMANDOS + 5AH		; endereço do comando para tocar um som
TOCA_VIDEO          EQU COMANDOS + 5CH
SOBREPOE_IMAGEM     EQU COMANDOS + 46H
APAGA_IMAGEM_SOBREPOSTA EQU COMANDOS + 44H
PAUSA_VIDEO         EQU COMANDOS + 62H
DESPAUSA_VIDEO      EQU COMANDOS + 64H
PAUSA_VIDEO_ESPECIFICO EQU COMANDOS + 5EH
REPETE_VIDEO        EQU COMANDOS + 56H
TERMINA_VIDEO       EQU COMANDOS + 66H
DEFINE_LINHA    	EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   	EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
ESCOLHE_ECRÃ        EQU COMANDOS + 04H      ; escolhe o ecrã onde se quer desenhar
APAGA_AVISO     	EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 	    EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
MOSTRA_ECRÃ         EQU COMANDOS + 06H
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo


; imagens de fundo Media Center
FUNDO_PRINCIPAL_JOGO  EQU 0
ECRA_PAUSA            EQU 1
ECRA_PERDEU_COLISAO   EQU 2
ECRA_PERDEU_ENERGIA   EQU 3
ECRA_TERMINA_JOGO     EQU 4

; videos/sons Media Center
SOM_DISPARO           EQU 0
SOM_INICIO_JOGO       EQU 1
VIDEO_TITLE_SCREEN    EQU 2
MUSICA_TITLE_SCREEN   EQU 3
FALTA_ENERGIA_SOM     EQU 4
COLIDE_NAVE_SOM       EQU 5
MUSICA_DURANTE_JOGO   EQU 6
SOM_EXPLOSAO_ASTEROIDE EQU 7
SOM_EXPLOSAO_MINERAVEL EQU 8
SOM_PAUSA              EQU 9
SOM_TERMINA_JOGO       EQU 10
 

; Variáveis de estado do jogo
MAIN_MENU               EQU 0
JOGO                    EQU 1
PAUSADO                 EQU 2
TERMINADO               EQU 4

; Dados da nave
NUMERO_FRAMES       EQU  8    ; numero de frames que o processo da nave usa
LINHA_NAVE        	EQU  31   
COLUNA_NAVE			EQU  25 
LARGURA_NAVE		EQU	15  
ALTURA_NAVE         EQU 5
RETANGULO_NAVE_LINHA   EQU 28  ; para verificar a colisao DE UM ASTEROIDE diagonal
LINHA_MAX_NAVE         EQU 27   ; para verificar a colisao de um asteroide vertical
COLUNA_MAX_NAVE       EQU 39     ; limite da nave em termos da coluna

; Dados do asteroide
N_ASTEROIDES        EQU 4
LARGURA_ASTEROIDE   EQU 5
ALTURA_ASTEROIDE    EQU 5
LINHA_ASTEROIDE     EQU 4
COLUNA_ASTEROIDE    EQU 0
NUM_ASTEROIDES      EQU 4

; Identificador de tipo de asteroide
ASTEROIDE_MINERAVEL EQU 0
ASTEROIDE_NORMAL    EQU 1

; Indentificador de localização de spawn de asteroide
CANTO_SUPERIOR_ESQUERDO EQU 0
MEIO     EQU 1
CANTO_SUPERIOR_DIREITO  EQU 2

; Número de sondas
N_SONDAS           EQU 3

; Dados da sonda vertical
LARGURA_SONDA       EQU 1
ALTURA_SONDA        EQU 1
LINHA_SONDA_MEIO         EQU 26
COLUNA_SONDA_MEIO        EQU 32
ALTURA_DISPARO      EQU 30

; Dados da sonda esquerda
COLUNA_SONDA_ESQ        EQU 25
LINHA_SONDA_ESQ         EQU 26

; Dados da sonda direita
COLUNA_SONDA_DIR         EQU 39
LINHA_SONDA_DIR         EQU 26

MAX_MOV_SONDA    EQU  12 ; numero maximo de movimentos da sonda

; Movimento sonda
ESQUERDA              EQU -1
DIREITA               EQU 1
MANTEM                EQU 0

; Colunas das localizações de spawn de asteroides
COLUNA_CANTO_ESQUERDO EQU 0
COLUNA_MEIO EQU 30
COLUNA_CANTO_DIREITO EQU 59

; Sinais para o controlo_jogo 
COMECAR                EQU 0       ; sinal para controlo_jogo comecar o jogo
ESGOTOU_ENERGIA        EQU 1       ; sinal para controlo_jogo, jogo é perdido por falta de energia
PERDEU_COLISAO         EQU 2       ; sinal para controlo_jogo, jogo é perdido por colisao
REINICIAR              EQU 3       ; sinal para controlo_jogo, reiniciar o jogo
PAUSAR                 EQU 4       ; sinal para controlo_jogo, pausar o jogo
DESPAUSAR              EQU 5       ; sinal para o processo de controlo, despausar o jogo
TERMINAR               EQU 6       ; sinal para o processo de controlo, terminar o jogo

; Sinais processo_sonda
SONDA_ATIVA         EQU 1
SONDA_DESATIVA      EQU 0

; Energia
ENERGIA_SONDA    EQU -5   ;valor a colocar na variavel LOCK_ENERGIA caso uma sonda seja disparada
ENERGIA_NAVE     EQU -3   ;valor a colocar na variavel LOCK_ENERGIA na rotina de interrupcao da energia
ENERGIA_ASTEROIDE  EQU 25 ; valor e negativo porque o processo 
ENERGIA_INICIAL   EQU  100  ; valor da energia quando se comeca o jogo

; Cores
COR_NAVE1       	EQU 0FF00H			; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_NAVE3           EQU 0F0DBH          ; terceira cor da nave (azul claro )     
COR_NAVE4           EQU 0FFFFH          ; quarta cor da nave (branco)
COR_NAVE5           EQU 0C07CH          ; quinta cor da nave (azul escuro)
COR_ASTEROIDE       EQU 0FAAAH          ; cor do asteroide (cinzento)
CINZENTO_ESCURO     EQU 08ACCH
COR_APAGADO         EQU 00000H          ; cor para apagar pixel, todas as componentes a zero
COR_SONDA           EQU 0F83FH          ; cor da sonda disparada pela nave
LARANJA             EQU 0FF70H          ; laranja das chamas da nave

; Dados ecrã
MIN_COLUNA          EQU 0  ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA          EQU 63 ; número da coluna mais à direita que o objeto pode ocupar
MIN_LINHA           EQU 0  ; número da linha mais acima que o objeto pode ocupar
MAX_LINHA           EQU 31 ; número da linha mais abaixo que o objeto pode ocupar

TAMANHO_PILHA EQU 100H 


; **********************************************************************
; * Variaveis
; **********************************************************************

PLACE 1000H

; Reserva do espaço para as pilhas dos processos
	STACK 100H			            ; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:              ; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			            ; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:		            ; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H * N_ASTEROIDES	    ; espaço reservado para a pilha do processo "asteroide"
SP_inicial_asteroide:	            ; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H * N_SONDAS			; espaço reservado para a pilha do processo "asteroide"
SP_inicial_sonda:	                ; este é o endereço com que o SP deste processo deve ser inicializado
    STACK 100H
SP_inicial_controlo:

    STACK 100H                      ; espaço reservado para a pilha do processo "energia"
SP_INICIAL_ENERGIA:                 ; este é o endereço com que o SP deste processo deve ser inicializado

    STACK 100H                      ; espaço reservado para a pilha do processo "comunica_ação_controlo"
SP_inicial_comunica_ação_controlo:  ; este é o endereço com que o SP deste processo deve ser inicializado

    STACK 100H                      ; espaço reservado para a pilha do processo "nave"
SP_inicial_nave:                    ; este é o endereço com que o SP deste processo deve ser inicializado


lock_inicia_jogo:                   ; LOCK do processo main que reinicia o jogo
    LOCK 0

lock_tecla:
	LOCK 0				            ; LOCK para o teclado comunicar aos restantes processos que tecla detetou

lock_energia:                       ; LOCK para a energia comunicar aos restantes processos que a interrupção ocorreu
    LOCK 0

lock_asteroide:                     ; LOCK para a rotina de interrupção comunicar ao processo asteroide que a interrupção ocorreu
	LOCK 0              

TRANCA_ASTEROIDE:                   ; LOCK para bloquear o processo asteroide (não está correlacionado com a interrupção)
    LOCK 0

lock_sonda:
    LOCK 0                          ; LOCK para as teclas que disparam as sondas 
    LOCK 0
    LOCK 0 

lock_controlo:          ;  LOCK para o controlo do programa comunicar aos restantes processos 
    LOCK 0

lock_sonda_int:         ; LOCK para a rotina de interrupção comunicar ao processo sonda que a interrupção ocorreu
    LOCK 0

lock_nave:
	LOCK 0				; LOCK para a interrupcao comunicar com o processo nave que esta ocorreu


; Variáveis TECLADO/DISPLAY
N_LINHA: WORD 0H        ;  variavel que guarda o valor da linha (0-3) que foi premida
N_COLUNA: WORD 0H       ;  variavel que guarda o valor da coluna (0-3) que foi premida
CONTADOR: WORD 0H       ;  variavel que contem o contador a mostrar no display


; tabelas de pixeis de referência sonda
linha_sonda_inicial:        ; tabela que guarda as linhas iniciais das sondas (utilizada para reiniciar os valores)
    WORD LINHA_SONDA_ESQ
    WORD LINHA_SONDA_MEIO
    WORD LINHA_SONDA_DIR

coluna_sonda_inicial:       ; tabela que guarda as colunas iniciais das sondas (utilizada para reiniciar os valores)
    WORD COLUNA_SONDA_ESQ
    WORD COLUNA_SONDA_MEIO
    WORD COLUNA_SONDA_DIR

linha_sonda:                ; tabela que guarda as linhas da sonda correntes
    WORD LINHA_SONDA_ESQ
    WORD LINHA_SONDA_MEIO
    WORD LINHA_SONDA_DIR

coluna_sonda:               ; tabela que guarda as colunas da sonda correntes
    WORD COLUNA_SONDA_ESQ
    WORD COLUNA_SONDA_MEIO
    WORD COLUNA_SONDA_DIR

movimento_sonda:                ; movimento da sonda em termos da linha e depois da coluna
    WORD  ESQUERDA, ESQUERDA    ; movimento sonda esquerda
    WORD  ESQUERDA, MANTEM      ; movimento sonda meio
    WORD  ESQUERDA, DIREITA     ; movimento sonda direita

estado_sonda:               ; contem as variaveis de estado que indicam se uma sonda esta ativa ou nao de uma determinada instancia
    WORD SONDA_DESATIVA
    WORD SONDA_DESATIVA
    WORD SONDA_DESATIVA

colidiu_asteroide:
    WORD 0
    WORD 0
    WORD 0

; frames da nave
DEF_NAVE_1:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, LARANJA, 0, 0, 0, COR_NAVE1, 0, 0, 0, LARANJA, 0, 0, 0
    WORD    0, 0, LARANJA, COR_NAVE1, COR_NAVE1, 0, LARANJA, COR_NAVE1, COR_NAVE1, 0, LARANJA, LARANJA, COR_NAVE1, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE,COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

DEF_NAVE_2:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, COR_NAVE1, 0, 0, 0, LARANJA, 0, 0, 0, COR_NAVE1, 0, 0, 0
    WORD    0, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, COR_NAVE1, LARANJA, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

DEF_NAVE_3:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, COR_NAVE1, LARANJA, 0, 0
    WORD    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

DEF_NAVE_4:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    WORD    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

DEF_NAVE_5:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    WORD    0, 0, 0, COR_NAVE1, 0, 0, 0, LARANJA, 0, 0, 0, COR_NAVE1, 0, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

DEF_NAVE_6:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, COR_NAVE1, 0, 0, 0, LARANJA, 0, 0, 0, COR_NAVE1, 0, 0, 0
    WORD    0, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, COR_NAVE1, LARANJA, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0
DEF_NAVE_7:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, LARANJA, 0, 0, 0, COR_NAVE1, 0, 0, 0, LARANJA, 0, 0, 0
    WORD    0, 0, LARANJA, COR_NAVE1, COR_NAVE1, 0, LARANJA, COR_NAVE1, COR_NAVE1, 0, LARANJA, LARANJA, COR_NAVE1, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

DEF_NAVE_8:
    WORD LARGURA_NAVE
    WORD ALTURA_NAVE
    WORD    0, 0, 0, COR_NAVE1, 0, 0, 0, LARANJA, 0, 0, 0, COR_NAVE1, 0, 0, 0
    WORD    0, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, LARANJA, LARANJA, 0, COR_NAVE1, COR_NAVE1, LARANJA, 0, 0
    WORD    COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE3, COR_NAVE5, COR_NAVE3, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4
    WORD    0, COR_NAVE4, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE5, COR_NAVE3, COR_NAVE5, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_NAVE4, 0
    WORD    0, 0, 0, 0, 0, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, CINZENTO_ESCURO, 0, 0, 0, 0, 0

; desenho do asteroide não minerável (asteroide cinzento)
DEF_ASTEROIDE:
    WORD LARGURA_ASTEROIDE
    WORD ALTURA_ASTEROIDE
    WORD 0, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, 0
    WORD COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE
    WORD COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE
    WORD COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE
    WORD 0, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, 0

; desenho do asteroide minerável (asteroide vermelho)
DEF_ASTEROIDE_MINERAVEL:
    WORD LARGURA_ASTEROIDE
    WORD ALTURA_ASTEROIDE
    WORD COR_NAVE1, 0, COR_NAVE1, 0, COR_NAVE1
    WORD 0, COR_NAVE1,COR_NAVE1,COR_NAVE1,0
    WORD COR_NAVE1, COR_NAVE1, 0, COR_NAVE1, COR_NAVE1
    WORD 0, COR_NAVE1, COR_NAVE1, COR_NAVE1, 0
    WORD COR_NAVE1, 0, COR_NAVE1, 0, COR_NAVE1

; frame da animação da explosão do asteroide minerável
FRAME_MINERAVEL_EXPLOSAO:
    WORD LARGURA_ASTEROIDE
    WORD ALTURA_ASTEROIDE
    WORD 0, COR_NAVE3, 0, COR_NAVE3, 0
    WORD COR_NAVE3, 0, COR_NAVE3, 0, COR_NAVE3
    WORD 0, COR_NAVE3, 0, COR_NAVE3, 0
    WORD COR_NAVE3, 0, COR_NAVE3, 0, COR_NAVE3
    WORD 0, COR_NAVE3, 0, COR_NAVE3, 0

; frame 1 da animação da explosão do asteroide não minerável
FRAME_NORMAL_EXPLOSAO_1:
    WORD LARGURA_ASTEROIDE
    WORD ALTURA_ASTEROIDE
    WORD 0, 0, 0, 0, 0
    WORD 0, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, 0
    WORD 0, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, 0
    WORD 0, COR_ASTEROIDE, COR_ASTEROIDE, COR_ASTEROIDE, 0
    WORD 0, 0, 0, 0, 0

; frame 2 da animação da explosão do asteroide não minerável
FRAME_NORMAL_EXPLOSAO_2:
    WORD LARGURA_ASTEROIDE
    WORD ALTURA_ASTEROIDE
    WORD 0, 0, 0, 0, 0
    WORD 0, 0, 0, 0, 0
    WORD 0, 0, COR_ASTEROIDE, 0, 0
    WORD 0, 0, 0, 0, 0
    WORD 0, 0, 0, 0, 0

; desenho da sonda
DEF_SONDA:
    WORD LARGURA_SONDA
    WORD ALTURA_SONDA
    WORD COR_SONDA

; Tabela das rotinas de interrupção
tab:
    WORD interrupcao_asteroide      ; rotina de interrupção 0
    WORD interrupcao_sonda      ; rotina de interrupção 1
    WORD interrupcao_energia      ; rotina de interrupção 2
    WORD interrupcao_nave      ; rotina de interrupção 3

; tabela com os frames da animacao da nave
frames_nave:
    WORD DEF_NAVE_1
    WORD DEF_NAVE_2
    WORD DEF_NAVE_3
    WORD DEF_NAVE_4
    WORD DEF_NAVE_5
    WORD DEF_NAVE_6
    WORD DEF_NAVE_7 
    WORD DEF_NAVE_8

; tabela que contém o frame atual da nave
nave_atual:
    WORD frames_nave

; tabela que contém os frames da animação da explosão de um asteroide não minerável
frames_explosao_asteroide:
    WORD FRAME_NORMAL_EXPLOSAO_1
    WORD FRAME_NORMAL_EXPLOSAO_2

; variável de estado do programa (iniciada a MAIN_MENU)
ESTADO:
    WORD MAIN_MENU      ; variável que contém estado do jogo (inicializada com MAIN_MENU)


; **********************************************************************
; * Codigo
; **********************************************************************
PLACE      0H

inicio:		
    
    ; inicializacao do stack pointer 
    MOV SP, SP_inicial_prog_princ     ; inicializa SP para a palavra a seguir
    MOV BTE, tab            ; inicializa BTE (registo de Base da Tabela de Exceções)

    EI0					    ; permite interrupções 0 (asteroide)
	EI1					    ; permite interrupções 1 (sonda)
	EI2					    ; permite interrupções 2 (energia)
	EI3					    ; permite interrupções 3 (animacao da nave)
	EI					    ; permite interrupções (geral)
						    ; a partir daqui, qualquer interrupção que ocorra usa
						    ; a pilha do processo que estiver a correr nessa altura
    
    CALL controlo_jogo
    CALL teclado_processo
    CALL comunica_ação_controlo
    CALL processo_energia
    CALL processo_nave

    MOV R11, N_ASTEROIDES

loop_asteroides:                      ; cria o mesmo número de processos que o número de asteroides
    SUB    R11, 1                     ; próximo asteroide
    CALL   processo_asteroide         ; cria uma nova instância do processo_asteroide (o valor de R11 distingue-as)
                                      ; Cada processo fica com uma cópia independente dos registos
    CMP  R11, 0                       ; já criou as instâncias todas?
    JNZ    loop_asteroides            ; se não, continua

    MOV R11, N_SONDAS

loop_sondas:                          ; cria o mesmo número de processos que o número de sondas
	SUB	R11, 1			              ; próxima sonda
	CALL	processo_sonda			  ; cria uma nova instância do processo_sonda (o valor de R11 distingue-as)
						              ; Cada processo fica com uma cópia independente dos registos
	CMP  R11, 0			              ; já criou as instâncias todas?
    JNZ	loop_sondas		              ; se não, continua


    CALL jogo_setup                   ; coloca a tela de inicio de jogo 


inicia_jogo:
    MOV  R0, [lock_inicia_jogo]
    CALL jogo_setup                   ; coloca a tela de inicio de jogo quando o jogo e reiniciado
    JMP inicia_jogo

; **********************************************************************
; interrupcao_asteroide - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo asteroide lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
interrupcao_asteroide:

    PUSH R0 

    MOV R0, [ESTADO]
    CMP R0, PAUSADO
    JZ fim_int_asteroide       ; se estiver pausado nao faz nada

    MOV    [lock_asteroide], R0    ; desbloqueia processo asteroide (qualquer registo serve)

fim_int_asteroide:
    POP R0
    RFE

; **********************************************************************
; interrupcao_sonda - 	Rotina de atendimento da interrupção 1
;			Faz simplesmente uma escrita no LOCK que o processo sonda lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
interrupcao_sonda:

    PUSH R0 

    MOV R0, [ESTADO]
    CMP R0, PAUSADO
    JZ fim_int_sonda            ; se nao estiver no modo de jogo, a sonda nao vai mexer com a interrupcao
	MOV	[lock_sonda_int], R0	; desbloqueia o subprocesso da sonda (qualquer registo serve) 
fim_int_sonda:
    POP R0
	RFE

;**********************************************************************
; interrupcao_energia - Rotina de atendimento da interrupção 2
;            Faz uma escrita no LOCK que o processo da energia e verifica se estamos no modo jogo.
;            comunica com o processo da energia, ja que quando o desbloqueia
;            coloca o valor a decrementar na variavel lock
; **********************************************************************

interrupcao_energia:
    PUSH R0
    MOV R0,[ESTADO]
    CMP R0, JOGO
    JNZ fim_int_energia
    MOV R0, ENERGIA_NAVE               ; coloca em R0 o valor a decrementar no display devido ao funcionamento da nave 
    MOV [lock_energia], R0    ; desbloqueia processo da energia que vai diminuir o display da enrgia

fim_int_energia:
    POP R0 
    RFE

;**********************************************************************
; interrupcao_nave - Rotina de atendimento da interrupção 3
;            Faz uma escrita no LOCK que o processo da energia e verifica se estamos no modo jogo.
;            comunica com o processo da energia, ja que quando o desbloqueia
;            coloca o valor a decrementar na variavel lock
; **********************************************************************

interrupcao_nave:
    PUSH R0
    MOV R0,[ESTADO]
    CMP R0, JOGO
    JNZ fim_int_nave
    MOV [lock_nave], R0    ; desbloqueia processo da energia que vai diminuir o display da enrgia

fim_int_nave:
    POP R0 
    RFE

; **********************************************************************
; Processo
;
; controlo_jogo - Processo que trata das teclas de comecar, pausar ou continuar
; e terminar o jogo. (Recebe sinais de outros processos para executar tarefas)
;
; **********************************************************************

PROCESS SP_inicial_controlo

; lê o valor no lock_controlo e consoante o valor, executa a tarefa correspondente
controlo_jogo:
    
    MOV R0, [lock_controlo]         ; lê o valor do lock_controlo

    MOV R1, COMECAR
    CMP R1, R0
    JZ  comeca_jogo                 ; se valor no lock_controlo é igual à constante de começar, começa jogo

    MOV R1, REINICIAR
    CMP R1, R0
    JZ reinicia_jogo                    ; se valor no lock_controlo é igual à constante de reiniciar, reinicia o jogo

    MOV R1, TERMINAR            
    CMP R1, R0
    JZ termina_jogo            ; se valor no lock_controlo é igual à constante de terminar, termina o jogo

    MOV R1, PAUSAR
    CMP R1, R0
    JZ pausa_jogo                   ; se valor no lock_controlo é igual à constante de pausar, pausa o jogo

    MOV R1, DESPAUSAR
    CMP R1, R0
    JZ despausa_jogo                 ; se valor no lock_controlo é igual à constante de despausar, despausa o jogo

    MOV R1, PERDEU_COLISAO
    CMP R1, R0
    JZ perdeu_por_colisao            ; se valor no lock_controlo é igual à colisao da nave com o asteroide, perde o jogo
               
    MOV R1, ESGOTOU_ENERGIA
    CMP R1, R0 
    JZ perdeu_falta_energia          ; se valor no lock_controlo é igual à perda do jogo por falta de energia, perde o jogo

    JMP controlo_jogo                ; salta de novo para o loop de controlo do programa 

comeca_jogo:
    
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

    MOV R9, SOM_INICIO_JOGO           
    MOV [TOCA_SOM], R9                      ; toca som de inicio de jogo

    MOV R1, VIDEO_TITLE_SCREEN
    MOV [TERMINA_VIDEO], R1                 ; retira title screen

    MOV R1, MUSICA_TITLE_SCREEN                       
    MOV [TERMINA_VIDEO], R1                 ; retira musica do title screen

    MOV R1, FUNDO_PRINCIPAL_JOGO
    MOV [SELECIONA_CENARIO_FUNDO], R1       ; passa para o ecrã de jogo

    MOV R1, JOGO
    MOV [ESTADO], R1                        ; atualiza o estado para jogo

    CALL inicializa_coordenadas_sonda       ; inicializa as variáveis das coordenadas da sonda 
    
    ;inicializa luzes da nave
    MOV R1, frames_nave
    MOV [nave_atual] ,R1                 ; inicaliza a variavel com o primeiro frame da nave
    MOV [lock_nave], R1                  ; desbloqueia logo o processo da nave para nao ter de esperar pela interrupcao para a desenhar

gera_objetos:

    MOV [TRANCA_ASTEROIDE], R0                ; desbloqueia o processo_asteroide

    MOV	R1, 6  ; carrega música de fundo
    MOV  [TOCA_VIDEO], R1	    ; toca a música de fundo do jogo

    JMP controlo_jogo

reinicia_jogo:
    
    MOV [lock_inicia_jogo], R0    ; desbloqueia o processo que inicia o jogo
    JMP controlo_jogo

pausa_jogo:
    MOV R1, SOM_PAUSA
    MOV [TOCA_SOM], R1 
    MOV R1, MUSICA_DURANTE_JOGO
    MOV [PAUSA_VIDEO_ESPECIFICO], R1 ; pausa a música durante o jogo quando em pausa
    MOV R0, ECRA_PAUSA
    MOV [SOBREPOE_IMAGEM], R0   ; sobrepoem o ecrã de pausa ao ecrã de jogo
    MOV R0, PAUSADO
    MOV [ESTADO], R0            ; atualiza estado para pausado
    JMP controlo_jogo

despausa_jogo:
    MOV R1, SOM_PAUSA
    MOV [TOCA_SOM], R1 
    MOV R1, MUSICA_DURANTE_JOGO
    MOV [DESPAUSA_VIDEO], R1 ; despausa a música durante o jogo quando se despausa o jogo
    MOV [APAGA_IMAGEM_SOBREPOSTA], R1     ; apaga o ecrã de pausa sobreposto
    MOV R0, JOGO                 
    MOV [ESTADO], R0          ; altera variável de estado para jogo
    JMP controlo_jogo

termina_jogo:
    
    MOV R1, SOM_TERMINA_JOGO
    MOV [TOCA_SOM], R1
    MOV [APAGA_AVISO], R1              ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV [APAGA_IMAGEM_SOBREPOSTA], R1     ; apaga o ecrã de pausa sobreposto
    MOV  [APAGA_ECRÃ], R1	           ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    
    MOV R1, 6                       
    MOV [TERMINA_VIDEO], R1                 ; retira musica do title screen

    MOV R1, ECRA_TERMINA_JOGO
    MOV [SELECIONA_CENARIO_FUNDO], R1  ; troca ecrã para o ecrã de perda por colisão

    MOV R1, TERMINADO      
    MOV [ESTADO], R1                  ; coloca o estado de jogo em terminado

    JMP controlo_jogo

perdeu_falta_energia:

    MOV R1, 6                       
    MOV [TERMINA_VIDEO], R1                 ; retira musica do title screen

    MOV R1, FALTA_ENERGIA_SOM
    MOV [TOCA_SOM], R1

    MOV [APAGA_AVISO], R1                ;apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	           ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    
    MOV R1, ECRA_PERDEU_ENERGIA
    MOV [SELECIONA_CENARIO_FUNDO], R1  ; mete o ecrã perdeu por falta de energia

    MOV R1, TERMINADO
    MOV [ESTADO], R1          ; atualiza variável de estado para TERMINADO

   ; JMP remove_asteroides              ; vai apagar os asteroides
   JMP controlo_jogo

perdeu_por_colisao:

    MOV R1, 6                       
    MOV [TERMINA_VIDEO], R1                 ; retira musica do title screen

    MOV R1, COLIDE_NAVE_SOM
    MOV [TOCA_SOM], R1

    MOV [APAGA_AVISO], R1                ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	           ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

    MOV R1, ECRA_PERDEU_COLISAO
    MOV [SELECIONA_CENARIO_FUNDO], R1  ; troca ecrã para o ecrã de perda por colisão

    MOV R1, TERMINADO
    MOV [ESTADO], R1          ; atualiza variável de estado para PERDEU_JOGO
    JMP controlo_jogo

; **********************************************************************
; Processo
;
; TECLADO - Processo que itera por todas as linhas, deteta quando se carrega 
;           numa tecla do teclado, deteta a tecla carregada, e envia sinal
;           para o processo comunica_ação_controlo para executar a função
;           correspondente à tecla primida.
;		   
; **********************************************************************

PROCESS SP_inicial_teclado      ; indicação de que a rotina que se segue é um processo
                                ; com indicação do valor para inicializar o SP
                                ; processo que implementa o comportamento do teclado
teclado_processo:
;codigo responsavel por iterar teclado, detetar a tecla primida e executar a função correspondente
ciclo_teclado:
    MOV  R1, LINHA_INICIAL     ; comeca a varrer na primeira linha
    MOV  R0, 0                 ; inicializa o R0

espera_tecla:                  ; neste ciclo verifica se se alguma tecla de uma determinada linha foi primida

    WAIT                       ; este ciclo é potencialmente bloqueante, pelo que tem de ter um ponto de fuga

    CALL teclado               ; guarda em R0 a tecla premida
    CMP  R0, 0                 ; há tecla premida?
    JZ   aumenta_linha         ; se nenhuma tecla premida, passa para a proxima linha do teclado

    CALL ha_tecla              ; espera que a tecla deixe de ser primida
    CALL descobre_tecla        ; descobre qual tecla foi primida 
    JMP ciclo_teclado          ; volta a procurar novas teclas (esta "rotina" nunca retorna porque nunca termina)

aumenta_linha:
    CALL muda_linha
    JMP espera_tecla          ; vai verificar se alguma tecla da nova linha foi premida
  
; **********************************************************************
; Processo
;
; COMUNICA_AÇÃO_CONTROLO - Processo que recebe do processo_teclado a tecla
;                          premida, avalia o estado de jogo, compara a
;                          tecla primida com a tecla de cada ação e comunica
;                          a ação a ser executada ao processo controla_jogo 
;                          ou ao processo_sonda se tratar-se de disparos
;		   
; **********************************************************************

PROCESS SP_inicial_comunica_ação_controlo

comunica_ação_controlo:

    MOV R5, [lock_tecla]        ; lê o valor da tecla primida no processo_teclado
    MOV R0, [ESTADO]            ; lê o estado atual do jogo

    CMP R0, MAIN_MENU           ; o jogo está no main_menu?
    JZ main_menu

    CMP R0, JOGO                ; o jogo está ativo?
    JZ jogo

    CMP R0, PAUSADO             ; o jogo está pausado?
    JZ pausado

    CMP R0, TERMINADO           ; o jogo está terminado?
    JZ terminado 

; vê se quando no main menu a tecla primida é a C, se sim comunica sinal COMECAR a controlo_jogo
main_menu:
    MOV R0, TECLA_C
    CMP R5, R0                  ; o jogo está no main menu, esperamos que a tecla primida é a C
    MOV R0, COMECAR             ; prepara sinal para comunicar ao processo controlo_jogoREINICIAR
    JZ  unlock_controlo         ; desbloqueia o processo controlo_jogo com o sinal
    JMP comunica_ação_controlo 


; vê se quando o jogo está pausado a tecla primida é a D, se sim comunica sinal DESPAUSAR a controlo_jogo
pausado:                        ; o jogo está pausado, estamos à espera que seja despausado (tecla D) ou que seja terminado
    MOV R0, TECLA_D             ; a tecla D despausa o jogo
    CMP R5, R0                  ; verifica se a tecla primida é a tecla D
    MOV R0, DESPAUSAR           ; prepara sinal para comunicar ao processo controlo_jogo
    JZ unlock_controlo          ; desbloqueia processo controlo_jogo com o sinal

    JMP verifica_termina         ; vai verificar se quer terminar jogo estando em pausa

; vê se quando o jogo está perdido ou terminado a tecla primida é a C, se sim comunica o sinal REINICIAR ao controlo_jogo
terminado:
    MOV R0, TECLA_C             ; o jogo está terminado, estamos à espera que seja reiniciado
    CMP R5, R0                  ; verifica se a tecla primida é a tecla C
    MOV R0, REINICIAR           ; prepara sinal para comunicar ao processo controlo_jogo
    JZ unlock_controlo          ; desbloqueia o processo controlo_jogo com o sinal
    JMP comunica_ação_controlo 

; verifica teclas para quando o jogo esta jogavel
jogo:
    ; disparo da sonda meio
    MOV R0, TECLA_1             
    CMP R0, R5                  ; verifica se a tecla carregada é a tecla 1
    MOV R0, 2                   ; prepara o valor a mandar para o lock (intância x2)
    JZ unlock_disparo_sonda     ; vai escrever no lock_sonda, desbloqueando processo_sonda
    
    ; disparo da sonda diag direita
    MOV R0, TECLA_2
    CMP R0, R5                  ; verifica se a tecla carregada é a 2
    MOV R0, 4                   ; prepara o valor a mandar para o lock (intância x2)
    JZ unlock_disparo_sonda     ; vai escrever no lock_sonda, desbloqueando processo_sonda

    ; disparo da sonda diag esquerda
    MOV R0, TECLA_0             ; verifica se a tecla carregada é a 0
    CMP R0, R5                  ; prepara o valor a mandar para o lock (intância x2)
    MOV R0, 0                   ; vai escrever no lock_sonda, desbloqueando processo_sonda
    JZ unlock_disparo_sonda

    ; pausa jogo
    MOV R0, TECLA_D             ; verifica se a tecla carregada é a D      
    CMP R5, R0 
    MOV R0, PAUSAR              ; prepara valor a mandar para o lock
    JZ unlock_controlo          ; vai escrever no lock_controlo, desbloqueando controlo_jogo

verifica_termina:               ; verifica se o user quer terminar o jogo
    MOV R0, TECLA_E             ; verifica se a tecla carregada é a E 
    CMP R5, R0
    MOV R0, TERMINAR            ; prepara valor a mandar para o lock
    JZ unlock_controlo          ; vai escrever no lock_controlo, desbloqueando controlo_jogo

    JMP comunica_ação_controlo  

unlock_controlo:                ; desbloqueia o processo controlo_jogo com o sinal enviado para a variavel LOCK
    MOV [lock_controlo], R0     ; passar os argumentos ao processo
    JMP comunica_ação_controlo       

unlock_disparo_sonda:           ; desbloqueia o processo_sonda com o sinal enviado para a variavel LOCK
    MOV R1, lock_sonda
    MOV [R1 + R0], R0           ; o R0 contem a instancia multiplicada por 2
    JMP comunica_ação_controlo


; **********************************************************************
; Processo
;
; ASTEROIDE - Processo que desenha um asteroide e o move verticalmente,
;             ou nas diagonais com temporização marcada pela interrupção 0
;
; Argumentos: R11 -> número da instância do processo_asteroide
; **********************************************************************

PROCESS SP_inicial_asteroide	; indicação de que a rotina que se segue é um processo,
						        ; com indicação do valor para inicializar o SP
processo_asteroide:
    MOV SP, SP_inicial_asteroide
 
atualiza_sp_asteroide:
    MOV R1, TAMANHO_PILHA       ; tamanho em palavras da pilha de cada processo
    MUL R1, R11                 ; muliplica o tamanho da pilha pelo número de instânicas
    SUB SP, R1                  ; inicializa o SP deste asteroide

    MOV R9, R11                 ; cópia do número da instância do processo
    ADD R9, 1                   ; adiciona 1 ao número da instância em que estamos para definir o ecrã de desenho do asteroide

; espera por desbloqueio deste processo por parte do processo controla_jogo
espera_controlo:
    MOV R0, [TRANCA_ASTEROIDE]   ; bloqueia o processo do asteroide se não estivermos em JOGO (não desbloqueia com interrupções)

gera_novo_asteroide:    
    CALL gera_propriedades_asteroide
    ; R4 -> Endereço da tabela do asteroide a desenhar
    ; R5 -> Valor da coluna de spawn                                   
    ; R6 -> Valor da linha de spawn
    ; R7 -> Valor da direção da coluna
    ; R8 -> Valor da direção da linha

    ; arranja os argumentos para desenha_boneco
    MOV R1, R6                  ; passa valor da linha do asteroide para R1
    MOV R2, R5                  ; passa valor da coluna do asteroide para R2
                                ; R4 já tem o endereço da tabela a desenhar
                   
ciclo_asteroide:

    MOV R0, [ESTADO]
    CMP R0, JOGO                  ; o jogo está terminado?
    JNZ espera_controlo           ; se sim tem de terminar o processo
    
    MOV [ESCOLHE_ECRÃ], R9         ; R9 é o número do ecrã onde vamos desenhar (porque cada asteroide tem o seu próprio ecrã) 
    CALL desenha_boneco

    MOV R3, [lock_asteroide]      ;lê o LOCK (bloqueia até a rotina de interrupção escrever por cima
    
    MOV [ESCOLHE_ECRÃ], R9        ; R9 é o número do ecrã onde vamos desenhar (porque cada asteroide tem o seu próprio ecrã) 
    CALL apaga_boneco
   
    CALL testa_limites_asteroide  ; retorna 1 ou 0 no registo R3
    CMP R3, 1                     ; se R3 estiver a 1, o asteroide excedeu o limite e voltamos a gerar outro
    JZ gera_novo_asteroide

    ; atualiza as coordenadas
    ADD R1, R8                    ; atualiza a linha do asteroide consoante o tipo de movimento gerado aleatoriamente
    ADD R2, R7                    ; atualiza a coluna do asteroide consotante o tipo de movimento gerado aleatoriamente
    
    ; Testa colisão com a nave (R1 tem a linha atual e R2 a coluna atual)
    CALL colisao_nave             ; se colide guarda em R0 o valor de PERDEU_COLISAO
    CMP R0, PERDEU_COLISAO
    JZ colidiu                    ; se colidiu tem de ir avisar controlo

    ;Testa se o asteroide colidiu com uma sonda
    CALL colide_sonda
    CMP R0, 1  ; R0 e o valor de retorno de colide_sonda, e se estiver a 1, entao houve colisao
    JZ colisao_sonda  

    JMP	ciclo_asteroide		        ; volta a esperar pela interrupção

colidiu:
    MOV [lock_controlo], R0
    JMP espera_controlo             ; bloqueia o processo do asteroide novamente

colisao_sonda:
    
    MOV R0, DEF_ASTEROIDE_MINERAVEL
    CMP R4, R0                      ; vê se o asteroide com que a sonda colidiu é minerável
    JZ colisao_sonda_mineravel
    
    ; Asteroide é não minerável
    MOV R11, SOM_EXPLOSAO_ASTEROIDE
    MOV [TOCA_SOM], R11
    CALL animacao                   ; mete o processo da animacao executavel
    
    JMP gera_novo_asteroide
   
colisao_sonda_mineravel:            ; asteroide é minerável
    MOV R10, [ESTADO]
    CMP R10, JOGO                   ; compara estado atual com o estado JOGO
    JNZ espera_controlo             ; se já não estiver no estado JOGO, bloqueia o processo_asteroide 
    MOV R11, SOM_EXPLOSAO_MINERAVEL
    MOV[TOCA_SOM], R11              ; reproduz som de explosão do asteroide minerável

    MOV R0, ENERGIA_ASTEROIDE
    MOV [lock_energia], R0          ; desbloqueia o processo energia para que este possa aumentar o display

    MOV R4, FRAME_MINERAVEL_EXPLOSAO; move o frame da explosão do asteroide minerável para R4
    
    MOV [ESCOLHE_ECRÃ], R9          ; R9 é o número do ecrã onde vamos apagar (porque cada asteroide tem o seu próprio ecrã) 
    CALL desenha_boneco
    MOV R3, [lock_asteroide]
    
    MOV [ESCOLHE_ECRÃ], R9          ; R9 é o número do ecrã onde vamos apagar (porque cada asteroide tem o seu próprio ecrã) 
    CALL apaga_boneco
    JMP gera_novo_asteroide


; *****************************************************
; Processo
;
; Sonda - Processo que trata do movimento das sondas
;           
; Argumentos: R11 -> número da instancia do processo
; *****************************************************

PROCESS SP_inicial_sonda

processo_sonda: 

    MOV R1, 100H
    MUL R1, R11   ; tamanho da pilha vezes o numero da instancia
    SUB SP, R1

    MOV R10, R11  ; cópia do número de instância
    MOV R9, R11   ; cópia do número de instância
    SHL R10, 1    ;  a tabela e de words por isso multiplica por dois
    SHL R9, 2     ; para percorrer a tabela dos movimentos

espera_sonda:
    MOV R8, lock_sonda 
    MOV R1, [R8 + R10]             ; bloqueia o processo principal da sonda da instancia R11 ate a tecla de disparo certa o desbloquear
    
    toca_som_disparo:              ; toca som do disparo à saída da nave
        MOV R0, SOM_DISPARO
        MOV [TOCA_SOM], R0
        MOV [R8 + R10] , R1        ;coloca na variavel SONDA_ATIVA a tecla que foi carregada

    MOV R0, ENERGIA_SONDA               
    MOV [lock_energia], R0         ; desbloqueia o processo da energia comunica que foi uma sonda que diminui a energia

    MOV R5, estado_sonda
    MOV R0, SONDA_ATIVA
    MOV [R5 + R10], R0

    CALL desenha_sonda      ; desenha a sonda a partir da tabela (as coordenadas iniciais já foram incializadas)
                            ; as coordenadas são lidas da memória e depois atualizadas mais abaixo nesta rotina

    MOV R2, MAX_MOV_SONDA             

ciclo_sonda:
    SUB R2, 1
    MOV R3, [lock_sonda_int]  ; lê o LOCK e bloqueia até a interrupção escrever nele
                              ; Quando bloqueia, passa o controlo para outro processo
                              ; Como não há valor a transmitir, o registo pode ser um qualquer

    ;verifica se o user terminou o jogo ou perdeu para terminar o processo
    MOV R5, [ESTADO]
    CMP R5, JOGO           ; o jogo está terminado?
    JNZ espera_sonda        ; se sim tem de terminar o processo

    MOV R5, colidiu_asteroide
    MOV R3, [R5 + R10]   ; le a variavel que indica se a sonda colidiu com o asteroide
    CMP R3, 1            ; colidiu com o asteroide (1 significa que sim)
    JZ reinicia_sonda    ; se sim vai reiniciar a sonda

    CALL move_sonda     ; apaga, atualiza coordenadas, testa limites

    CMP R2, 0 ;  ve se a sonda ja andou 12 vezes
    JZ reinicia_sonda ; se sim reinicia a variavel de estado

    JMP ciclo_sonda
reinicia_sonda:
    CALL apaga_sonda

    MOV R4, linha_sonda_inicial
    MOV R1, [R4 + R10]   ; le da memoria a linha da sonda da instancia inical

    MOV R4, coluna_sonda_inicial
    MOV R2, [R4 + R10]   ; le da memoria a coluna da sonda da instancia inicial

    MOV R4, linha_sonda
    MOV [R4 + R10], R1   ; repor valor inicial da linha

    MOV R4, coluna_sonda
    MOV [R4 + R10], R2   ; repor valor inicial da coluna

    MOV R4, estado_sonda
    MOV R2, SONDA_DESATIVA
    MOV [R4 + R10], R2

    MOV R2, 0
    MOV [R5 + R10], R2   ; repoe a variavel de estado que indica que o asteroide colide com a sonda a 0

    JMP  espera_sonda      ; volta a bloquear o processo principal


; ***********************************************************************************
; Processo
;
; ENERGIA - Processo que diminui o display da energia 3%, dependendo do valor que le do lock
;
; ***********************************************************************************

PROCESS SP_INICIAL_ENERGIA

processo_energia:
    MOV R1, [lock_energia]
    MOV R0, [CONTADOR]
    ADD R0, R1    ;  acrescenta o valor que recebe da variavel lock
    MOV [CONTADOR], R0  ; atualiza a variavel do contador 
    CMP R0, 0
    CALL update_display   ;escreve no display
    JZ   acabou_energia    ; se o contador for 0 acaba a energia e perde jogo
    JLT  acabou_energia     ; se o contador for negativo acaba energia e perde jogo
    JMP processo_energia   ; volta a bloquear precesso a espera de ser desbloqueado
acabou_energia:
    MOV R1, ESGOTOU_ENERGIA
    MOV [lock_controlo], R1  ; avisa o processo controlo_jogo que tem de terminar o jogo pois acabou a energia
    JMP processo_energia

; ***********************************************************************************
; Processo
;
; NAVE - processo que desenha cada frame da nave
;
; ***********************************************************************************

PROCESS SP_inicial_nave

processo_nave: 
    MOV R1, NUMERO_FRAMES       ; lê número de frames da nave
    MOV R0, frames_nave         ; lê endereço da tabela dos frames
    MOV [nave_atual], R0        ; escreve na variável o primeiro frame
itera_frames_nave:
    
    MOV R0, [lock_nave]         ; espera pela interrupção

    MOV R0, [ESTADO]
    CMP R0, TERMINADO           ; o jogo está terminado?
    JZ  itera_frames_nave       ; se perdeu ou terminou, mas a interrupcao ainda teve tempo de dar unlock ao processo o jogo ja nao vai desenhar a nave

    call desenha_nave
    MOV R0, [nave_atual]  ; contem o frame atual
    ADD R0, 2 ; passa para o proximo elemento da tabela
    MOV [nave_atual], R0   ; escreve na variavel o endereco so proximo frame

    SUB R1, 1                   ; subtrai ao número de frames
    CMP R1, 0                   ; vê se já percorreu a tabela toda
    JZ  processo_nave

    JMP itera_frames_nave


; **********************************************************************
; MOVE_SONDA - recebe como argumentos R9, R10, a instancia multiplicada por 4 e por 2 respetivamente
;			           (move sonda)	
;**********************************************************************

move_sonda:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R8

; série de instruções para o movimento da sonda consoante a instancia

    MOV R8, linha_sonda
    MOV R0, [R8 + R10]   ; le da memoria a linha da sonda da instancia 

    MOV R8, coluna_sonda
    MOV R1, [R8 + R10]   ; le da memoria a coluna da sonda da instancia 
    
    
    MOV R8, movimento_sonda
    MOV R3, [R8 + R9]   ;  movimento da instancia da linha da sonda 
    ADD R8, R9
    MOV R4, [R8 + 2] ; movimento da instancia da coluna da sonda


    CALL apaga_sonda           ; apaga sonda na posição corrente
      
    ; movimenta a sonda 
    ADD  R0, R3
    ADD  R1, R4
    MOV R8, linha_sonda 
    MOV [R8 + R10], R0   ; atualiza  linha da sonda
    MOV R8, coluna_sonda
    MOV [R8 + R10], R1
    
    CALL desenha_sonda        ; desenha sonda na posição seguinte

    POP R8
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

; **********************************************************************
; descobre_tecla - descobre qual a tecla que foi premida e aplica a sua funcao, se 
;                  se a tecla nao tiver nenhuma funcao nao faz nada
; Argumentos:	R1 -linha, R0, colunas
;
; **********************************************************************

descobre_tecla:
    PUSH R2
    PUSH R0
    
    CALL obtem_VALOR_TECLA      ;  converte a linha e a coluna numa posicao do teclado e guarda em R1
    MOV [lock_tecla], R1        ; manda o valor da tecla primida para o processo comunica_ação_controlo, desbloqueando-o
    
    POP R2
    POP R0
    RET

; **********************************************************************
; update_display - atualiza o contador com o novo valor do contador
; Argumentos:	nenhum, o valor do contador esta na variavel CONTADOR
;
; **********************************************************************
update_display:
    PUSH  R4
    PUSH  R0
    MOV  R4, DISPLAYS    ; endereço do periférico dos displays
    MOV  R0, [CONTADOR]  ; valor atual do contador em R0
    CMP R0, 0
    JLT valor_negativo
    JMP  escreve_display
valor_negativo:                 ; o contador tem valor negativo, logo vai escrevr no display 0
    MOV R0, 0
escreve_display:
    CALL conver_hexadecimal
    MOV  [R4], R0      ; escreve o novo valor contador nos displays
    POP  R0
    POP  R4
    RET

; **********************************************************************
; muda_linha - muda a linha para a proxima, quando chega ao fim comeca da primeira linha
; Argumentos:	R1 - linha atual
;
; Retorna: 	R1	-  proxima linha
; **********************************************************************

muda_linha:
    PUSH R0
    MOV R0, LINHA_FINAL
    CMP  R1, R0         ; verifica se chegou a ultima linha
    JZ reinicia    ; chegamos a ultima linha e comeca um novo varrimento
    SHL  R1, 1          ; avanca para a proxima linha
    JMP fim_muda_linha
reinicia:
    MOV R1, LINHA_INICIAL
fim_muda_linha:
    POP R0
    RET

; **********************************************************************
; incrementa_cont - incrementa o contador guardado na variavel CONTADOR 
;                   e atualiza o display
; Argumentos:	nenhum
;	
; **********************************************************************
incrementa_cont:
    PUSH R0
    MOV R0, [CONTADOR]
    ADD R0, 1H          ; incrementa o contador
    MOV [CONTADOR], R0
    CALL update_display ; da update ao contador com o novo valor do contador
    POP R0
    RET

; **********************************************************************
; decrementa_cont - decrementa o contador guardado na variavel CONTADOR e atualiza o display
; Argumentos:	nenhum
;	
; **********************************************************************
decrementa_cont:
    PUSH R0
    MOV R0, [CONTADOR]
    SUB R0, 1H          ; decrementa o contador
    MOV [CONTADOR], R0
    CALL update_display ; da update ao contador com o novo valor do contador
    POP R0
    RET

; **********************************************************************
; ha_tecla - esta constantemente em ciclo a verificar se ainda esta a ser premida 
;            uma tecla, so sai do ciclo quando de deixa de premir a tecla
; Argumentos:	nenhum
;	
; **********************************************************************

ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    PUSH R0            ; salvaguarda o R0
ciclo_ha_tecla:
    
    YIELD              ; este ciclo é potencialmente bloqueante, pelo que tem de ter
                       ; um ponto de fuga (aqui pode comutar para outro processo) 

    CALL teclado
    CMP  R0, 0         ; há tecla premida?
    JNZ  ciclo_ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    POP  R0
    RET

; **********************************************************************
; obtem_VALOR_TECLA - converte a linha e a coluna da tecla premida na posicao do teclado (em hexa) correspondente 
; Argumentos:	R1 - linha  e R0 - coluna
;
; Retorna: 	R1- posicao da tecla	
; **********************************************************************
obtem_VALOR_TECLA: 
    PUSH R2
    CALL loop_SHR_linhas       ; obtem o valor da linha da tecla premida e guarda na variavel N_LINHA
    CALL loop_SHR_colunas      ; obtem o valor da coluna da tecla premida e guarda na variavel N_COLUNA
    MOV R2, [N_COLUNA]    ; coloca em R2 o valor da coluna
    MOV R1, [N_LINHA]     ; coloca em R1 o valor da linha
    SHL R1, 2             ; multiplica linha por 4
    ADD R1, R2            ; soma a linha multiplicada por 4 com a coluna e guarda o valor em R7
    POP R2
    RET                   ; regressa

; **********************************************************************
; loop_SHR_linhas - conta o numero de shifts que da para fazer ate ser zero com a linha
; Argumentos:	R1 - linha  
;
; Retorna: 	Sem retorno, no entanto altera a variavel N_LINHA
; **********************************************************************
loop_SHR_linhas:      
    PUSH R2
    MOV R2, 0          ; garante que o contador comeca a 0
loop_linhas:           ; faz loops sucessivos até N_LINHA ser igual a zero
    SHR R1, 1          ; faz right shift a N_LINHA 
    INC R2             ; incrementa contador    
    CMP R1, 0          ; compara N_LINHA com zero
    JNZ loop_linhas; se N_LINHA ainda não é zero salta de novo para o loop

    SUB R2, 1          ; obtem valor da linha (0-3)
    MOV [N_LINHA], R2  ; escreve na variavel o numero da linha
    POP R2
    RET

; **********************************************************************
; loop_SHR_colunas - conta o numero de shifts que da para fazer ate ser zero com a coluna
; Argumentos:	R0 - coluna
;
; Retorna: Sem retorno, no entanto altera a variavel N_COLUNA	
; **********************************************************************

loop_SHR_colunas:        
    PUSH R2
    MOV R2, 0            ; garante que o contador comeca a 0
loop_colunas:            ; faz loops sucessivos até N_COLUNA ser igual a zero
    SHR R0, 1            ; faz right shift a N_COLUNA
    INC R2               ; incrementa contador
    CMP R0, 0            ; compara N_COLUNA com zero
    JNZ loop_colunas ; se N_COLUNA ainda não é zero salta de novo para o loop

    SUB R2, 1            ; obtem valor da coluna (0-3)
    MOV [N_COLUNA], R2   ; escreve na variavel o numero da linha
    POP R2
    RET

; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R1 - linha a testar (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************
teclado:
	PUSH	R2
	PUSH	R3
	PUSH	R5
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R1      ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	AND  R0, R5        ; elimina bits para além dos bits 0-3
	POP	R5
	POP	R3
	POP	R2
	RET

; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
desenha_boneco:
	PUSH    R1
    PUSH    R2
    PUSH	R3               ; limpa registo R3
	PUSH	R4               ; guarda endereço largura do boneco no stack
    PUSH    R5
    PUSH    R7
    PUSH    R9
    PUSH    R10

    MOV	R5, [R4]		     ; obtém a largura do boneco
     
    ADD	R4, 2			     ; endereço da altura do boneco
    MOV R7, [R4]             ; obtém a altura do boneco
    ADD R4, 2                ; endereço da cor do primeiro pixel do boneco
    
    MOV R9, R5               ; armazena a largura do boneco
    MOV R10, R2              ; armazena a coluna do pixel
   
itera_linhas_boneco:
    MOV R2, R10              ; recupera valor da coluna do pixel de referencia
    MOV R5, R9               ; reinicializa o contador de largura

desenha_pixels:       		 ; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			 ; obtém a cor do próximo pixel do boneco
	CALL	escreve_pixel	 ; escreve cada pixel do boneco
	
    ADD	R4, 2			     ; avança para o endereço da cor do próximo pixel
    ADD  R2, 1               ; avança para a próxima coluna
    SUB  R5, 1			     ; decrementa contador de largura da linha

    JNZ desenha_pixels      ; continua até percorrer toda a largura do objeto

    SUB R1, 1                ; contador de largura chega a 0, avança para próxima linha
    SUB R7, 1                ; decrementa contador de altura do boneco
    
    JNZ itera_linhas_boneco  ; enquanto o contador da altura não é 0, passa para a próxima linha
	
    POP R10
    POP R9
    POP R7
    POP	R5                   ; liberta contador de largura do registo R5
	POP	R4                   ; recupera endereço da largura do boneco do stack
	POP	R3                   ; liberta registo cor do pixel do registo R3
    POP R2
    POP R1                   ; restaura valor da coluna inicial
	RET

;--------------------------------------------------------------------------------------

; coleta argumentos e desenha a nave
desenha_nave:
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R3
    
    MOV R1, 0
    MOV [ESCOLHE_ECRÃ], R1

    MOV R1, LINHA_NAVE    ; armazena linha do pixel de referencia da nave
    MOV R2, COLUNA_NAVE   ; armazena coluna do pixel de referencia da nave
    MOV R3, [nave_atual]
    MOV R4, [R3]      ; armazena o endereço do primeiro objeto do frame da nave (LARGURA)

    CALL desenha_boneco   ; desenha boneco da nave com os valores guardados nos registos

    POP R3
    POP R4
    POP R2
    POP R1

    RET

; coleta argumentos da sonda e chama desenha_boneco
; tem como argumentos a instancia multiplicada por 2 (R10)
desenha_sonda:              
    PUSH R1
    PUSH R2
    PUSH R4

    MOV R1, 0
    MOV [ESCOLHE_ECRÃ], R1      ; escolhe o ecrã onde desenhar a sonda (0) 

    MOV R4, linha_sonda
    MOV R1, [R4 + R10]   ; le da memoria a linha da sonda da instancia 

    MOV R4, coluna_sonda
    MOV R2, [R4 + R10]   ; le da memoria a coluna da sonda da instancia 

    MOV R4, DEF_SONDA           ; contém endereço da largura da sonda
    CALL desenha_boneco         ; desenha a sonda

    POP R4
    POP R2
    POP R1

    RET


;coleta argumentos da sonda e chama apaga_boneco
; tem como aargumentos o R10, a instancia multiplicada por 2
apaga_sonda:
           
    PUSH R1
    PUSH R2
    PUSH R4
    
    MOV R1, 0
    MOV [ESCOLHE_ECRÃ], R1      ; escolhe o ecrã onde desenhar a sonda (0)

    MOV R4, linha_sonda
    MOV R1, [R4 + R10]   ; le da memoria a linha da sonda da instancia 

    MOV R4, coluna_sonda
    MOV R2, [R4 + R10]   ; le da memoria a coluna da sonda da instancia 

    MOV R4, DEF_SONDA           ; contém endereço da largura da sonda

    CALL apaga_boneco            ; apaga a sonda

    POP R4
    POP R2
    POP R1

    RET

; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
; Retorna: pixel desenhado
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET                         ; retorna controlo a desenha_pixels

; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha do pixel a apagar
;               R2 - coluna do pixel a apagar
;               R4 - tabela que define o boneco
;
; **********************************************************************
apaga_boneco:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
    PUSH    R5
    PUSH    R7
    PUSH    R9
    PUSH    R10
	
    MOV	R5, [R4]	    ; obtém a largura do boneco
    ADD	R4, 2			; endereço da altura do boneco
    MOV R7, [R4]        ; obtém a altura do boneco

	ADD	R4, 2			; endereço da cor do 1º pixel (2 porque a largura é uma word)

    MOV R9, R5
    MOV R10, R2

itera_linhas_apagadas_boneco:
    MOV R2, R10              ; recupera valor da coluna do pixel de referencia
    MOV R5, R9               ; reinicializa o contador de largura

apaga_pixels:       	; desenha os pixels do boneco a partir da tabela
	MOV	R3, COR_APAGADO			; cor para apagar o próximo pixel do boneco
	CALL	escreve_pixel		; escreve cada pixel do boneco
	
    ADD	R4, 2			; avança para o endereço da cor do próximo pixel 
    ADD  R2, 1          ; próxima coluna
    SUB  R5, 1			; decrementa contador de largura
    
    JNZ  apaga_pixels      ; continua até percorrer toda a largura do objeto

    SUB R1, 1                ; contador de largura chega a 0, avança para próxima linha
    SUB R7, 1                ; decrementa contador de altura do boneco
    
    JNZ itera_linhas_apagadas_boneco  ; enquanto o contador da altura não é 0, passa para a próxima linha

    POP R10
    POP R9
    POP R7
	POP	R5
	POP	R4
	POP	R3
	POP	R2
    POP R1
	RET

; **********************************************************************
; TESTA_LIMITES_ASTEROIDE - Testa se o asteroide chegou aos limites do ecrã 
; Argumentos:	R1 - linha corrente do objeto
;			    			  
; Retorna: 	R3 - Valor da flag que nos diz se excedemos o limite ou não 	
; **********************************************************************
testa_limites_asteroide:
	PUSH    R1
	PUSH	R5
    PUSH    R7
    
testa_limite_baixo:		          ; vê se o boneco chegou ao fundo do ecrã
    MOV R7, ALTURA_ASTEROIDE      ; passa altura de asteroide para R7
    MOV	R5, MAX_LINHA             ; passa valor máximo de linha para R5
    ADD R1,1                      ; linha do ponto de referencia caso o objeto desça uma linha
    SUB R1, R7                    ; subtrai altura do objeto à linha atual do pixel de referencia
	CMP	R1, R5                    ; compara R1 com MAX_LINHA
	JZ ativa_EXCEDEU_LIMITE

    MOV R3, 0                     ; no caso de não ativar a flag, retorna 0

sai_testa_limites_asteroide:	
	POP R7
    POP	R5
    POP R1
	RET

ativa_EXCEDEU_LIMITE:       ; R3 é uma flag que indica se já excedemos o limite 
    MOV R3, 1               ; flag é ativada, R4 é 1
    JMP sai_testa_limites_asteroide
    
; **************************************************************************
; CONTA_DIGS - conta o numero de digitos de um numero
; Argumentos: numero -R0		  
; Retorna:    numero de digitos	- R1	
; **************************************************************************
conta_digs:
    PUSH R0
    PUSH R2
    MOV R2, 10
    MOV R1, 0 ; inicia contador a 0
ciclo_digs:
    CMP R0, R2
    JN fim_digs ;salta para o final se o numero for menor que 10
    DIV R0, R2  ; apaga o ultimo digito
    ADD R1, 1   ; incrmenta ocntador
    JMP ciclo_digs
    
fim_digs:
    ADD R1, 1  ; contabiliza o digito final
    POP R2
    POP R0
    RET

; **************************************************************************
; CONVERTE_HEXADECIMAL - converte um numero hexadecimal para um decimal
; Argumentos: numero hexadecimal - R0			  
; Retorna:    numero decimal equivalente ao recebido - R0		
; **************************************************************************
conver_hexadecimal:
    PUSH R1
    PUSH R2 
    PUSH R3
    PUSH R4
    MOV R4, 0 ;inicializa o resultado a 0 
    MOV R1, 10
    MOV R2, R1 ; inicializa o fator com 10
    CALL conta_digs ; guarda o numero de digs em R1
    CALL potencia_10 ; inicializa o fator (R2) consoante o numero de digitos do numero a converter
    MOV R1, 10 ; volta a colocar 10 em R1
ciclo_converte:
    MOD R0, R2 ; resto da divisao pelo fator
    DIV R2, R1  ; divide o fator por 10
    CMP R2, R1  ; compara o fator com 10
    JN  fim_converte ; se for menor que 10 salta para o fim
    MOV R3, R0 ; coloca em R3 o numero atual
    DIV R3, R2 ; calcula o digito
    SHL R4, 4 ;
    OR  R4, R3 ; coloca o digito no resultado
    JMP ciclo_converte
fim_converte:
    MOV R3, R0 ; coloca em R3 o numero atual
    MOD R3, R1 ; calcula o ultimo digito
    SHL R4, 4 ;
    OR  R4, R3 ; coloca o digito no resultado
    MOV R0, R4 ; coloca o resultado em R0
    POP R4
    POP R3
    POP R2
    POP R1
    RET

; **************************************************************************
; POTENCIA_10 - calcula 10 elevado a um numero
; Argumentos: expoente - R1			  
; Retorna:    potencia - R2	
; **************************************************************************
potencia_10:
    PUSH R0
    MOV R2, 1
    MOV R0, 10
ciclo_potencia:
    CMP R1, 0
    JZ fim_potencia
    SUB R1, 1
    MUL R2, R0
    JMP ciclo_potencia
fim_potencia:
    POP R0
    RET 

; **************************************************************************
; JOGO_SETUP - da reset ao display e mostra o ecra de jogo	
; **************************************************************************
jogo_setup:
    PUSH R0
    PUSH R1

    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV [APAGA_IMAGEM_SOBREPOSTA], R1     ; apaga o ecrã de pausa sobreposto
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    
    MOV R1, MAIN_MENU
    MOV [ESTADO], R1

    ; setup do title screen
    MOV R1, MUSICA_TITLE_SCREEN
    MOV [TOCA_VIDEO], R1    ; toca música de title screen em loop
    MOV	R1, VIDEO_TITLE_SCREEN  ; carrega title screen
    MOV  [TOCA_VIDEO], R1	    ; toca o video do title screen em loop

    ; inicializacao do display
    MOV R0, ENERGIA_INICIAL
    MOV [CONTADOR], R0   ; coloca o contador a 100
    CALL conver_hexadecimal           
    MOV  R1, DISPLAYS    ; coloca o endereco do display em R1
    MOV [R1], R0         ; inicializa o display a 0
    POP R1
    POP R0

    RET


; **************************************************************************
; colisao_nave - deteta se uma asteroide vertical ou diagonal, colidiu com a nave
; Argumentos: R1 -> linha pixel referencia    R2-> coluna pixel referencia			  
; Retorna:   R0 -> com o mesmo valor ou com o valor de PERDE_COLISAO caso colida
; **************************************************************************

colisao_nave:
    PUSH R3
    PUSH R1
    PUSH R2
    PUSH R4

    MOV R3, 30  ; valor da coluna do pixel de referencia do asteroide vertical
    CMP R2, R3   ; verifica se o asteroide e verttical
    JZ  verifica_vertical   ; se sim vai verificar se bate na zona do meio da nave
                            ; se nao verifica se bate de lado
    MOV R3, RETANGULO_NAVE_LINHA         ; quando o asteroide nao e vertical
    JMP verifica_colisao_linha
verifica_vertical:     ; quando o asteroide e vertical a linha quando bate e diferente
    MOV R3, LINHA_MAX_NAVE

verifica_colisao_linha:
    CMP R1, R3               ; verifica se o asteroide esta na linha de cima da nave
    JZ verifica_colisao_coluna ; se sim vai verificar a coluna
    MOV R0, -1              ; garante que R0 não fica com valor de PERDEU_COLISAO
    JMP sai_colisao_nave

verifica_colisao_coluna:
    MOV R1, COLUNA_MAX_NAVE
    CMP R2, R1   ; verifica se asteroide bate  na parte direita da nave 
    JGT sai_colisao_nave     ; se for maior que a coluna maxima da nave significa que nao colide

    ADD R2, 4     ; coluna mais distante do asteroide
    MOV R1, COLUNA_NAVE
    CMP R2, R1    ;  verifica a parte esquerda da nave
    JLT sai_colisao_nave   ; se a coluna for menor nou houve colisao

colide:
    MOV R0, PERDEU_COLISAO

sai_colisao_nave:
    POP R4
    POP R2
    POP R1
    POP R3
    RET

; **************************************************************************
; inicializa_coordenadas_sonda - reinicializa as coordenadas das sondas 
; **************************************************************************
inicializa_coordenadas_sonda:  

    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3

    MOV R0, 0  ; comeca na instancia 0
itera_tabela:

    MOV R3, linha_sonda_inicial
    MOV R1, [R3 + R0]   ; le da memoria a linha da sonda da instancia inical

    MOV R3, coluna_sonda_inicial
    MOV R2, [R3 + R0]   ; le da memoria a coluna da sonda da instancia inicial

    MOV R3, linha_sonda
    MOV [R3 + R0], R1   ; repor valor inicial da linha

    MOV R3, coluna_sonda
    MOV [R3 + R0], R2   ; repor valor inicial da coluna

    ADD R0, 2            ; passa para o proximo elemento da tabela
    MOV R3, N_SONDAS
    MOV R1, 2
    MUL R3, R1              ; valor do contador quando esta no ultimo elemento
    CMP R0, R3
    JNZ itera_tabela

    POP R3
    POP R2
    POP R1
    POP R0
    RET

; ****************************************************************************************************
; random_num_15 - Determina pseudo-aleatoriamente um número entre 0 e 15	  
; Retorna: R0 -> Número pseudo-aleatório entre 0 e 15
; ****************************************************************************************************
random_num_15:
    PUSH R1
    MOV R0, [TEC_COL]       ; lê o valor da coluna do PIN para R0
    MOV R1, MASCARA_BITS_ALEATORIOS
    AND R0, R1 
    
    SHR R0, 4               ; mete os bits de 7 a 4 (valores aleatórios) nos de 0 a 3
    
    POP R1
    RET

; ****************************************************************************************************
; gera_tipo_asteroide - Determina pseudo-aleatoriamente o tipo do asteroide (minerável ou normal)
; Argumentos: R0 -> Valor pseudo-aleatório entre 0 e 15			  
; Retorna: R4 -> Tabela de desenho do asteroide a desenhar. (DEF_ASTEROIDE ou DEF_ASTEROIDE_MINERAVEL)
; ****************************************************************************************************
gera_tipo_asteroide:
    PUSH R0
    PUSH R5

    MOV R5, 0011b      ; aplica máscara para ficar com os 2 bits de menor peso
    AND R0, R5         ; R0 fica um valor entre 0 e 3  (4 possibilidades, 1 delas é para asteroides mineraveis) 

    CMP R0, 0
    JZ asteroide_mineravel    ; se valor de R0 é 0, o asteroide é minerável
        
asteroide_normal:
    MOV R4, DEF_ASTEROIDE
    JMP sai_gera_tipo_asteroide
    
asteroide_mineravel:
    MOV R4, DEF_ASTEROIDE_MINERAVEL
      
sai_gera_tipo_asteroide:
    POP R5
    POP R0
    RET

; ****************************************************************************************************
; gera_spawn_location - Determina pseudo-aleatoriamente 
; Argumentos: R0 -> Valor pseudo-aleatório entre 0 e 15			  
; Retorna: R5 -> Valor da coluna de spawn
;          R6 -> Valor da linha de spawn
;          R7 -> Valor da direção da coluna
;          R8 -> Valor da direção da linha
;
; ****************************************************************************************************

gera_spawn_location:
    PUSH R0
    PUSH R9

    MOV R9, 5
    MOD R0, R9      ; resto da divisão de valor pseudo-aleatório (0 - 15) por 5. R0 fica com valor entre 0 e 4 (5 possibilidades)

    CMP R0, 0
    JZ caso1

    CMP R0, 1
    JZ caso2 

    CMP R0, 2
    JZ caso3

    CMP R0, 3
    JZ caso4

    CMP R0, 4
    JZ caso5

    ; caso 1 (spawn canto superior esquerdo)
    caso1:
        MOV R5, COLUNA_CANTO_ESQUERDO
        MOV R6, LINHA_ASTEROIDE
        MOV R7, 1
        MOV R8, 1
        JMP sai_gera_spawn_location

    ; caso 2 (spawn no meio com movimento na diagonal para a esquerda)
    caso2:
        MOV R5, COLUNA_MEIO
        MOV R6, LINHA_ASTEROIDE
        MOV R7, -1
        MOV R8, 1
        JMP sai_gera_spawn_location

    ; caso 3 (spawn no meio com movimento na vertical)
    caso3:
        MOV R5, COLUNA_MEIO
        MOV R6, LINHA_ASTEROIDE
        MOV R7, 0
        MOV R8, 1
        JMP sai_gera_spawn_location

    ; caso 4 (spawn no meio com movimento na diagonal para a direita)
    caso4:
        MOV R5, COLUNA_MEIO
        MOV R6, LINHA_ASTEROIDE
        MOV R7, 1
        MOV R8, 1
        JMP sai_gera_spawn_location

    ; caso 5 (spawn no canto superior direito)
    caso5:
        MOV R5, COLUNA_CANTO_DIREITO
        MOV R6, LINHA_ASTEROIDE
        MOV R7, -1
        MOV R8, 1
           
sai_gera_spawn_location:
    POP R9
    POP R0
    RET

; **********************************************************************************
; gera_propriedades_asteroide - Determina pseudo-aleatoriamente o tipo de asteroide, 
;                               assim como a sua spawn location e tipo de movimento.
;                               		  
; Retorna: R4 -> Endereço da tabela do asteroide a desenhar
;          R5 -> Valor da coluna de spawn
;          R6 -> Valor da linha de spawn
;          R7 -> Valor da direção da coluna
;          R8 -> Valor da direção da linha
; **********************************************************************************
gera_propriedades_asteroide:
    CALL random_num_15           ; gera um número pseudo-aleatório entre 0 e 15 e guarda-o no registo R0
    CALL gera_tipo_asteroide     ; devolve a tabela do asteroide em R4
    CALL gera_spawn_location     ; devolve col de spawn em R5, linha de spawn em R6, valor de direção col, R7 e valor de direção linha em R8 
    RET

; ****************************************************************************************************
; colide_sonda - verifica se o asteroide colide com uma das 3 sondas
;			  
; Argumentos: R1 -> linha do asteroide
;             R2 -> coluna do asteroide
;  RETORNO: retorna R0  se for 1, entao a sonda colide, se nao entao nao colide
; ****************************************************************************************************

colide_sonda:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7

MOV R0, 0                                    ; comeca no primeiro elemento de cada tabela
ciclo_colide_sonda:                          ; itera pelas tabelas das linhas e das colunas das sondas
    MOV R6, linha_sonda                      ; le a linha
    MOV R3, [R6 + R0]                        ; PODE ESTAR MAL !!!

    MOV R6, coluna_sonda
    MOV R4, [R6 + R0]                        ; le a coluna
    
    MOV R5, estado_sonda
    MOV R5, [R5 + R0]                        ; le o estado da sonda
    CMP R5, SONDA_ATIVA                      ; verifica se a sonda esta ativada
    JZ  verifica_colisao_sonda
continua_ciclo:
    ADD R0, 2                                ; passa para o proximo elemento
    MOV R5, 6                                ; para ver se ja percorreu a tabela 3 vezes
    CMP R0, R5
    JZ  termina_colide_sonda
    JMP ciclo_colide_sonda
verifica_colisao_sonda:
    MOV R6, R1                              ;cria um copia da linha do asteroide do pixel de referencia 
    MOV R7, R2                              ; CRIA UMA COPIA DA COLUNA DO ASTEROIDE do pixel de referncia
    MOV R5, ALTURA_ASTEROIDE
    SUB R5, 1                               ; para percorrer a distancia do asteroide

    CMP R3, R1                              ; verifica se a linha da sonda e maior que a do asteroide (ve se a sonda esta abaixo)
    JGT continua_ciclo                      ; se for maior entao nao ha colisao

    SUB R6, R5                              ; adiciona a altura do asteroide a linha do asteroide (ve se a sonda esta acima do asteroide)
    CMP R3, R6                              ; verifica se a sonda nao esta acima do asteroide
    JLT continua_ciclo  

    CMP R4, R2                              ; verifica se a coluna da sonda e menor que a do asteroide
    JLT continua_ciclo                      ; se for menor  nao colidem

    ADD R7, R5
    CMP R4, R7                              ; compara coluna da sonda com a coluna maxima do asteroide
    JGT continua_ciclo
    MOV R5, colidiu_asteroide               ; tabela que contem variaveis de estado que avisam se o processo sonda que colidiu com asteroide
    MOV R3, 1
    MOV [R5+R0], R3                         ; 1 significa que colidiu e vai avisar o processo sonda  
    MOV R0, 1                               ; significa que colide
termina_colide_sonda:
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET


; ****************************************************************************************************
; animacao - Rotina responsável por animar a explosão dos asteroides não mineráveis
;			  
; Argumentos: R1 -> linha do asteroide
;             R2 -> coluna do asteroide
;             R9 -> ecrã da instância onde se vai desenhar
; ****************************************************************************************************
animacao:
    
    PUSH R0 
    PUSH R3
    PUSH R4
    PUSH R6
    PUSH R10

    MOV R6, frames_explosao_asteroide       ; tabela que contém os frames da explosão
    MOV R3, 0                               ; inicializa contador para verificar se já percorremos todos os frames

ciclo_animacao:
    MOV R10, [ESTADO]
    CMP R10, JOGO                           ; se não estivermos em modo jogo, a animacao tem que sair
    JNZ sai_animacao                        
    MOV R4, [R6 + R3]                       ; acede ao valor atual da tabela de frames e passa o frame para R4
    MOV [ESCOLHE_ECRÃ], R9                  ; escolhe o ecrã da instância do processo atual
    CALL desenha_boneco                     ; desenha o frame
    
    MOV R0, [lock_asteroide]                ; bloqueia o processo do asteroide e espera pela interrupcao 

    MOV [ESCOLHE_ECRÃ], R9                  ; escolhe o ecrã da instancia do processo atual
    
    CALL apaga_boneco                       ; apaga o frame

    ADD R3, 2                               ; passa para o próximo frame
    CMP R3, 4                               ; vê se já percorremos todos os frames
    JZ sai_animacao                         ; se sim sai da função
    JMP ciclo_animacao                      ; se não continua a percorrer

sai_animacao:
    POP R10
    POP R6
    POP R4
    POP R3
    POP R0
    RET









