# projeto-1 - Completo
# Ulisses Lombardi Campos - 14781443

## Descrição

Este projeto consiste na implementação de um sistema de dosagem rotativa utilizando linguagem Assembly no microcontrolador 8051, simulado no ambiente EdSim51. A proposta principal é controlar um motor responsável por realizar a dosagem de parafusos, contando o número de voltas realizadas pelo eixo do motor. Para fazer essa contagem, foi utilizado o Timer 1 do 8051 configurado como contador externo. Dessa forma, em vez de contar tempo, o Timer 1 passa a contar pulsos externos recebidos pelo pino T1, que corresponde ao P3.5 no microcontrolador. Cada pulso representa uma volta detectada pelo sensor do motor. A contagem de voltas é exibida em um display de 7 segmentos, permitindo acompanhar visualmente o funcionamento do sistema. O programa conta de 0 até 9 voltas e, ao completar a décima volta, ocorre um overflow no Timer 1. Nesse momento, uma interrupção é chamada automaticamente e a contagem é reiniciada para zero. Além disso, o sistema permite alterar o sentido de rotação do motor por meio da chave SW0, lida pelo pino P2.0. Quando essa chave muda de estado, o programa detecta a alteração, inverte o sentido do motor e zera a contagem.




## Principais conceitos utilizados
Neste projeto foram aplicados alguns conceitos importantes do 8051, como:
- configuração do Timer 1 como contador externo;
- uso de interrupção do Timer 1;
- manipulação de bits, como o uso do bit F0 para guardar o sentido atual do motor;
- controle de portas de entrada e saída;
- leitura de chave digital;
- controle de motor por meio dos pinos P3.0 e P3.1;
- utilização de display de 7 segmentos;
- uso de tabela com MOVC para converter o valor numérico no padrão do display.





## Funcionamento geral
Ao iniciar o programa, a pilha é configurada e as portas utilizadas são inicializadas. A porta P2 é usada para leitura da chave SW0, enquanto a porta P1 é utilizada para enviar os sinais ao display de 7 segmentos. O display utilizado no EdSim51 também precisa de algumas configurações específicas. O bit P0.7 é ativado para habilitar o decoder dos displays, e os bits P3.3 e P3.4 são zerados para selecionar o display 0. O motor é controlado pelos pinos P3.0 e P3.1. Dependendo do sentido escolhido, um desses pinos fica em nível alto e o outro em nível baixo, fazendo o motor girar em uma direção ou na direção oposta. A contagem das voltas é feita pelo Timer 1. Ele é configurado com o valor TMOD = 50H, o que coloca o Timer 1 em modo contador externo. O contador é carregado inicialmente com o valor FFF6H. Como o contador do 8051 estoura em FFFFH, carregar o Timer com FFF6H faz com que sejam necessários exatamente 10 pulsos para ocorrer o overflow. Durante o funcionamento normal, o programa lê o valor de TL1 e calcula a quantidade de voltas já realizadas subtraindo F6H. Assim, quando TL1 = F6H, a contagem exibida é 0; quando TL1 = F7H, a contagem é 1; e assim por diante até chegar a 9.




## Uso da interrupção
A interrupção do Timer 1 é usada para tratar automaticamente o momento em que a contagem chega a 10 voltas. O vetor de interrupção do Timer 1 está no endereço 001BH. Quando ocorre o overflow, o programa desvia para a rotina ISR_TIMER1. Dentro dessa rotina, o contador é parado, os registradores TH1 e TL1 são recarregados com FFH e F6H, respectivamente, e a variável de contagem volta para zero. Em seguida, a flag de overflow é limpa e o contador é ligado novamente. 




## Mudança de direção do motor
O sistema também possui uma chave, a SW0, que permite inverter o sentido de rotação do motor. Essa chave é lida pelo pino P2.0. O programa usa o bit F0 para guardar o sentido atual do motor. A cada repetição do laço principal, a rotina VERIFICA_CHAVE compara o estado atual da chave com o valor salvo em F0. Se os dois forem diferentes, significa que o usuário alterou a chave. Quando isso acontece, a rotina MUDA_DIRECAO é chamada. Ela atualiza o valor de F0, aplica o novo sentido nos pinos P3.0 e P3.1 e reinicia o Timer 1. Esse reset é utilizado porque, ao mudar o sentido do motor, não faria sentido continuar contando as voltas anteriores junto com as novas.





## Indicação visual no display
O display de 7 segmentos mostra a contagem de voltas de 0 a 9. Para isso, o programa utiliza uma tabela chamada TABELA_7SEG, que contém os códigos correspondentes a cada número. Como o display é de ânodo comum, os segmentos são ativos em nível baixo. Ou seja, para acender um segmento, o bit correspondente precisa receber nível lógico 0. Além do número de voltas, o ponto decimal do display é usado como indicação visual do sentido de rotação do motor. Em um dos sentidos, o ponto decimal fica aceso; no outro, fica apagado. Isso é feito manipulando o bit 7 do valor enviado ao display.Quando o programa quer acender o ponto decimal, ele força o bit 7 para 0. Quando quer apagar, força o bit 7 para 1.




## Como testar no EdSim51
Para testar o projeto no EdSim51, deve-se carregar o código Assembly e iniciar a simulação. Com o motor funcionando, o display deve começar mostrando a contagem de voltas de 0 até 9. Ao completar 10 pulsos, a contagem deve voltar automaticamente para 0, indicando que a interrupção do Timer 1 foi executada corretamente. Depois, é possível alterar a chave SW0. Ao mudar a chave, o motor deve inverter o sentido de rotação, a contagem deve ser reiniciada e o ponto decimal do display deve mudar de estado, indicando visualmente a alteração do sentido.




## Conclusão
Com esse projeto, foi possível implementar um sistema simples de dosagem rotativa utilizando recursos importantes do microcontrolador 8051. O Timer 1 foi usado como contador externo para contar os pulsos gerados pelo motor, enquanto a interrupção foi responsável por reiniciar automaticamente a contagem ao atingir 10 voltas. Por fim, também foi implementada a mudança de direção do motor por meio de uma chave, com reinício da contagem sempre que o sentido é alterado. Além disso, o display de 7 segmentos permite acompanhar a contagem em tempo real, e o ponto decimal serve como indicação visual do sentido de rotação. 
