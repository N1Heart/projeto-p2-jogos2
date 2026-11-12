extends Node2D
# Regras do Territorio: vence ao somar 60 s dentro da zona, perde quando a vida acaba.
# Aula 09, feito com ajuda de IA (Claude).

@export var meta: float = 60.0
@export var cena_ladrao: PackedScene
@export var maximo_de_ladroes: int = 8

var tempo_na_zona := 0.0
var acabou := false
# por enquanto os ladroes entram pelas quatro pontas da rua
var entradas: Array[Vector2] = [Vector2(312, 24), Vector2(312, 360), Vector2(24, 200), Vector2(616, 200)]

@onready var jogador: CharacterBody2D = $Jogador
@onready var zona: Area2D = $Zona
@onready var hud: CanvasLayer = $HUD
@onready var seta: Node2D = $Seta
@onready var nascer: Timer = $Nascer


func _ready() -> void:
	jogador.vida_mudou.connect(hud.mostrar_vida)
	jogador.morreu.connect(_on_jogador_morreu)
	nascer.timeout.connect(_nascer_ladrao)
	hud.mostrar_vida(jogador.vida)
	hud.mostrar_tempo(0, meta)


func _process(delta: float) -> void:
	if acabou:
		return
	if zona.jogador_dentro():
		tempo_na_zona = min(tempo_na_zona + delta, meta)  # soma e nao zera ao sair
		if tempo_na_zona >= meta:
			_fim(true)
	hud.mostrar_tempo(tempo_na_zona, meta)
	hud.mostrar_mudanca(zona.restante)
	_apontar_seta()


# a seta em volta do jogador aponta para a zona quando ela esta longe
func _apontar_seta() -> void:
	var ate_a_zona := zona.global_position - jogador.global_position
	seta.visible = ate_a_zona.length() > 40.0
	seta.global_position = jogador.global_position + ate_a_zona.normalized() * 20.0
	seta.rotation = ate_a_zona.angle()


func _nascer_ladrao() -> void:
	if get_tree().get_nodes_in_group("ladroes").size() >= maximo_de_ladroes:
		return
	var ladrao: Node2D = cena_ladrao.instantiate()
	ladrao.position = entradas.pick_random()
	add_child(ladrao)


func _on_jogador_morreu() -> void:
	await get_tree().create_timer(0.8).timeout  # deixa a animacao de dor tocar
	_fim(false)


func _fim(venceu: bool) -> void:
	if acabou:
		return
	acabou = true
	nascer.stop()
	hud.mostrar_fim(venceu)
	get_tree().paused = true
