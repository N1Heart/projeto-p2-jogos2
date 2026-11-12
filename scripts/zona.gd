extends Area2D
# Zona do Territorio: o jogador soma tempo enquanto esta dentro dela,
# e de tempos em tempos ela muda de lugar. Aula 09, feito com ajuda de IA (Claude).

signal mudou_de_lugar

@export var intervalo: float = 15.0  # segundos ate mudar de lugar
# pontos livres da vila (sem casa, arvore nem cerca), achados com uma consulta de fisica
@export var pontos: Array[Vector2] = [
	Vector2(312, 200), Vector2(592, 120), Vector2(48, 184), Vector2(144, 336),
	Vector2(472, 240), Vector2(264, 48), Vector2(360, 336), Vector2(400, 104),
]

var restante: float

@onready var visual: CanvasItem = $Visual


func _ready() -> void:
	position = pontos[0]
	restante = intervalo


func _process(delta: float) -> void:
	restante -= delta
	# pisca nos ultimos 3 segundos, avisando que vai mudar
	if restante < 3.0:
		visual.modulate.a = 0.4 + 0.6 * abs(sin(restante * 8.0))
	else:
		visual.modulate.a = 1.0
	if restante <= 0.0:
		mudar_de_lugar()


func mudar_de_lugar() -> void:
	var novo := position
	while novo == position:
		novo = pontos.pick_random()
	position = novo
	restante = intervalo
	mudou_de_lugar.emit()


# a mascara da zona so enxerga a camada do jogador, entao qualquer corpo dentro e ele
func jogador_dentro() -> bool:
	return has_overlapping_bodies()
