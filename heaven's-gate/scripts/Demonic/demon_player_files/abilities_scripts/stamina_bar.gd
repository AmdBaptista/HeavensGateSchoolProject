extends ProgressBar

var parent
var max_value_amount
var min_value_amount

func _ready():
	parent = get_parent()
	max_value_amount = parent.max_stamina
	min_value_amount = parent.min_stamina

func _process(delta):
	self.value = parent.current_stamina
