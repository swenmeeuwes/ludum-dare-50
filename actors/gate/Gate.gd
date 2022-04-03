extends Sprite

export (Texture) var gate_open_tex

const amount_of_runes = 6

var gate_is_open = false

# index [1..6]
func turn_on_rune(index):
	var rune = get_node("Rune" + str(index))
	if not rune:
		return
	
	print("lighting rune " + str(index))
	rune.turn_on()
	
	if check_if_gate_can_open():
		open_gate()

func check_if_gate_can_open():
	for n in range(1, amount_of_runes + 1):
		var rune = get_node("Rune" + str(n))
		if not rune.is_on:
			return false
	
	return true

func open_gate():
	print('open gate!')
	gate_is_open = true
	texture = gate_open_tex
	for n in range(1, amount_of_runes + 1):
		var rune = get_node("Rune" + str(n))
		rune.hide()
