ViridianForest_MapScriptHeader:
	def_scene_scripts

	def_callbacks

	def_warp_events
	warp_event  3,  5, VIRIDIAN_FOREST_PEWTER_GATE, 1
	warp_event 18, 47, VIRIDIAN_FOREST_VIRIDIAN_GATE, 1
	warp_event 19, 47, VIRIDIAN_FOREST_VIRIDIAN_GATE, 2

	def_coord_events
	; Tripwire on the tile she's facing (she stands at 3,7 facing down, so
	; it's directly below her at 3,8) -- same trick used for Victoria at
	; Oak's Lab. Needed because picking her party based on which starter you
	; chose isn't something the native OBJECTTYPE_TRAINER engine's data
	; table can do, so this is a fully scripted battle instead. -1 scene
	; means it's always active; this map doesn't otherwise use scenes.
	coord_event  3,  8, -1, TrainerOliveForestGate

	def_bg_events
	bg_event  4,  7, BGEVENT_JUMPTEXT, ViridianForestSignText1
	bg_event  6, 26, BGEVENT_JUMPTEXT, ViridianForestSignText2
	bg_event 28, 19, BGEVENT_JUMPTEXT, ViridianForestSignText3
	bg_event 18, 34, BGEVENT_JUMPTEXT, ViridianForestSignText4
	bg_event 26, 42, BGEVENT_JUMPTEXT, ViridianForestSignText5
	bg_event 20, 44, BGEVENT_JUMPTEXT, ViridianForestSignText6
	bg_event 32, 44, BGEVENT_ITEM + MAX_ETHER, EVENT_VIRIDIAN_FOREST_HIDDEN_MAX_ETHER
	bg_event 18, 43, BGEVENT_ITEM + FULL_HEAL, EVENT_VIRIDIAN_FOREST_HIDDEN_FULL_HEAL
	bg_event  4, 43, BGEVENT_ITEM + MULCH, EVENT_VIRIDIAN_FOREST_HIDDEN_MULCH
	bg_event 30,  9, BGEVENT_ITEM + BIG_MUSHROOM, EVENT_VIRIDIAN_FOREST_HIDDEN_BIG_MUSHROOM
	bg_event  3, 14, BGEVENT_ITEM + LEAF_STONE, EVENT_VIRIDIAN_FOREST_HIDDEN_LEAF_STONE

	def_object_events
	object_event 29, 42, SPRITE_BUG_MANIAC, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 2, GenericTrainerBug_maniacDane, -1
	object_event 33, 35, SPRITE_BUG_MANIAC, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 5, GenericTrainerBug_maniacDion, -1
	object_event 32, 21, SPRITE_BUG_MANIAC, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerBug_maniacStacey, -1
	object_event 31,  4, SPRITE_BUG_MANIAC, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 3, GenericTrainerBug_maniacEllis, -1
	object_event  5, 24, SPRITE_BUG_MANIAC, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerBug_maniacAbner, -1
	object_event 15, 14, SPRITE_BIRD_KEEPER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerBirdKeeperPorter, -1
	object_event 18, 14, SPRITE_BIRD_KEEPER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 4, GenericTrainerBirdKeeperWesley, -1
	itemball_event 14, 31, DIRE_HIT, 1, EVENT_ROUTE_2_DIRE_HIT
	itemball_event  3, 33, MAX_POTION, 1, EVENT_ROUTE_2_MAX_POTION
	object_event  3,  7, SPRITE_OLIVE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_OLIVE, OBJECTTYPE_SCRIPT, 0, TrainerOliveForestGate, EVENT_OLIVE_HIDDEN_AT_VIRIDIAN_FOREST_GATE

	object_const_def
	const_skip ; Dane
	const_skip ; Dion
	const_skip ; Stacey
	const_skip ; Ellis
	const_skip ; Abner
	const_skip ; Porter
	const_skip ; Wesley
	const_skip ; Dire Hit ball
	const_skip ; Max Potion ball
	const FOREST_OLIVE

GenericTrainerBug_maniacDane:
	generictrainer BUG_MANIAC, DANE, EVENT_BEAT_BUG_MANIAC_DANE, BugManiacDaneSeenText, BugManiacDaneBeatenText

	text "Pretty impressive!"

	para "I'm sure you can"
	line "go anywhere with"
	cont "that skill!"
	done

GenericTrainerBug_maniacDion:
	generictrainer BUG_MANIAC, DION, EVENT_BEAT_BUG_MANIAC_DION, BugManiacDionSeenText, BugManiacDionBeatenText

	text "Bug-type #mon"
	line "make all kinds of"
	cont "sounds."

	para "For bug #mon"
	line "fans, knowing how"
	cont "to distinguish"
	cont "them is key!"
	done

GenericTrainerBug_maniacStacey:
	generictrainer BUG_MANIAC, STACEY, EVENT_BEAT_BUG_MANIAC_STACEY, BugManiacStaceySeenText, BugManiacStaceyBeatenText

	text "Has anyone ever"
	line "told you that from"
	cont "behind you look"
	cont "like a Venonat?"
	done

GenericTrainerBug_maniacEllis:
	generictrainer BUG_MANIAC, ELLIS, EVENT_BEAT_BUG_MANIAC_ELLIS, BugManiacEllisSeenText, BugManiacEllisBeatenText

	text "If this is it,"
	line "then I don't mind"
	cont "losing!"
	done

GenericTrainerBug_maniacAbner:
	generictrainer BUG_MANIAC, ABNER, EVENT_BEAT_BUG_MANIAC_ABNER, BugManiacAbnerSeenText, BugManiacAbnerBeatenText

	text "Doesn't matter what"
	line "kind of #mon--"

	para "as long as you"
	line "like them, they"
	cont "all look cute."
	done

BugManiacDaneSeenText:
	text "Welcome to"
	line "Viridian Forest."
	cont "Enjoy my Bug-type"
	cont "#mon."
	done

BugManiacDaneBeatenText:
	text "That's wonderful…"
	done

BugManiacDionSeenText:
	text "Shh! Be quiet! The"
	line "bug #mon will"
	cont "run away!"
	done

BugManiacDionBeatenText:
	text "Phew…"
	done

BugManiacStaceySeenText:
	text "Wow, that's a HUGE"
	line "#mon!"

	para "…"
	line "…What kind of"
	cont "trainer?!"
	done

BugManiacStaceyBeatenText:
	text "I couldn't catch"
	line "it!"
	done

BugManiacEllisSeenText:
	text "There's nothing"
	line "more efficient and"
	cont "beautiful than a"
	cont "Bug-type #mon."
	done

BugManiacEllisBeatenText:
	text "I lost"
	line "beautifully!"
	done

GenericTrainerBirdKeeperPorter:
	generictrainer BIRD_KEEPER, PORTER, EVENT_BEAT_BUG_CATCHER_PORTER, BirdKeeperPorterSeenText, BirdKeeperPorterBeatenText

	text "My Noctowl sees"
	line "everything in this"
	cont "forest!"
	done

GenericTrainerBirdKeeperWesley:
	generictrainer BIRD_KEEPER, WESLEY, EVENT_BEAT_YOUNGSTER_WESLEY, BirdKeeperWesleySeenText, BirdKeeperWesleyBeatenText

	text "My #mon rule"
	line "the skies!"
	done

BugManiacAbnerSeenText:
	text "Many people prefer"
	line "solid bug #mon"
	cont "over squishy bug"
	cont "#mon."
	done

BugManiacAbnerBeatenText:
	text "Thanks for your"
	line "hard work, my"
	cont "lovely #mon…"
	done

BirdKeeperPorterSeenText:
	text "Whoa! A trainer!"
	line "Let's see what"
	cont "you've got."
	done

BirdKeeperPorterBeatenText:
	text "My #mon need"
	line "more practice…"
	done

BirdKeeperWesleySeenText:
	text "Hey! Wanna battle"
	line "me and my"
	cont "#mon?"
	done

BirdKeeperWesleyBeatenText:
	text "Aw, shucks."
	done

ViridianForestSignText1:
	text "Leaving"
	line "Viridian Forest"
	cont "Pewter City Ahead"
	done

ViridianForestSignText2:
	text "Trainer Tips"

	para "Hold on to that"
	line "Big Mushroom!"

	para "Some maniacs will"
	line "pay lots of money"
	cont "for useless items!"
	done

ViridianForestSignText3:
	text "Trainer Tips"

	para "Grass-type #mon"
	line "are unaffected by"

	para "powder and spore"
	line "moves!"
	done

ViridianForestSignText4:
	text "For poison, use"
	line "Antidote! Get it"
	cont "at #mon Marts!"
	done

ViridianForestSignText5:
	text "Trainer Tips"

	para "Poison-type #-"
	line "mon can't be poi-"
	cont "soned themselves!"
	done

ViridianForestSignText6:
	text "Trainer Tips"

	para "Weaken #mon"
	line "before attempting"
	cont "capture!"

	para "When healthy,"
	line "they may escape!"
	done

; Shared by both the coord_event tripwire above and direct interaction
; (pressing A on her, via OBJECTTYPE_SCRIPT) -- either way leads here.
TrainerOliveForestGate:
; The tripwire fires regardless of whether she's actually visible yet, so
; guard against that explicitly (her object's own masking already covers
; direct interaction, since a hidden object can't be talked to).
	checkevent EVENT_OLIVE_HIDDEN_AT_VIRIDIAN_FOREST_GATE
	iftruefwd .Nothing
	checkevent EVENT_BEAT_VICTORIA_2
	iftruefwd .AlreadyBeaten

	setlasttalked FOREST_OLIVE
	faceplayer
	opentext
	writetext .SeenText
	waitbutton
	closetext
	winlosstext .WinText, 0
; Her Eevee's Hidden Power type counters whichever starter you picked:
; Squirtle (Water) -> Grass, Charmander (Fire) -> Water, Bulbasaur (Grass) -> Fire.
	checkevent EVENT_CHOSE_SQUIRTLE
	iftruefwd .LoadVsSquirtle
	checkevent EVENT_CHOSE_CHARMANDER
	iftruefwd .LoadVsCharmander
	loadtrainer GREEN, 4 ; vs. Bulbasaur
	sjumpfwd .DoBattle
.LoadVsSquirtle:
	loadtrainer GREEN, 2
	sjumpfwd .DoBattle
.LoadVsCharmander:
	loadtrainer GREEN, 3
.DoBattle:
; Must be reset explicitly -- VAR_BATTLETYPE is a shared scratch variable,
; and without this it was silently inheriting BATTLETYPE_CANLOSE left over
; from the Oak's Lab fight earlier in the same session, which meant losing
; here never blacked out and instead ran the win text/leave sequence below
; regardless of the actual result.
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
; reloadmapafterbattle (not plain reloadmap) is what actually checks the
; result and redirects to the whiteout/blackout sequence on a loss --
; plain reloadmap doesn't check anything, which is why losing fell through
; to the win text/leave sequence below regardless of outcome. On a loss,
; this jumps away for good and nothing past this point ever runs.
	reloadmapafterbattle
	setevent EVENT_BEAT_VICTORIA_2
	opentext
	writetext .WinFollowupText
	waitbutton
	closetext
; She leaves for good now, same as the Oak's Lab fight -- reuse the same
; flag that hides her before Oak's Lab is beaten to also hide her after
; this rematch is won (native masking only supports one flag, so one flag
; has to cover both "not revealed yet" and "already left").
	setevent EVENT_OLIVE_HIDDEN_AT_VIRIDIAN_FOREST_GATE
	applymovement FOREST_OLIVE, .WalkOutMovement
	disappear FOREST_OLIVE
	end

.WalkOutMovement:
; She's at 3,7; the Pewter-side warp is at 3,5, directly above her.
	step_up
	step_up
	step_end

.AlreadyBeaten:
; Self-heals a stale save where EVENT_BEAT_VICTORIA_2 got set before she
; leaves for good (see .DoBattle's win branch) -- rather than chat forever,
; just have her leave the moment she's next interacted with.
	setlasttalked FOREST_OLIVE
	setevent EVENT_OLIVE_HIDDEN_AT_VIRIDIAN_FOREST_GATE
	applymovement FOREST_OLIVE, .WalkOutMovement
	disappear FOREST_OLIVE
	end

.Nothing:
	end

.SeenText:
	text "Made it through"
	line "most of the"
	cont "forest, huh?"

	para "Let's see if you"
	line "got any stronger!"
	done

.WinText:
	text "You have gotten"
	line "stronger!"
	done

.WinFollowupText:
	text "Well played."
	done
