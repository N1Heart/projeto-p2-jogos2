extends Node2D
# Regras do Territorio: vence ao somar 60 s dentro da zona, perde quando a vida acaba.
# Aula 09, feito com ajuda de IA (Claude). Horda que aperta com o tempo: Aula 11.

@export var meta: float = 60.0
@export var cena_leve: PackedScene
@export var cena_pesado: PackedScene
@export var chance_de_pesado: float = 0.3
@export var maximo_de_ladroes: int = 25
@export var intervalo_inicial: float = 3.0   # segundos entre um ladrao e outro no comeco
@export var intervalo_minimo: float = 0.8    # o mais rapido que a horda chega

var tempo_na_zona := 0.0
var acabou := false

@onready var jogador: CharacterBody2D = $Jogador
@onready var zona: Area2D = $Zona
@onready var hud: CanvasLayer = $HUD
@onready var seta: Node2D = $Seta
@onready var nascer: Timer = $Nascer


func _ready() -> void:
	jogador.vida_mudou.connect(hud.mostrar_vida)
	jogador.morreu.connect(_on_jogador_morreu)
	nascer.wait_time = intervalo_inicial
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
	# cada ladrao que nasce deixa o proximo vir um pouco mais cedo
	nascer.wait_time = max(intervalo_minimo, nascer.wait_time * 0.95)
	var cena := cena_leve
	if randf() < chance_de_pesado:
		cena = cena_pesado
	var ladrao: Node2D = cena.instantiate()
	ladrao.position = _ponto_na_borda()
	add_child(ladrao)


# um ponto qualquer junto ao muro, longe do jogador e dentro da malha de navegacao
func _ponto_na_borda() -> Vector2:
	var mapa := get_world_2d().navigation_map
	var ponto := Vector2.ZERO
	for tentativa in 10:
		match randi() % 4:
			0: ponto = Vector2(randf_range(24, 616), 24)    # muro de cima
			1: ponto = Vector2(randf_range(24, 616), 360)   # muro de baixo
			2: ponto = Vector2(24, randf_range(24, 360))    # muro da esquerda
			3: ponto = Vector2(616, randf_range(24, 360))   # muro da direita
		ponto = NavigationServer2D.map_get_closest_point(mapa, ponto)
		if ponto.distance_to(jogador.global_position) > 120.0:
			break
	return ponto


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
