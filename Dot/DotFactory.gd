extends Node

var dot_pool = []
var pool_last = -1
const Dot = preload("res://Dot/Dot.tscn")
var total_dots = 0

func _ready():
	_init_pool()
	_add_stat_print_timer()

func _init_pool():
	dot_pool.resize(1000)

func _pool_push(dot):
	self.pool_last += 1
	self.dot_pool[self.pool_last] = dot
	dot.is_pooled = true
	
	
func _pool_pop():
	var dot = self.dot_pool[self.pool_last]
	dot.is_pooled = false
	# self.dot_pool[self.pool_last] = null
	self.pool_last -= 1
	return dot


func _add_stat_print_timer():
	var t = Timer.new()
	t.wait_time = 60
	t.one_shot = false
	t.autostart = true
	t.connect("timeout", self, "print_stats")
	add_child(t)

func print_stats():
	var pool_size = self.pool_last + 1
	print("pool size = " + str(pool_size))
	print("total dots = " + str(self.total_dots))
	print("active dots = " + str(self.total_dots - pool_size))

func build_dot():
	if pool_last > -1:
		return _pool_pop()
	else:
		total_dots += 1
		return Dot.instance()


func recycle(dot):
	call_deferred("_recycle", dot)
	
func _recycle(dot):
	if dot == null:
		print("Tried to recycle null (DotFactory.recycle())")
		return
	if !dot.name.match("*Dot*") or dot.name == "Dots":
		print("Tried to recycle '" + dot.name + "', which isn't a dot (DotFactory.recycle())")
		return
		
	
	if dot.is_pooled:
		return
		
	
	var dots = dot.get_parent()
	if dots != null:
		dots.remove_child(dot)
	
	dot.from_arrows = null
	_pool_push(dot)
	
