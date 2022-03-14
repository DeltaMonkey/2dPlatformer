extends Node

# player sahnesini çekiyoruz objec olarak kullanabileceğiz
var playerScene = preload("res://scenes/player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

func _ready():
	# ekrandaki ilk player objesinin konumu default yeniden doğma pozisyonumuz olacak
	spawnPosition = $player.global_position
	register_player($player)
	
# şimdi aktif olan player objesini alır
# "died" eventini(e) observe eder (connect olur)
func register_player(player):
	# current playeri global setliyoruz çünkü on_player_died methodu içinde kendisini kullanacağız
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
																 # connect deferred, died eventlerini
																 # bir kuyruğa alır ve boş zamanında çalıştırır
																 # yoksa Area2d, bir collision sürecini koşarken
																 # diğer frame'e geçene kadar işini bitirememiş ise
																 # state'e erişemeyip patlıyor

func on_player_died():
	currentPlayerNode.queue_free() # var olan playerı öldür(BELLEKTEN SİL)
	create_player() # git yeni player oluştur

# player sahnesinden yeni instance alır 
# onu var olan nodelar içerisinde var olan playerın altına oluşturur
# var olan player bellekten silindiği için eski player ile yeni player yer değiştirmiş olur
func create_player():
	var playerInstance = playerScene.instance()
	playerInstance.global_position = spawnPosition
	add_child_below_node(currentPlayerNode, playerInstance) # yeni playerın eklenmesi
	register_player(playerInstance) # yeni oluşturulan playerin died eventine connect olunur
