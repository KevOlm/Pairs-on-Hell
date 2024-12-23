extends Node

@onready var pausemenu = $PauseMenu
@onready var tablex_x = $tablegrid
@onready var opponent = $Players_Life/Opponent/Score
@onready var player = $Players_Life/Player/Score
@onready var gameover = $GameOver
@onready var gameovermenu = $GameOver/GameOver
var c1
var c2
var deck = Array()
var random = RandomNumberGenerator.new()
var opponentTimer = Timer.new()
var matchTimer = Timer.new()
var flipTimer = Timer.new()
var opponent_life = 3
var player_life = 3
var turn = true
var paused_menu = false
var game_no_cards = 0

func _ready():
	fillDeck()
	dealDeck()
	setupTimers()
	player.text = str(player_life)
	opponent.text = str(opponent_life)
	CardOptions4()

func setupTimers():
	flipTimer.connect("timeout", Callable(self, "turnOverCards"))
	flipTimer.set_one_shot(true)
	add_child(flipTimer)
	
	matchTimer.connect("timeout", Callable(self, "matchCardsAndScore"))
	matchTimer.set_one_shot(true)
	add_child(matchTimer)
	
	opponentTimer.connect("timeout", Callable(self, "opponentTurn"))
	opponentTimer.set_one_shot(true)
	add_child(opponentTimer)

func fillDeck():
	var cardrepeat = 0
	var randomnum
	match get_tree().current_scene.name:
		"table4_4":
			deck.resize(16)
			for cardnum in range(1,5):
				while cardrepeat < 4:
					randomnum = random.randi_range(0,15)
					if deck[randomnum] == null:
						deck[randomnum] = Card.new(cardnum,1)
						cardrepeat+=1
				cardrepeat = 0
		"table6_4":
			deck.resize(24)
			for cardnum in range(1,6):
				match cardnum:
					4:
						cardrepeat = 2
					5:
						cardrepeat = 4
				while cardrepeat < 6:
					randomnum = random.randi_range(0,23)
					if deck[randomnum] == null:
						deck[randomnum] = Card.new(cardnum,1)
						cardrepeat+=1
				cardrepeat = 0
		"table8_5":
			deck.resize(40)
			for cardnum in range(1,6):
				while cardrepeat < 8:
					randomnum = random.randi_range(0,39)
					if deck[randomnum] == null:
						deck[randomnum] = Card.new(cardnum,1)
						cardrepeat+=1
				cardrepeat = 0

func dealDeck():
	var c = 0
	match get_tree().current_scene.name:
		"table4_4":
			while c < 16:
				tablex_x.add_child(deck[c])
				c += 1
		"table6_4":
			while c < 24:
				tablex_x.add_child(deck[c])
				c += 1
		"table8_5":
			while c < 40:
				tablex_x.add_child(deck[c])
				c += 1

func opponentTurn():
	var a
	var count = 0
	var val
	while count < 2:
		match get_tree().current_scene.name:
			"table4_4":
				val = random.randi_range(0,15)
			"table6_4":
				val = random.randi_range(0,23)
			"table8_5":
				val = random.randi_range(0,39)
		a = tablex_x.get_child(val)
		if a.disabled:
			pass
		else:
			a.flip()
			if count == 0:
				c1 = a
				c1.set_disabled(true)
			else:
				c2 = a
				c2.set_disabled(true)
			count+=1
	turn = false
	checkCards()

func chooseCard(c):
	if c1 == null:
		c1 = c
		c1.flip()
		c1.set_disabled(true)
	elif c2 == null:
		c2 = c
		c2.flip()
		c2.set_disabled(true)
		checkCards()

func checkCards():
	if c1.value == c2.value:
		matchTimer.start(0.7)
		game_no_cards += 1
		PowerCard(c1.value)
	else:
		flipTimer.start(0.7)
	if turn:
		opponentTimer.start(0.9)
	else:
		turn = true
	gameOver()

func gameOver():
	match get_tree().current_scene.name:
		"table4_4":
			if game_no_cards==8:
				gameOverMenu()
		"table6_4":
			if game_no_cards==12:
				gameOverMenu()
		"table8_5":
			if game_no_cards==20:
				gameOverMenu()
		_:
			pass
	if player_life==0 or opponent_life==0:
		gameOverMenu()

func gameOverMenu():
	gameover.show()
	if player_life >= opponent_life:
		gameovermenu.winner("Player Wins")
	else:
		gameovermenu.winner("CPU Wins")

func PowerCard(value):
	match value:
		1:
			if turn:
				turn = false
			else:
				turn = true
				opponentTimer.start(0.9)
		2:
			if turn:
				opponent_life -= 1
				opponent.text = str(opponent_life)
			else:
				player_life -= 1
				player.text = str(player_life)
		3:
			if turn:
				player_life +=1
				player.text = str(player_life)
			else:
				opponent_life += 1
				opponent.text = str(opponent_life)
		4:
			if turn:
				CardOptions4pop()
			else:
				PowerCard(random.randi_range(1,3))
		5:
			pass

func CardOptions4():
	var container = $CardOptions4/HBoxContainer
	for button in container.get_children():
		if button is TextureButton:
			button.pressed.connect(func(): pressed_action(button.name))

func CardOptions4pop():
	$CardOptions4.popup_centered(Vector2(450, 150))
	get_tree().paused = true

func pressed_action(b):
	match b:
		"club":
			PowerCard(1)
		"spade":
			PowerCard(2)
		"heart":
			PowerCard(3)
	get_tree().paused = false
	$CardOptions4.hide()

func turnOverCards():
	c1.flip()
	c2.flip()
	c1.set_disabled(false)
	c2.set_disabled(false)
	c1 = null
	c2 = null

func matchCardsAndScore():
	c1.set_modulate(Color(0.6,0.6,0.6,0.5))
	c2.set_modulate(Color(0.6,0.6,0.6,0.5))
	c1 = null
	c2 = null

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		pauseMenu()

func pauseMenu():
	if paused_menu:
		pausemenu.hide()
		get_tree().paused = false
	else:
		pausemenu.show()
		get_tree().paused = true
	paused_menu = !paused_menu
