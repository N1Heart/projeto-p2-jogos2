# DEVLOG

Usei IA (Claude) durante o projeto como auxiliar durante o desenvolvimento da inteligencia dos inimigos Os scripts dizem no comentário do topo o que veio do roteiro e o que foi feito com ajuda da IA.

## Aula 08 -- 07/10 (feita em 28/10 e 04/11)

O que fiz: a vila vista de cima com rua em cruz, casas, árvores, cerca e muro, em duas camadas (chao e objetos), e o personagem andando nas quatro direções com a câmera presa nos limites da vila (640 x 384).
O que travou: o projeto não aparecia no GitHub. Os meus commits de outubro só tinham as imagens (tileset, personagem e bandidos); o project.godot, as cenas e o .gitignore nunca tinham entrado num commit. Depois, os patches da aula não aplicavam, porque os arquivos .import das imagens tinham sido gerados pela Godot do laboratório e eram diferentes dos meus.
Como resolvi: guardei a bagunça com git stash, refiz os patches em cima do commit que estava no GitHub e apliquei um por vez com git am. Antes de cada patch, rodava git restore nos arquivos que a Godot tinha mexido sozinha ao abrir o projeto.

## Aula 09 -- 21/10 (feita em 10/11 e 11/11)

O que fiz: troquei o personagem pelo cavaleiro, com animações de parado, correndo, golpe e dor. Coloquei vida (5), dano com um tempo de invencível, o golpe com uma Area2D na frente do cavaleiro, a zona do Território que muda de lugar a cada 15 s, o contador de 60 s, a vitória, a derrota e o R para recomeçar. Os ladrões ainda eram retângulos que andavam reto até o jogador.
O que travou: o primeiro patch não aplicava no entities/jogador.tscn ("patch does not apply"). A Godot regrava nesse arquivo qual animação está selecionada no editor, e eu tinha aberto a cena. Também caí em outros erros de git: esqueci o git add -A antes do commit, e deixei os arquivos .patch dentro da pasta do repositório, onde iriam junto no commit.
Como resolvi: fiz primeiro o commit do cavaleiro, apliquei o patch com git apply --exclude=entities/jogador.tscn e coloquei o jogador.tscn pronto no lugar. Movi os patches para uma pasta fora do repositório e passei a rodar git add -A antes de todo commit.

## Aula 10 -- 28/10 (feita em 11/11)

O que fiz: o ladrão ganhou uma máquina de estados com três estados: indo para a zona, perseguindo e atordoado. Ele anda pela malha de navegação (NavigationRegion2D gerada da colisão da camada objetos, com NavigationAgent2D), então contorna as casas, as árvores e a cerca da horta. Agora são dois ladrões: o leve, com 1 de vida, e o pesado, com 2. Os dois nascem em pontos sorteados junto ao muro.
O que travou: os commits da Aula 10 e da Aula 11 subiram sem o prefixo "aula-10:" e "aula-11:" na mensagem, e esqueci de criar as tags aula-10 e aula-11.
Como resolvi: criei as tags depois, cada uma apontando para o último commit da sua aula.

## Aula 11 -- 04/11 (feita em 11/11)

O que fiz: troquei os retângulos pelos bandidos do pacote Bandits. O leve usa o Light Bandit e o pesado usa o Heavy Bandit, com animações de correr, parado, dor e morte. Como os bandidos são desenhados de lado, eles só viram para a esquerda e para a direita. A horda aperta com o tempo. Testei com a horda cheia e o jogo não travou.
O que travou: o jogo ficou difícil demais e eu não conseguia terminar uma partida.
Como resolvi: balanceei os números. A invencibilidade depois do dano passou de 1 s para 1,8 s, a área do golpe passou de 20 x 18 para 32 x 30 px, o ladrão leve caiu de 50 para 40 de velocidade e o pesado de 32 para 26. A horda agora começa com um ladrão a cada 4 s, chega no máximo a um a cada 1,6 s e tem no máximo 14 ao mesmo tempo. Para conferir, um robô jogou 20 partidas: antes perdia todas, depois passou a vencer a maioria. Depois aumentei a vida do cavaleiro de 5 para 30.

## Aula 12 -- 11/11 (feita em 18/11)

O que fiz: coloquei lojas do pacote Market Square na vila para ela ter mais cara de mercado. São cinco lojas ao longo das ruas, cada uma com colisão nas paredes. Refiz a malha de navegação para os ladrões contornarem as lojas e recalculei os pontos onde a zona pode aparecer. Exportei o jogo e publiquei a página: (link da página).
O que travou: a imagem do pacote não é um tileset de 16 px. As lojas têm de 130 a 190 px e estão soltas na folha, então o "criar peças automaticamente" da Godot cortou as lojas em mais de 2.800 pedaços.
Como resolvi: descartei aquele TileSet e usei cada loja inteira como um Sprite2D com AtlasTexture (só o retângulo da loja), dentro de um StaticBody2D, em escala 0,5 para ficar do tamanho das casas do Tiny Town.

## Aula 13 -- 18/11

O que fiz: uma tela de início. Antes, o jogo começava assim que abria, e os ladrões já vinham antes de eu pegar o teclado. Agora a cena começa pausada (get_tree().paused = true), com o cavaleiro no cruzamento e uma tela com o objetivo e os controles. O HUD continua rodando com o jogo pausado e despausa na primeira tecla de movimento, no golpe ou num clique. Depois, apresentação em sala.
O que travou: (preencher depois da apresentação)
Como resolvi: (preencher depois da apresentação)
