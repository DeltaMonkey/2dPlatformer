extends KinematicBody2D

#değerler deneyerek bulunabilir 100 ile başla deneye deneye git
var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 125
var horizontalAcceleration = 2000
var jumpSpeed = 360
var jumpTerminationMultiplier = 3

func _ready():
	pass 
	
func _process(delta):
	var moveVector = get_movement_vector()

	velocity.x += moveVector.x * horizontalAcceleration * delta;
	
	# eğer moveVector.x 0 ise kullanıcı sağa sola gitmeye çalışmıyor artık biz bir yavaşlayalım
	if(moveVector.x == 0):
		#lineer interpolasyon ile hızımızı 0'a yaklaştırıyoruz
		velocity.x = lerp(velocity.x, 0, pow(2, -50 * delta))
		
	# hızımızı(velocity) maxHorizontalSpeed ile sınırlandırıyoruz ki uçmayalım
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# kullanıcı -1 (yukarı) yönlü bir hareket yapmış(zıplamış) ve player hala yerde ise zıola
	if(moveVector.y < 0 && ( is_on_floor() || !$CoyoteTimer.is_stopped())):
		velocity.y = moveVector.y * jumpSpeed

	# player havadaysa ama zıplama tuşuna basmıyorsa (elini hemen çekmişse)
	if(velocity.y < 0 && !Input.is_action_pressed("jump")):
		# normalden 3 kat daha fazla yer çekimi etkisinde bırakarak hızlı zıplamayı limitliyoruz
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	var wasOnFloor = is_on_floor();
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(wasOnFloor != is_on_floor()):
		$CoyoteTimer.start();
	
	update_animation();

func get_movement_vector():
	var moveVector = Vector2.ZERO
	# sağ taraf +1 yönü
	# sol taraf -1 yönü
	# sağ için 1-0 = +1 yönü | sol için 0-1 = -1 | hareketsiz 1-1 = 0 
	moveVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector

func update_animation():
	var moveVector = get_movement_vector()
	
	if(!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif(moveVector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

	# eğer kullanıcı sağa sola gitmeye çalışmıyorsa son döndüğü yerde kalmasını sağlıyoruz 
	if(moveVector.x != 0):
		# karakter sprite'ım default olarak sola baktığı için sola gittim zaman flip yapmama gerek yok 
		# sağ tarafa gittiğimde flip etmeme gerek var
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false
