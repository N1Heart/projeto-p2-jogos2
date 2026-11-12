extends CharacterBody2D
# Movimento: roteiro da Aula 08 (Prof. Ezefferth), parte 3.5.
# Animacoes do cavaleiro, ataque, vida e dano: Aula 09, feito com ajuda de IA (Claude).

signal vida_mudou(vida: int)
signal morreu

@export var velocidade: float = 70.0
@export var alcance_do_golpe: float = 14.0
@export var vida_maxima: int = 5
@export var tempo_invencivel: float = 1.0  # depois de levar dano, fica um tempo sem levar outro

var vida: int
var atacando := false
var invencivel := false
var morto := false
var olhando := Vector2.RIGHT  # para onde o golpe vai: direita, esquerda, cima ou baixo

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var golpe: Area2D = $Golpe


func _ready() -> void:
	vida = vida_maxima
	add_to_group("jogador")
	anim.animation_finished.connect(_on_animacao_terminou)
	anim.frame_changed.connect(_on_quadro_mudou)
	anim.play("idle")


func _physics_process(_delta: float) -> void:
	if morto:
		return
	if Input.is_action_just_pressed("attack") and not atacando:
		_atacar()

	var direcao := Input.get_vector("left", "right", "up", "down")
	if atacando:
		direcao = Vector2.ZERO  # parado enquanto golpeia
	velocity = direcao * velocidade
	move_and_slide()

	if direcao != Vector2.ZERO:
		olhando = _quatro_direcoes(direcao)
		if direcao.x != 0:
			anim.flip_h = direcao.x < 0  # o desenho olha para a direita

	if atacando:
		return
	if anim.animation == "hurt" and anim.is_playing():
		return  # deixa a animacao de dor terminar
	if direcao == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("run")


# arredonda a direcao do analogico/teclado para uma das quatro
func _quatro_direcoes(d: Vector2) -> Vector2:
	if abs(d.x) > abs(d.y):
		return Vector2(sign(d.x), 0)
	return Vector2(0, sign(d.y))


func _atacar() -> void:
	atacando = true
	golpe.position = olhando * alcance_do_golpe
	anim.play("hit")


# o golpe acerta no quadro 2 da animacao, o do risco branco
func _on_quadro_mudou() -> void:
	if anim.animation == "hit" and anim.frame == 2:
		for corpo in golpe.get_overlapping_bodies():
			if corpo.has_method("levar_golpe"):
				corpo.levar_golpe(olhando)


func _on_animacao_terminou() -> void:
	if anim.animation == "hit":
		atacando = false


# chamada pelo ladrao quando encosta no jogador
func receber_dano(quanto: int) -> void:
	if invencivel or morto:
		return
	vida = max(vida - quanto, 0)
	vida_mudou.emit(vida)
	atacando = false
	anim.play("hurt")
	if vida == 0:
		morto = true
		morreu.emit()
		return
	invencivel = true
	var pisca := create_tween().set_loops(5)
	pisca.tween_property(anim, "modulate:a", 0.3, tempo_invencivel / 10.0)
	pisca.tween_property(anim, "modulate:a", 1.0, tempo_invencivel / 10.0)
	await get_tree().create_timer(tempo_invencivel).timeout
	invencivel = false
