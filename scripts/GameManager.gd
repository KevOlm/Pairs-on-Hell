extends Node

@onready var pausemenu = $PauseMenu
@onready var table4_4 = $tablegrid
@onready var opponent = $Players_Life/Opponent/Score
@onready var player = $Players_Life/Player/Score
@onready var gameover = $GameOver
@onready var gameovermenu = $GameOver/GameOver
var c1
var c2
var deck = Array()
var deckposition = []
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
	deckposition.resize(16)
	for cardnum in range(1,5):
		while cardrepeat < 4:
			randomnum = random.randi_range(0,15)
			if deckposition[randomnum] == null:
				deckposition[randomnum] = cardnum
				cardrepeat+=1
		cardrepeat = 0
	for i in 16:
		deck.append(Card.new(deckposition[i],1))

func dealDeck():
	var c = 0
	while c < 16:
		table4_4.add_child(deck[c])
		c += 1

func opponentTurn():
	var a
	var count = 0
	var val
	while count < 2:
		val = random.randi_range(0,15)
		a = table4_4.get_child(val)
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
	if game_no_cards==8 or player_life==0 or opponent_life==0:
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
	get_tree().paused = false

func CardOptions4():
	var container = $CardOptions4/HBoxContainer
	for button in container.get_children():
		if button is TextureButton:
			button.pressed.connect(func(): pressed_action(button.name))

func CardOptions4pop():
	$CardOptions4.popup_centered(Vector2(450, 150))

func pressed_action(b):
	match b:
		"club":
			PowerCard(1)
		"spade":
			PowerCard(2)
		"heart":
			PowerCard(3)
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

func _process(delta):
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
