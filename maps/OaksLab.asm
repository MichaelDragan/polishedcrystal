OaksLab_MapScriptHeader:
	def_scene_scripts
	scene_script DoNothingScript, SCENE_OAKSLAB_INTRO
	scene_script DoNothingScript, SCENE_OAKSLAB_GREETED_OLIVE
	scene_script DoNothingScript, SCENE_OAKSLAB_VICTORIA_READY
	scene_script DoNothingScript, SCENE_OAKSLAB_VICTORIA_DONE

	def_callbacks
	callback MAPCALLBACK_OBJECTS, OaksLabCallback_FaceOliveLeft

	def_warp_events
	warp_event  4, 11, PALLET_TOWN, 3
	warp_event  5, 11, PALLET_TOWN, 3

	def_coord_events
	coord_event  4, 10, SCENE_OAKSLAB_INTRO, OliveNoticesScript
	coord_event  5, 10, SCENE_OAKSLAB_INTRO, OliveNoticesScript
	; The only passable corridor tile at Victoria's row -- she blocks column 5,
	; so anyone walking past her in either direction must cross column 4 here.
	; Used as her "sightline" trigger instead of a real trainer sight_range,
	; since OBJECTTYPE_TRAINER's built-in engine can't do BATTLETYPE_CANLOSE.
	coord_event  4,  7, SCENE_OAKSLAB_VICTORIA_READY, TrainerVictoria

	def_bg_events
	bg_event  6,  1, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  7,  1, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  8,  1, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  9,  1, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  0,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  1,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  2,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  3,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  6,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  7,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  8,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  9,  7, BGEVENT_JUMPSTD, difficultbookshelf
	bg_event  4,  0, BGEVENT_JUMPTEXT, OaksLabPoster1Text
	bg_event  5,  0, BGEVENT_JUMPTEXT, OaksLabPoster2Text
	bg_event  0,  1, BGEVENT_JUMPTEXT, OaksLabPCText

	def_object_events
	object_event  2,  1, SPRITE_BOOK_PAPER_POKEDEX, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, PAL_NPC_RED, OBJECTTYPE_COMMAND, jumptext, OaksLabPokedexText, -1
	object_event  5,  7, SPRITE_OLIVE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_OLIVE, OBJECTTYPE_SCRIPT, 0, OliveScript, EVENT_BEAT_VICTORIA
	object_event  6,  3, SPRITE_BALL_CUT_TREE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_ENV_GREEN, OBJECTTYPE_SCRIPT, 0, BulbasaurPokeBallScript, EVENT_BULBASAUR_POKEBALL_IN_OAKS_LAB
	object_event  7,  3, SPRITE_BALL_CUT_TREE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_ENV_RED, OBJECTTYPE_SCRIPT, 0, CharmanderPokeBallScript, EVENT_CHARMANDER_POKEBALL_IN_OAKS_LAB
	object_event  8,  3, SPRITE_BALL_CUT_TREE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_ENV_BLUE, OBJECTTYPE_SCRIPT, 0, SquirtlePokeBallScript, EVENT_SQUIRTLE_POKEBALL_IN_OAKS_LAB

	object_const_def
	const_skip ; Pokedex book
	const OAKSLAB_VICTORIA ; one object, both as pre-pick Olive and post-pick trainer Victoria
	const OAKSLAB_BULBASAUR_BALL
	const OAKSLAB_CHARMANDER_BALL
	const OAKSLAB_SQUIRTLE_BALL

Oak:
	faceplayer
	opentext
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftruefwd .HasStarter
	writetext OakChooseStarterText
	closetext
	end
.HasStarter:
	checkevent EVENT_OPENED_MT_SILVER
	iftruefwd .GiveStarter
	checkevent EVENT_TALKED_TO_OAK_IN_KANTO
	iftruefwd .GiveStarter
	writetext OakWelcomeKantoText
	promptbutton
	setevent EVENT_TALKED_TO_OAK_IN_KANTO
.GiveStarter:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftruefwd .CheckBadges
	checkevent EVENT_GOT_A_POKEMON_FROM_IVY
	iffalsefwd .CheckBadges
	writetext OakLabGiveStarterText
	promptbutton
	waitsfx
	checkevent EVENT_GOT_BULBASAUR_FROM_IVY
	iftruefwd .Charmander
	checkevent EVENT_GOT_CHARMANDER_FROM_IVY
	iftruefwd .Squirtle
	givepoke BULBASAUR, PLAIN_FORM, 10, SITRUS_BERRY
	iffalsefwd .PartyAndBoxFull
	setevent EVENT_GOT_A_POKEMON_FROM_OAK
	sjumpfwd .CheckBadges

.Charmander:
	givepoke CHARMANDER, PLAIN_FORM, 10, SITRUS_BERRY
	iffalsefwd .PartyAndBoxFull
	setevent EVENT_GOT_A_POKEMON_FROM_OAK
	sjumpfwd .CheckBadges

.Squirtle:
	givepoke SQUIRTLE, PLAIN_FORM, 10, SITRUS_BERRY
	iffalsefwd .PartyAndBoxFull
	setevent EVENT_GOT_A_POKEMON_FROM_OAK
	sjumpfwd .CheckBadges

.PartyAndBoxFull:
	writetext OakLabPartyAndBoxFullText
	waitbutton
.CheckBadges:
	checkevent EVENT_OPENED_MT_SILVER
	iftruefwd .CheckPokedex
	checkevent EVENT_BEAT_ELITE_FOUR_AGAIN
	iftruefwd .BattleOak
	readvar VAR_BADGES
	ifequalfwd 16, .Complain1
	ifequalfwd  8, .Complain2
	writetext OakYesKantoBadgesText
	promptbutton
.CheckPokedex:
	checkkeyitem CATCH_CHARM
	iftruefwd .GotCatchCharm
	writetext OakLabCatchMoreText
	promptbutton
	verbosegivekeyitem CATCH_CHARM
	writetext OakLabCatchCharmText
	waitbutton
.GotCatchCharm
	writetext OakLabDexCheckText
	waitbutton
	special ProfOaksPCBoot
	checkkeyitem OVAL_CHARM
	iftruefwd .NoOvalCharm
	setval16 NUM_POKEMON
	special CountSeen
	iffalsefwd .NoOvalCharm
	writetext OakLabSeenAllText
	promptbutton
	verbosegivekeyitem OVAL_CHARM
	writetext OakLabOvalCharmText
	waitbutton
.NoOvalCharm
	checkkeyitem SHINY_CHARM
	iftruefwd .NoShinyCharm
	setval16 NUM_POKEMON
	special CountCaught
	iffalsefwd .NoShinyCharm
	writetext OakLabCaughtAllText
	promptbutton
	verbosegivekeyitem SHINY_CHARM
	writetext OakLabShinyCharmText
	waitbutton
.NoShinyCharm
	jumpthisopenedtext

	text "If you're in the"
	line "area, I hope you"
	cont "come visit again."
	done

.BattleOak:
	checkevent EVENT_LISTENED_TO_OAK_INTRO
	iftruefwd .HeardIntro
	writetext OakMightBeReadyText
	waitbutton
	setevent EVENT_LISTENED_TO_OAK_INTRO
.HeardIntro:
	writetext OakChallengeText
	yesorno
	iffalsefwd .NotReady
	writetext OakSeenText
	waitbutton
	closetext
	winlosstext OakWinText, 0
	; Oak has no object in this room right now (removed for the "library, not
	; lab yet" story phase -- see PROGRESS.md). This whole branch requires
	; EVENT_OPENED_MT_SILVER/EVENT_BEAT_ELITE_FOUR_AGAIN, unreachable this
	; early regardless, but restore setlasttalked OAKSLAB_OAK once Oak has a
	; real object again.
	loadtrainer PROF_OAK, 1
	startbattle
	reloadmapafterbattle
	opentext
	writetext OakOpenMtSilverText
	promptbutton
	setevent EVENT_BEAT_PROF_OAK
	setevent EVENT_OPENED_MT_SILVER
	sjump .CheckPokedex

.NotReady:
	writetext OakRefusedText
	promptbutton
	sjump .CheckPokedex

.Complain1:
	writetext OakNoEliteFourRematchText
	promptbutton
	sjump .CheckPokedex

.Complain2:
	writetext OakNoKantoBadgesText
	promptbutton
	sjump .CheckPokedex

OakChooseStarterText:
	text "Oak: Go ahead and"
	line "choose a #mon"
	cont "to be your"
	cont "partner!"
	done

OakWelcomeKantoText:
	text "Oak: Ah, <PLAYER>!"
	line "It's good of you"

	para "to come all this"
	line "way to Kanto."

	para "What do you think"
	line "of the trainers"

	para "out here?"
	line "Pretty tough, huh?"
	done

OakLabGiveStarterText:
	text "Oak: Oh, so Prof."
	line "Ivy says hello?"

	para "Thanks for convey-"
	line "ing her message,"
	cont "<PLAYER>."

	para "She's a good friend"
	line "of mine."

	para "If she gave you a"
	line "#mon, let me do"
	cont "the same!"

	para "You don't see this"
	line "#mon very often"
	cont "in Kanto or Johto."
	done

OakLabPartyAndBoxFullText:
	text "Hm, you don't have"
	line "room for it, and"
	line "your Box is full."
	done

OakLabDexCheckText:
	text "How is your #-"
	line "dex coming?"

	para "Let's see…"
	done

OakLabCatchMoreText:
	text "I want to thank"
	line "you for being of"

	para "such help with"
	line "filling out the"
	cont "#dex."

	para "Take this as a"
	line "reward for your"
	cont "hard work!"
	done

OakLabCatchCharmText:
	text "Holding a Catch"
	line "Charm will improve"

	para "your chances of a"
	line "critical capture."

	para "That's when your"
	line "# Ball is"

	para "thrown just right"
	line "and is more likely"
	cont "to succeed!"
	done

OakLabSeenAllText:
	text "You've been meeting"
	line "new #mon at a"

	para "good clip, haven't"
	line "you?"

	para "Take this as a"
	line "reward for your"
	cont "hard work!"
	done

OakLabOvalCharmText:
	text "Holding an Oval"
	line "Charm will improve"

	para "your chances of"
	line "finding an Egg at"
	cont "the Day-Care."
	done

OakLabCaughtAllText:
	text "I was completely"
	line "justified in"

	para "giving you that"
	line "#dex."

	para "It is a testament"
	line "to your effort…"

	para "And to the support"
	line "of the many who"
	cont "helped you…"

	para "And to the bonds"
	line "you have built"
	cont "with your #mon!"

	para "Take this as a"
	line "reward for your"
	cont "hard work!"
	done

OakLabShinyCharmText:
	text "Holding a Shiny"
	line "Charm will improve"

	para "your chances of"
	line "finding a shiny"
	cont "#mon!"
	done


OakMightBeReadyText:
	text "Oak: Incredible,"
	line "<PLAYER>!"

	para "You won against"
	line "the Elite Four"
	cont "a second time!"

	para "You just might be"
	line "ready to ascend"
	cont "Mt.Silver."
	done

OakChallengeText:
	text "Oak: Mt.Silver is"
	line "a tall mountain"

	para "that is home to"
	line "many wild #mon."

	para "It's too dangerous"
	line "for your average"

	para "trainer, so it's"
	line "off limits."

	para "I'll need to see"
	line "your skills for"
	cont "myself."

	para "Are you ready for"
	line "a battle?"
	done

OakRefusedText:
	text "Oak: Come back"
	line "when you're ready."
	done

OakSeenText:
	text "Oak: Put every-"
	line "thing you have"
	cont "into this battle!"
	done

OakWinText:
	text "I was right in my"
	line "assessment of you!"
	done

OakOpenMtSilverText:
	text "Oak: Spectacular,"
	line "<PLAYER>!"

	para "I'll make arrange-"
	line "ments so that you"

	para "can go to Mt."
	line "Silver."

	para "It's unusual, but"
	line "we can make an"

	para "exception in your"
	line "case, <PLAYER>."

	para "Go up to Indigo"
	line "Plateau. You can"

	para "reach Mt.Silver"
	line "from there."

	para "…"

	para "I let Red train on"
	line "Mt.Silver after"

	para "his first defeat"
	line "as Champion."

	para "But he hasn't"
	line "come back…"
	done

OakNoKantoBadgesText:
	text "Oak: Hmm? You're"
	line "not collecting"
	cont "Kanto Gym Badges?"

	para "The Gym Leaders in"
	line "Kanto are as tough"

	para "as any you battled"
	line "in Johto."

	para "I recommend that"
	line "you challenge"
	cont "them."
	done

OakNoEliteFourRematchText:
	text "Oak: Wow! That's"
	line "excellent!"

	para "You collected the"
	line "Badges of Gyms in"
	cont "Kanto. Well done!"

	para "Now you can cha-"
	line "llenge the Elite"

	para "Four with their"
	line "best #mon."

	para "Keep trying hard,"
	line "<PLAYER>!"
	done

OakYesKantoBadgesText:
	text "Oak: Ah, you're"
	line "collecting Kanto"
	cont "Gym Badges."

	para "I imagine that"
	line "it's hard, but the"

	para "experience is sure"
	line "to help you."

	para "After you earn all"
	line "eight, you can"
	cont "challenge the"

	para "Elite Four at"
	line "their best."

	para "Keep trying hard,"
	line "<PLAYER>!"
	done

OaksAssistant2Text:
	text "Thanks to your"
	line "work on the #-"
	cont "dex, the Prof's"

	para "research is coming"
	line "along great."
	done

OaksAssistant3Text:
	text "Don't tell anyone,"
	line "but Prof.Oak's"

	para "#mon Talk isn't"
	line "a live broadcast."
	done

OaksLabPoster1Text:
	text "Press Start to"
	line "open the Menu."
	done

OaksLabPoster2Text:
	text "The Save option is"
	line "on the Menu."

	para "Use it in a timely"
	line "manner."
	done

OaksLabPCText:
	text "There's an e-mail"
	line "message on the PC."

	para "…"

	para "Prof.Oak, how is"
	line "your research"
	cont "coming along?"

	para "I'm still plugging"
	line "away."

	para "I heard rumors"
	line "that <PLAYER> is"

	para "getting quite a"
	line "reputation."

	para "I'm delighted to"
	line "hear that."

	para "Elm in New Bark"
	line "Town 8-)"
	done

OaksLabPokedexText:
	text "It's Prof.Oak's"
	line "#dex."
	done

BulbasaurPokeBallScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftrue_jumptext OakPokeBallText
	reanchormap
	pokepic BULBASAUR
	cry BULBASAUR
	waitbutton
	closepokepic
	opentext
	writetext TakeBulbasaurText
	yesorno
	iffalse_jumpopenedtext DidntChooseKantoStarterText
	disappear OAKSLAB_BULBASAUR_BALL
	setevent EVENT_GOT_A_POKEMON_FROM_OAK
	setevent EVENT_CHOSE_BULBASAUR
	clearevent EVENT_OAKSLAB_AWAITING_STARTER_CHOICE
	turnobject OAKSLAB_VICTORIA, LEFT
	setscene SCENE_OAKSLAB_VICTORIA_READY
	givepoke BULBASAUR, PLAIN_FORM, 5, ORAN_BERRY
	closetext
	end

CharmanderPokeBallScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftrue_jumptext OakPokeBallText
	reanchormap
	pokepic CHARMANDER
	cry CHARMANDER
	waitbutton
	closepokepic
	opentext
	writetext TakeCharmanderText
	yesorno
	iffalse_jumpopenedtext DidntChooseKantoStarterText
	disappear OAKSLAB_CHARMANDER_BALL
	setevent EVENT_GOT_A_POKEMON_FROM_OAK
	setevent EVENT_CHOSE_CHARMANDER
	clearevent EVENT_OAKSLAB_AWAITING_STARTER_CHOICE
	turnobject OAKSLAB_VICTORIA, LEFT
	setscene SCENE_OAKSLAB_VICTORIA_READY
	givepoke CHARMANDER, PLAIN_FORM, 5, ORAN_BERRY
	closetext
	end

SquirtlePokeBallScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftrue_jumptext OakPokeBallText
	reanchormap
	pokepic SQUIRTLE
	cry SQUIRTLE
	waitbutton
	closepokepic
	opentext
	writetext TakeSquirtleText
	yesorno
	iffalse_jumpopenedtext DidntChooseKantoStarterText
	disappear OAKSLAB_SQUIRTLE_BALL
	setevent EVENT_GOT_A_POKEMON_FROM_OAK
	setevent EVENT_CHOSE_SQUIRTLE
	clearevent EVENT_OAKSLAB_AWAITING_STARTER_CHOICE
	turnobject OAKSLAB_VICTORIA, LEFT
	setscene SCENE_OAKSLAB_VICTORIA_READY
	givepoke SQUIRTLE, PLAIN_FORM, 5, ORAN_BERRY
	closetext
	end

TakeBulbasaurText:
	text "Select Bulbasaur?"
	done

TakeCharmanderText:
	text "Select Charmander?"
	done

TakeSquirtleText:
	text "Select Squirtle?"
	done

DidntChooseKantoStarterText:
	text "Think it over"
	line "carefully."
	done

OakPokeBallText:
	text "Oak: That #mon"
	line "is doing fine,"
	cont "isn't it?"
	done

OliveNoticesScript:
	showemote EMOTE_SHOCK, OAKSLAB_VICTORIA, 15
	opentext
	writetext OliveNoticesText
	waitbutton
	closetext
	setscene SCENE_OAKSLAB_GREETED_OLIVE
	end

OliveNoticesText:
	text "Over here! Come"
	line "pick one."
	done

; Olive and battle-ready Victoria used to be two separate stacked objects at
; the same tile, each independently masked -- that ambiguity (which of the
; two is actually visible/interactive) was the root cause of a cluster of
; bugs: wrong facing direction on a new game, no battle trigger, and being
; able to battle her repeatedly instead of her leaving for good. Now there's
; a single object (OAKSLAB_VICTORIA) whose script branches on state instead,
; masked directly by EVENT_BEAT_VICTORIA (see the object_event above): visible
; for both the pre-pick Olive and post-pick Victoria phases, hidden for good
; once she's beaten -- including after leaving and re-entering the room,
; since this is the object's own native masking rather than a callback (a
; callback here would race against and lose to LoadObjectMasks, which reapplies
; this same masking rule right after any callback runs).
OaksLabCallback_FaceOliveLeft:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iffalsefwd .Skip
	turnobject OAKSLAB_VICTORIA, LEFT
.Skip:
	endcallback

OliveScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftruefwd .AlreadyPicked
	faceplayer
	opentext
	writetext OliveOffersStarterText
	waitbutton
	closetext
	end

.AlreadyPicked:
; Talking to her doesn't start the battle -- that only happens when you cross
; her sightline tile (coord_event in the map header) on your way out. She
; faces the player for this chat, then turns back to her default left-facing
; (see OaksLabCallback_FaceOliveLeft) once it's over.
	faceplayer
	opentext
	writetext OliveOffersStarterText
	waitbutton
	closetext
	turnobject OAKSLAB_VICTORIA, LEFT
	end

OliveOffersStarterText:
	text "Let's make Oak"
	line "proud."
	done

; This is a one-time BATTLETYPE_CANLOSE battle (see ElmsLab's LyraBattleScript
; for the same pattern): losing doesn't blackout the player, it just shows a
; different follow-up line. Either way the party heals, then Olive walks off
; to collect whichever 2 Poke Balls weren't chosen and leaves for good.
; Only reachable by crossing her sightline tile (coord_event in the map
; header) -- talking to her (OliveScript, above) no longer starts the battle.
TrainerVictoria:
	; setlasttalked first: this can be entered via a coord_event tripwire
	; (walking past her), not just talking to her, so faceplayer/showemote
	; below can't rely on hLastTalked already being set the normal way.
	setlasttalked OAKSLAB_VICTORIA
	showemote EMOTE_SHOCK, OAKSLAB_VICTORIA, 15
	faceplayer
	opentext
	writetext .SeenText
	waitbutton
	closetext
	winlosstext .WinText, .LossText
	loadtrainer GREEN, 1
	loadvar VAR_BATTLETYPE, BATTLETYPE_CANLOSE
	startbattle
	reloadmap
	iftruefwd .AfterYourDefeat

.AfterVictory:
	opentext
	writetext .WinFollowupText
	waitbutton
	closetext
	sjumpfwd .CollectBalls

.AfterYourDefeat:
	opentext
	writetext .LoseFollowupText
	waitbutton
	closetext

.CollectBalls:
	opentext
	writetext .SuppliesText
	promptbutton
	verbosegiveitem POKE_BALL, 5
	verbosegiveitem ORAN_BERRY, 2
	writetext .PackingUpText
	waitbutton
	closetext
	special HealParty
	setevent EVENT_BEAT_VICTORIA
	setscene SCENE_OAKSLAB_VICTORIA_DONE
	applymovement OAKSLAB_VICTORIA, .WalkToTableMovement
	pause 30
	disappear OAKSLAB_BULBASAUR_BALL
	disappear OAKSLAB_CHARMANDER_BALL
	disappear OAKSLAB_SQUIRTLE_BALL
	applymovement OAKSLAB_VICTORIA, .WalkOutMovement
	disappear OAKSLAB_VICTORIA
	end

.WalkToTableMovement:
	step_up
	step_up
	step_up
	turn_head_right
	step_end

; Retraces her steps back past her old spot and out through the door,
; instead of just vanishing at the table.
.WalkOutMovement:
	step_down
	step_down
	step_down
	step_down
	step_down
	step_down
	step_down
	step_end

.SeenText:
	text "So, who did"
	line "you pick?"
	done

; Shown automatically by the battle engine right as the battle screen closes
; (see winlosstext above), before .AfterVictory/.AfterYourDefeat's own text.
.WinText:
	text "You did it!"
	done

.LossText:
	text "I got lucky"
	line "that time!"
	done

.WinFollowupText:
	text "Well played."
	done

.LoseFollowupText:
	text "Nice try."
	done

.SuppliesText:
	text "Oak wanted you"
	line "to have these."
	done

.PackingUpText:
	text "I need to get"
	line "these #mon back"
	cont "to Oak. See you"
	cont "there!"
	done
