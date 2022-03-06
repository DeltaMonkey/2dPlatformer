extends Camera2D

var targetPosition = Vector2.ZERO
var followYLimit = 1

export(Color, RGB) var backgroundColor

func _ready():
	# editörün varsayılan clear color değerini background için değiştiriyoruz
	VisualServer.set_default_clear_color(backgroundColor);

func _process(delta):
	_acquire_target_position()
	_showFps()
	
	# y pozisyonunda oluşan küçük dalgalanmalarda kameranın hareket ederek
	# titreşime sebep olamaması için Y takibi için limit koyduk
	var targetPoisitonSmoothed = targetPosition;
	if(abs(global_position.y - targetPosition.y) < followYLimit):
		targetPoisitonSmoothed = Vector2(targetPosition.x, global_position.y) 
	
	# kameradan target posizyona lineer interpolasyon ile yaklaşıyoruz
	# 0.2 deneyerek, sabit bir görüntü oluşturduğundan kafama göre verilmiştir :D
	global_position = lerp(global_position, targetPoisitonSmoothed, 0.2);
	print(global_position.y)
	
func _showFps():
	$fps.text = str(Engine.get_frames_per_second())

func _acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if(players.size() > 0):
		# get_nodes_in_group player grubunu bir liste olarak döner ancak grupta yalnızca 1 item var
		var player = players[0]
		targetPosition =  player.global_position
