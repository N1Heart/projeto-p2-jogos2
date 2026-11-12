extends CharacterBody2D
# Ladrao com maquina de estados. Aula 10, feito com ajuda de IA (Claude).
#   INDO_PARA_A_ZONA: o ladrao disputa o territorio e vai ate a zona.
#   PERSEGUINDO: viu o jogador perto e corre atras dele.
#   ATORDOADO: levou um golpe, e empurrado para tras e fica um instante sem agir.
# O caminho vem do NavigationAgent2D, que usa a malha da Navegacao e contorna casas e arvores.
# Arte dos bandidos e morte animada: Aula 11.

enum Estado { INDO_PARA_A_ZONA, PERSEGUINDO, ATORDOADO }

@export var velocidade: float = 45.0
@export var vida: int = 1                  # quantos golpes aguenta: leve 1, pesado 2
@export var dano: int = 1
@export var raio_de_visao: float = 90.0     # mais perto que isso, comeca a perseguir
@export var raio_de_desistir: float = 150.0  # mais longe que isso, volta para a zona
@export var distancia_do_toque: float = 12.0
@export var tempo_atordoado: float = 0.4

var estado := Estado.INDO_PARA_A_ZONA
var tempo_no_estado := 0.0
var recalcular := 0.0      # o caminho e recalculado a cada 0,25 s, nao a cada quadro
var empurrao := Vector2.ZERO
var jogador: Node2D
var zona: Node2D

@onready var agente: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("ladroes")
	jogador = get_tree().get_first_node_in_group("jogador")
	zona = get_tree().get_first_node_in_group("zona")


func _physics_process(delta: float) -> void:
	tempo_no_estado += delta
	match estado:
		Estado.INDO_PARA_A_ZONA:
			_indo_para_a_zona(delta)
		Estado.PERSEGUINDO:
			_perseguindo(delta)
		Estado.ATORDOADO:
			_atordoado(delta)
	move_and_slide()
	_animar()


func _animar() -> void:
	if estado == Estado.ATORDOADO:
		sprite.play("hurt")
		return
	if velocity.length() > 1.0:
		sprite.play("run")
		sprite.flip_h = velocity.x > 0  # o desenho do bandido olha para a esquerda
	else:
		sprite.play("idle")


func _mudar_para(novo: Estado) -> void:
	estado = novo
	tempo_no_estado = 0.0
	recalcular = 0.0


func _indo_para_a_zona(delta: float) -> void:
	if _distancia_do_jogador() < raio_de_visao:
		_mudar_para(Estado.PERSEGUINDO)
		return
	_andar_ate(zona.global_position, delta, 0.7)  # mais devagar, so passeando


func _perseguindo(delta: float) -> void:
	if _distancia_do_jogador() > raio_de_desistir:
		_mudar_para(Estado.INDO_PARA_A_ZONA)
		return
	_andar_ate(jogador.global_position, delta, 1.0)
	if _distancia_do_jogador() < distancia_do_toque:
		jogador.receber_dano(dano)


func _atordoado(delta: float) -> void:
	velocity = empurrao
	empurrao = empurrao.move_toward(Vector2.ZERO, 400.0 * delta)
	if tempo_no_estado >= tempo_atordoado:
		_mudar_para(Estado.PERSEGUINDO)


func _andar_ate(alvo: Vector2, delta: float, fator: float) -> void:
	recalcular -= delta
	if recalcular <= 0.0:
		agente.target_position = alvo
		recalcular = 0.25
	if agente.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	var proximo := agente.get_next_path_position()
	velocity = global_position.direction_to(proximo) * velocidade * fator


func _distancia_do_jogador() -> float:
	return global_position.distance_to(jogador.global_position)


# chamada pelo golpe do jogador
func levar_golpe(de_onde: Vector2) -> void:
	vida -= 1
	if vida <= 0:
		_morrer()
		return
	empurrao = de_onde * 120.0
	_mudar_para(Estado.ATORDOADO)
	sprite.modulate = Color(1, 0.4, 0.4)  # pisca vermelho
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.3)


func _morrer() -> void:
	remove_from_group("ladroes")  # ja nao conta na horda nem leva outro golpe
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.play("death")
	var some := create_tween()
	some.tween_property(sprite, "modulate:a", 0.0, 0.6)
	some.tween_callback(queue_free)
