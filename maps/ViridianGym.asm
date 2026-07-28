ViridianGym_MapScriptHeader:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, ViridianGymCallback_SetupGauntlet

	def_warp_events
	warp_event  6, 43, VIRIDIAN_CITY, 1
	warp_event  7, 43, VIRIDIAN_CITY, 1

	def_coord_events

	def_bg_events
	bg_event  4, 41, BGEVENT_READ, ViridianGymStatue
	bg_event  9, 41, BGEVENT_READ, ViridianGymStatue

	def_object_events
	object_event  7,  2, SPRITE_OAK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianGymOakScript, -1
	object_event  8, 41, SPRITE_GYM_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianGymGuyScript, -1
	object_event  4, 36, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerYoungsterMilo, -1
	object_event  9, 30, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerLassNadia, -1
	object_event  4, 24, SPRITE_SCHOOLBOY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerSchoolboyPercy, -1

	object_const_def
	const VIRIDIANGYM_OAK
	const VIRIDIANGYM_GYM_GUY
	const VIRIDIANGYM_YOUNGSTER_MILO
	const VIRIDIANGYM_LASS_NADIA
	const VIRIDIANGYM_SCHOOLBOY_PERCY

; Oak meets the player partway into the gym during the tutorial phase instead
; of all the way at the back of the gym -- less empty floor to walk through
; with nothing going on yet. Once all 7 other Kanto Badges are earned, he
; moves to the back for the real fight.
ViridianGymCallback_SetupGauntlet:
	moveobject VIRIDIANGYM_OAK, 7, 19
	turnobject VIRIDIANGYM_OAK, DOWN
	checkflag ENGINE_BOULDERBADGE
	iffalsefwd .Skip
	checkflag ENGINE_CASCADEBADGE
	iffalsefwd .Skip
	checkflag ENGINE_THUNDERBADGE
	iffalsefwd .Skip
	checkflag ENGINE_RAINBOWBADGE
	iffalsefwd .Skip
	checkflag ENGINE_SOULBADGE
	iffalsefwd .Skip
	checkflag ENGINE_MARSHBADGE
	iffalsefwd .Skip
	checkflag ENGINE_VOLCANOBADGE
	iffalsefwd .Skip
	moveobject VIRIDIANGYM_OAK, 7, 2
	turnobject VIRIDIANGYM_OAK, DOWN
.Skip:
	endcallback

ViridianGymOakScript:
	faceplayer
	opentext
	checkflag ENGINE_EARTHBADGE
	iftruefwd .FightDone
; This gym comes first, chronologically -- Oak doesn't hand out a real Badge
; until the player has all 7 other Kanto Badges. Until then it's just a
; tutorial battle against a 3-mon practice squad (see .Tutorial below).
	checkflag ENGINE_BOULDERBADGE
	iffalsefwd .Tutorial
	checkflag ENGINE_CASCADEBADGE
	iffalsefwd .Tutorial
	checkflag ENGINE_THUNDERBADGE
	iffalsefwd .Tutorial
	checkflag ENGINE_RAINBOWBADGE
	iffalsefwd .Tutorial
	checkflag ENGINE_SOULBADGE
	iffalsefwd .Tutorial
	checkflag ENGINE_MARSHBADGE
	iffalsefwd .Tutorial
	checkflag ENGINE_VOLCANOBADGE
	iffalsefwd .Tutorial
	sjumpfwd .RealFight

.Tutorial:
; Pikachu plus whichever 2 starters the player didn't pick -- see PROF_OAK
; trainers 2-4 in data/trainers/parties.asm.
	writetext LeaderOakTutorialBeforeText
	waitbutton
	closetext
	winlosstext LeaderOakTutorialWinText, LeaderOakTutorialLossText
	checkevent EVENT_CHOSE_BULBASAUR
	iftruefwd .OakHasCharAndSquirt
	checkevent EVENT_CHOSE_CHARMANDER
	iftruefwd .OakHasBulbaAndSquirt
	loadtrainer PROF_OAK, 4 ; chose Squirtle -> Oak has Bulbasaur/Charmander
	sjumpfwd .DoTutorialBattle
.OakHasCharAndSquirt:
	loadtrainer PROF_OAK, 3 ; chose Bulbasaur -> Oak has Charmander/Squirtle
	sjumpfwd .DoTutorialBattle
.OakHasBulbaAndSquirt:
	loadtrainer PROF_OAK, 2 ; chose Charmander -> Oak has Bulbasaur/Squirtle
.DoTutorialBattle:
	startbattle
	reloadmapafterbattle
	opentext
	writetext LeaderOakTutorialAfterText
	waitbutton
	closetext
	end

.RealFight:
	writetext LeaderOakBeforeText
	waitbutton
	closetext
	winlosstext LeaderOakWinText, 0
	loadtrainer PROF_OAK, 1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BLUE
	opentext
	givebadge EARTHBADGE, KANTO_REGION
	setevent EVENT_FINAL_BATTLE_WITH_LYRA
.FightDone:
	checkevent EVENT_GOT_TM71_STONE_EDGE
	iftrue_jumpopenedtext LeaderOakEpilogueText
	writetext LeaderOakAfterText
	promptbutton
	verbosegivetmhm TM_STONE_EDGE
	setevent EVENT_GOT_TM71_STONE_EDGE
	jumpthisopenedtext

	text "It contains Stone"
	line "Edge. It's not only"

	para "for Rock-type"
	line "#mon, got it?"

	para "…"

	para "Ha! I haven't had"
	line "a challenge like"
	cont "that in years."

	para "With eight Badges"
	line "from Kanto, you"

	para "can challenge the"
	line "Elite Four again."

	para "They won't go easy"
	line "on a trainer who"
	cont "beat two regions."

	para "Never stop"
	line "learning from your"
	cont "#mon, <PLAYER>."

	para "That's the real"
	line "research, if you"
	cont "ask me."
	done

LeaderOakTutorialBeforeText:
	text "Prof.Oak: Ah,"
	line "<PLAYER>!"

	para "Blue was supposed"
	line "to be running this"
	cont "Gym today."

	para "Off doing who"
	line "knows what, as"
	cont "usual."

	para "So humor an old"
	line "man and battle me"
	cont "instead."

	para "I can't hand you a"
	line "Badge in his"
	cont "place, mind you."

	para "But don't expect"
	line "me to go easy --"
	cont "a real battle is"
	cont "the only way to"
	cont "learn, Badge or"
	cont "not."
	done

LeaderOakTutorialWinText:
	text "Prof.Oak: Ha!"

	para "Not bad for your"
	line "first battle!"

	para "Still no Badge"
	line "from me, though --"
	cont "that's Blue's job."
	done

LeaderOakTutorialLossText:
	text "Prof.Oak: Hah!"

	para "Still, everyone"
	line "loses now and"
	cont "then."
	done

LeaderOakTutorialAfterText:
	text "Prof.Oak: Come"
	line "back once you've"
	cont "earned all seven"
	cont "other Kanto"
	cont "Badges."

	para "Maybe Blue will"
	line "have wandered"
	cont "back by then."

	para "And if not, well…"
	line "I suppose I'll"
	cont "hand you his Badge"
	cont "myself."
	done

ViridianGymGuyScript:
	checkevent EVENT_BEAT_BLUE
	iftrue_jumptextfaceplayer ViridianGymGuyWinText
	jumpthistextfaceplayer

	text "Yo, Champ in"
	line "making!"

	para "How's it going?"
	line "Looks like you're"
	cont "on a roll."

	para "So, funny story."
	line "Blue's supposed to"
	cont "be the Gym Leader"
	cont "here."

	para "But he took off"
	line "again. Typical"
	cont "Blue."

	para "Prof.Oak's filling"
	line "in, but he can't"
	cont "hand out Badges"
	cont "in Blue's place."

	para "Doesn't mean he'll"
	line "go easy on you,"
	cont "though!"
	done

GenericTrainerYoungsterMilo:
	generictrainer YOUNGSTER, MILO, EVENT_BEAT_YOUNGSTER_MILO, YoungsterMiloSeenText, YoungsterMiloBeatenText

	text "My Mareep and"
	line "Growlithe are"
	cont "still young, but"
	cont "they're tough!"
	done

GenericTrainerLassNadia:
	generictrainer LASS, NADIA, EVENT_BEAT_LASS_NADIA, LassNadiaSeenText, LassNadiaBeatenText

	text "Water and grass"
	line "make a great"
	cont "team, don't you"
	cont "think?"
	done

GenericTrainerSchoolboyPercy:
	generictrainer SCHOOLBOY, PERCY, EVENT_BEAT_SCHOOLBOY_PERCY, SchoolboyPercySeenText, SchoolboyPercyBeatenText

	text "I raise the same"
	line "kind of #mon as"
	cont "my friend Danny"
	cont "on Route 1!"
	done

ViridianGymStatue:
	gettrainername PROF_OAK, 1, STRING_BUFFER_4
	checkflag ENGINE_EARTHBADGE
	iftruefwd .Beaten
	jumpstd gymstatue1
.Beaten:
	jumpstd gymstatue2

LeaderOakBeforeText:
	text "Prof.Oak: Ah,"
	line "<PLAYER>!"

	para "I never expected"
	line "to see you again"
	cont "so soon."

	para "When I heard you'd"
	line "cleared every Gym"
	cont "in Johto, I"

	para "figured it was"
	line "time I got back"
	cont "into training,"
	cont "too."

	para "A Professor should"
	line "never stop"
	cont "learning, after"
	cont "all."

	para "Show me what you"
	line "and your #mon"
	cont "have learned."

	para "Ready?"
	done

LeaderOakWinText:
	text "Prof.Oak: Ha!"

	para "I haven't felt"
	line "this alive in"
	cont "years!"

	para "Here, take this--"
	line "it's the Earth"
	cont "Badge."
	done

LeaderOakAfterText:
	text "Prof.Oak: Here,"
	line "take this as well!"
	done


LeaderOakEpilogueText:
	text "Prof.Oak: Still"
	line "training hard, I"
	cont "hope?"

	para "Never stop pushing"
	line "yourself and your"
	cont "#mon further."
	done


ViridianGymGuyWinText:
	text "Man, you are truly"
	line "tough…"

	para "That was a heck of"
	line "an inspirational"

	para "battle. It brought"
	line "tears to my eyes."
	done

YoungsterMiloSeenText:
	text "Have you heard?"
	line "Blue's gone AWOL"
	cont "again!"

	para "No Badges being"
	line "handed out today,"
	cont "but I'll still"
	cont "battle you!"
	done

YoungsterMiloBeatenText:
	text "Aw, we're not"
	line "tough enough yet…"
	done

LassNadiaSeenText:
	text "Hey! Wanna see"
	line "what my #mon"
	cont "can do?"
	done

LassNadiaBeatenText:
	text "Guess we need"
	line "more practice."
	done

SchoolboyPercySeenText:
	text "Prof.Oak's filling"
	line "in for Blue"
	cont "again…"

	para "Let me show you my"
	line "#mon while you"
	cont "wait!"
	done

SchoolboyPercyBeatenText:
	text "They're still"
	line "growing up…"
	done

