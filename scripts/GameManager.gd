extends Node

@onready var table4_4 = $tablegrid
var c1
var c2
var deck = Array()
var matchTimer = Timer.new()
var flipTimer = Timer.new()

func _ready():
	print_tree_pretty()
	fillDeck()
	dealDeck()
	setupTimers()

func setupTimers():
	flipTimer.connect("timeout", Callable(self, "turnOverCards"))
	flipTimer.set_one_shot(true)
	add_child(flipTimer)
	
	matchTimer.connect("timeout", Callable(self, "matchCardsAndScore"))
	matchTimer.set_one_shot(true)
	add_child(matchTimer)

func fillDeck():
	var i = 1
	var j = 1
	while i < 5:
		while j < 5:
			deck.append(Card.new(i))
			j += 1
		j = 1
		i = i+1

func dealDeck():
	var c = 0
	while c < 16:
		table4_4.add_child(deck[c])
		c += 1

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
	else:
		flipTimer.start(0.7)

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
