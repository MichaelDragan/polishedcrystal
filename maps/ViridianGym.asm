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
	object_event  7, 33, SPRITE_ACE_TRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 1, GenericTrainerAceDuoAraandbela1, EVENT_VIRIDIAN_GYM_GAUNTLET_HIDDEN
	object_event  6, 33, SPRITE_ACE_TRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 1, GenericTrainerAceDuoAraandbela2, EVENT_VIRIDIAN_GYM_GAUNTLET_HIDDEN
	object_event  3, 32, SPRITE_ACE_TRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 1, GenericTrainerCooltrainerfSalma, EVENT_VIRIDIAN_GYM_GAUNTLET_HIDDEN
	object_event  3, 18, SPRITE_ACE_TRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 1, GenericTrainerCooltrainerfBonita, EVENT_VIRIDIAN_GYM_GAUNTLET_HIDDEN
	object_event  6,  8, SPRITE_ACE_TRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 1, GenericTrainerAceDuoElanandida1, EVENT_VIRIDIAN_GYM_GAUNTLET_HIDDEN
	object_event  7,  8, SPRITE_ACE_TRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 1, GenericTrainerAceDuoElanandida2, EVENT_VIRIDIAN_GYM_GAUNTLET_HIDDEN

	object_const_def
	const VIRIDIANGYM_OAK
	const VIRIDIANGYM_GYM_GUY
	const VIRIDIANGYM_ACEDUO_ARA
	const VIRIDIANGYM_ACEDUO_BELA
	const VIRIDIANGYM_COOLTRAINERF_SALMA
	const VIRIDIANGYM_COOLTRAINERF_BONITA
	const VIRIDIANGYM_ACEDUO_ELAN
	const VIRIDIANGYM_ACEDUO_IDA

; The 6 gym trainers only guard the way to Oak once he's giving out the real
; Badge (all 7 other Kanto Badges earned) -- during the tutorial phase it's
; a straight walk up to him.
ViridianGymCallback_SetupGauntlet:
	disappear VIRIDIANGYM_ACEDUO_ARA
	disappear VIRIDIANGYM_ACEDUO_BELA
	disappear VIRIDIANGYM_COOLTRAINERF_SALMA
	disappear VIRIDIANGYM_COOLTRAINERF_BONITA
	disappear VIRIDIANGYM_ACEDUO_ELAN
	disappear VIRIDIANGYM_ACEDUO_IDA
; Tutorial phase: Oak meets the player just 5 tiles up from the door instead
; of all the way at the back of the gym -- less empty floor to walk through
; with nothing going on yet.
	moveobject VIRIDIANGYM_OAK, 7, 38
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
	appear VIRIDIANGYM_ACEDUO_ARA
	appear VIRIDIANGYM_ACEDUO_BELA
	appear VIRIDIANGYM_COOLTRAINERF_SALMA
	appear VIRIDIANGYM_COOLTRAINERF_BONITA
	appear VIRIDIANGYM_ACEDUO_ELAN
	appear VIRIDIANGYM_ACEDUO_IDA
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
	setevent EVENT_BEAT_ACE_DUO_ARA_AND_BELA
	setevent EVENT_BEAT_COOLTRAINERF_SALMA
	setevent EVENT_BEAT_COOLTRAINERF_BONITA
	setevent EVENT_BEAT_ACE_DUO_ELAN_AND_IDA
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

	para "Before you set"
	line "out, humor an old"
	cont "man for a bit."

	para "I want to see how"
	line "you and your"
	cont "#mon battle"
	cont "together."

	para "Don't expect me to"
	line "go easy, though --"
	cont "a real battle is"
	cont "the only way to"
	cont "learn."
	done

LeaderOakTutorialWinText:
	text "Prof.Oak: Ha!"

	para "Not bad for your"
	line "first battle!"
	done

LeaderOakTutorialLossText:
	text "Prof.Oak: Hah!"

	para "Still, everyone"
	line "loses now and"
	cont "then."
	done

LeaderOakTutorialAfterText:
	text "Prof.Oak: Come"
	line "back and challenge"
	cont "me again once"

	para "you've earned all"
	line "seven other Kanto"
	cont "Badges."

	para "I promise I'll"
	line "have a real Badge"
	cont "waiting for you"
	cont "then."
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

	para "The Gym Leader"
	line "here is Professor"
	cont "Oak himself!"

	para "Don't let the lab"
	line "coat fool you --"
	cont "he's no pushover."

	para "Give it everything"
	line "you've got!"
	done

GenericTrainerAceDuoAraandbela1:
	generictrainer ACE_DUO, ARAANDBELA1, EVENT_BEAT_ACE_DUO_ARA_AND_BELA, AceDuoAraandbela1SeenText, AceDuoAraandbela1BeatenText

	text "Ara: Me, I should"
	line "be a pretty good"
	cont "practice partner…"
	done

GenericTrainerAceDuoAraandbela2:
	generictrainer ACE_DUO, ARAANDBELA2, EVENT_BEAT_ACE_DUO_ARA_AND_BELA, AceDuoAraandbela2SeenText, AceDuoAraandbela2BeatenText

	text "Bela: Our practice"
	line "battles didn't pre-"
	cont "pare us for this."
	done

GenericTrainerCooltrainerfSalma:
	generictrainer COOLTRAINERF, SALMA, EVENT_BEAT_COOLTRAINERF_SALMA, CooltrainerfSalmaSeenText, CooltrainerfSalmaBeatenText

	text "There are many"
	line "Gyms in the world,"

	para "but I really like"
	line "this one!"
	done

GenericTrainerCooltrainerfBonita:
	generictrainer COOLTRAINERF, BONITA, EVENT_BEAT_COOLTRAINERF_BONITA, CooltrainerfBonitaSeenText, CooltrainerfBonitaBeatenText

	text "Looks like you've"
	line "still got some"
	cont "energy left."
	done

GenericTrainerAceDuoElanandida1:
	generictrainer ACE_DUO, ELANANDIDA1, EVENT_BEAT_ACE_DUO_ELAN_AND_IDA, AceDuoElanandida1SeenText, AceDuoElanandida1BeatenText

	text "Elan: You're"
	line "stronger than we"
	cont "anticipated!"
	done

GenericTrainerAceDuoElanandida2:
	generictrainer ACE_DUO, ELANANDIDA2, EVENT_BEAT_ACE_DUO_ELAN_AND_IDA, AceDuoElanandida2SeenText, AceDuoElanandida2BeatenText

	text "Ida: If all you"
	line "have is strength,"
	cont "you won't do well."

	para "Strategy is also"
	line "important!"
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

AceDuoAraandbela1SeenText:
	text "Ara: Come on,"
	line "fight us and see"
	cont "how good we are!"
	done

AceDuoAraandbela1BeatenText:
	text "Ara: We were"
	line "deceived!"
	done

AceDuoAraandbela2SeenText:
	text "Bela: Come on,"
	line "fight us and see"
	cont "how good we are!"
	done

AceDuoAraandbela2BeatenText:
	text "Bela: We were"
	line "deceived!"
	done

CooltrainerfSalmaSeenText:
	text "What do you think?"

	para "You've never seen"
	line "such a wonderful"
	cont "Gym, have you?"
	done

CooltrainerfSalmaBeatenText:
	text "Whatever!"
	done

CooltrainerfBonitaSeenText:
	text "Looking around the"
	line "room, doesn't it"
	cont "make you dizzy?"
	done

CooltrainerfBonitaBeatenText:
	text "All of my #mon…"

	para "All dizzy and"
	line "fainting…"
	done

AceDuoElanandida1SeenText:
	text "Elan: All right,"
	line "let's get this"
	cont "fight started!"
	done

AceDuoElanandida1BeatenText:
	text "Elan: Well, this"
	line "is surprising."
	done

AceDuoElanandida2SeenText:
	text "Ida: I'm Ida! Next"
	line "to me is Elan!"

	para "Together, we're an"
	line "Ace Duo!"
	done

AceDuoElanandida2BeatenText:
	text "Ida: Wow. You're"
	line "really something."
	done
