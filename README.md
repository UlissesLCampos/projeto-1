# projeto-1 - Completo
# Ulisses Lombardi Campos - 14781443

## Descrição
Este projeto consiste na implementação de um sistema de dosagem rotativa utilizando Assembly no microcontrolador 8051, simulado no EdSim51. A ideia principal é controlar um motor que realiza a dosagem de parafusos, contando exatamente o número de voltas realizadas. Para isso, foi utilizado o Timer 1 configurado como contador externo, recebendo os pulsos do sensor conectado ao pino T1 (P3.5).



## Principais conceitos utilizados
- Timer 1 como contador externo
- Interrupção no 8051
- Manipulação de bits (F0, Carry)
- Controle de portas (P1, P2, P3)
- Display de 7 segmentos




## Funcionamento geral
- O motor gira continuamente, gerando pulsos a cada volta
- Esses pulsos são capturados pelo Timer 1 (modo contador externo)
- A cada pulso, o valor do contador aumenta
- O número de voltas é exibido em um display de 7 segmentos
- A contagem vai de 0 até 9
- Ao atingir 10 voltas, o sistema reinicia automaticamente a contagem para 0



## Mudança de direção
O sistema possui uma chave (SW0) que permite inverter o sentido de rotação do motor.
- O estado atual do motor é armazenado no bit F0
- Quando a chave muda, o programa detecta essa mudança
- O sentido do motor é invertido (P3.0 e P3.1)
- A contagem de voltas é zerada
- Isso evita misturar contagem de dois sentidos diferentes



## Uso de interrupção
Para deixar o sistema mais organizado, foi utilizada a interrupção do Timer 1.
- O Timer 1 é carregado com o valor FFF6H
- Assim, após 10 pulsos ocorre overflow
- Quando isso acontece, a interrupção é chamada automaticamente
- Dentro da interrupção:
  - o Timer é reiniciado
  - a contagem volta para zero



## Indicação visual
Além do número de voltas, o sistema também indica o sentido de rotação:
- O ponto decimal do display é utilizado para isso
- Em um sentido ele fica aceso
- No outro, apagado



## Como testar no EdSim51
- Rodar o programa
- Ativar o motor (Motor Enabled)
- Observar o display contando de 0 a 9
- Verificar se ao chegar em 10 ele volta para 0
- Alterar a chave SW0
- Verificar se o motor muda de direção
- Verificar se a contagem reinicia
- Observar a mudança no ponto decimal

