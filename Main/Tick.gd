extends Timer

func _ready():
	self.connect("timeout", self, "tick")

func tick():
	var tickers = get_tree().get_nodes_in_group("Tickers")
	for t in tickers:
		t.tick()
