extends CharacterBody2D
# Ladrao de teste da Aula 09: anda reto ate o jogador. Feito com ajuda de IA (Claude).
# Na Aula 10 ele ganha a maquina de estados e passa a contornar as casas.

@export var velocidade: float = 40.0
@export var vida: int = 1          # quantos golpes aguenta
@export var dano: int = 1
@export var distancia_do_toque: float = 12.0

var jogador: Node2D


func _ready() -> void:
	add_to_group("ladroes")
	jogador = get_tree().get_first_node_in_group("jogador")


func _physics_process(_delta: float) -> void:
	if jogador == null:
		return
	velocity = global_position.direction_to(jogador.global_position) * velocidade
	move_and_slide()
	if global_position.distance_to(jogador.global_position) < distancia_do_toque:
		jogador.receber_dano(dano)


# chamada pelo golpe do jogador
func levar_golpe(_de_onde: Vector2) -> void:
	vida -= 1
	if vida <= 0:
		queue_free()
