# DEVLOG

## Aula 08 -- 07/10 (feita em 28/10)

O que fiz: a vila vista de cima com rua em cruz, casas, árvores, cerca e muro, em duas camadas (chao e objetos), e o personagem andando nas quatro direções com a câmera presa nos limites da vila (640 x 384).
O que travou: o projeto não subia para o GitHub. Eu tinha baixado o repositório como ZIP, então a pasta não tinha o .git e o git não via nada.
Como resolvi: fiz o git clone do repositório, passei o projeto para dentro da pasta do clone e refiz os commits parte por parte. Usei IA (Claude) para revisar as partes e conferir a colisão.

## Aula 09 -- 21/10 (feita em 10/11)

O que fiz: troquei o personagem pelo cavaleiro, com animações de parado, correndo, golpe e dor. Coloquei vida (5), dano com um tempo de invencível, o golpe com uma Area2D na frente do cavaleiro, a zona do Território que muda de lugar a cada 15 s, o contador de 60 s, a vitória, a derrota e o R para recomeçar. Os ladrões ainda são retângulos que andam reto até o jogador.
O que travou: (escreva aqui o que travou para você)
Como resolvi: (escreva aqui como resolveu)

## Aula 10 -- 28/10 (feita em 10/11)

O que fiz: o ladrão ganhou uma máquina de estados com três estados: indo para a zona, perseguindo e atordoado. Ele anda pela malha de navegação (NavigationRegion2D gerada da colisão da camada objetos, com NavigationAgent2D), então contorna as casas, as árvores e a cerca da horta. Agora são dois ladrões: o leve, com 1 de vida, e o pesado, com 2. Os dois nascem em pontos sorteados junto ao muro.
O que travou: (escreva aqui o que travou para você)
Como resolvi: (escreva aqui como resolveu)
