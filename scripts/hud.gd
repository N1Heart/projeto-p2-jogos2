extends CanvasLayer
# Textos da tela: tempo na zona, vida e a mensagem de fim. Aula 09, feito com ajuda de IA (Claude).
# O HUD continua rodando com o jogo pausado (process_mode = Always), para ouvir o R.

@onready var tempo: Label = $Tempo
@onready var barra: ProgressBar = $Barra
@onready var vida: Label = $Vida
@onready var muda: Label = $Muda
@onready var mensagem: Label = $Mensagem


func mostrar_tempo(segundos: float, meta: float) -> void:
	tempo.text = "Zona: %d / %d s" % [int(segundos), int(meta)]
	barra.max_value = meta
	barra.value = segundos


func mostrar_vida(quanto: int) -> void:
	vida.text = "Vida: %d" % quanto


func mostrar_mudanca(segundos: float) -> void:
	muda.text = "A zona muda em %d s" % ceili(segundos)


func mostrar_fim(venceu: bool) -> void:
	if venceu:
		mensagem.text = "VITÓRIA!\nO território do mercado é seu.\n\nAperte R para jogar de novo"
	else:
		mensagem.text = "DERROTA\nOs ladrões tomaram o mercado.\n\nAperte R para jogar de novo"
	mensagem.visible = true


func _unhandled_input(evento: InputEvent) -> void:
	if mensagem.visible and evento.is_action_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
