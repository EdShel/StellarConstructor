extends Timer

var pistons: Array[Piston] = []

func _ready() -> void:
	SC.piston_added.connect(handle_piston_added)
	SC.piston_removed.connect(handle_piston_removed)

func handle_piston_added(piston: Piston) -> void:
	pistons.push_back(piston)
	
func handle_piston_removed(piston: Piston) -> void:
	pistons.erase(piston)

func _on_timeout() -> void:
	pistons.shuffle()
	for piston in pistons:
		piston.try_shooting()
