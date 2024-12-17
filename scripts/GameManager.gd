extends Node

@onready var pausemenu = $CanvasLayer
@onready var table4_4 = $tablegrid
@onready var opponent = $Players_Life/Opponent/Score
@onready var player = $Players_Life/Player/Score
var c1
var c2
var deck = Array()
var deckposition = []
var random = RandomNumberGenerator.new()
var matchTimer = Timer.new()
var flipTimer = Timer.new()
var opponent_life = 3
var player_life = 3
var turn = true
var paused = false

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
			a._pressed()
			count+=1
	turn = false

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
		PowerCard(c1.value)
	else:
		flipTimer.start(0.7)
	if turn:
		opponentTurn()
	else:
		turn = true

func PowerCard(value):
	match value:
		1:
			pass
		2:
			opponent_life -= 1
			opponent.text = str(opponent_life)
		3:
			player_life +=1
			player.text = str(player_life)
		4:
			CardOptions4pop()

func CardOptions4():
	$CardOptions4.exclusive = true
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
	if paused:
		pausemenu.hide()
		get_tree().paused = false
	else:
		pausemenu.show()
		get_tree().paused = true
	paused = !paused
