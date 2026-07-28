Route2North_MapScriptHeader:
	def_scene_scripts

	def_callbacks

	def_warp_events
	warp_event 15, 19, ROUTE_2_NUGGET_SPEECH_HOUSE, 1
	warp_event 16, 35, ROUTE_2_GATE, 1
	warp_event 17, 35, ROUTE_2_GATE, 2
	warp_event 12,  9, DIGLETTS_CAVE, 3
	warp_event  1, 11, VIRIDIAN_FOREST_PEWTER_GATE, 3
	warp_event  2, 11, VIRIDIAN_FOREST_PEWTER_GATE, 4

	def_coord_events

	def_bg_events
	bg_event 11, 11, BGEVENT_JUMPTEXT, Route2DiglettsCaveSignText

	def_object_events
	object_event  6,  6, SPRITE_POKEFAN_M, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 3, GenericTrainerPokefanEd, -1
	itemball_event 19,  4, CARBOS, 1, EVENT_ROUTE_2_CARBOS
	fruittree_event  7, 13, FRUITTREE_ROUTE_2, LUM_BERRY, PAL_NPC_GREEN
	cuttree_event  5, 10, EVENT_ROUTE_2_CUT_TREE_1
	cuttree_event 15, 22, EVENT_ROUTE_2_CUT_TREE_2
	object_event 12, 10, SPRITE_ACE_TRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, PAL_NPC_BLUE, OBJECTTYPE_COMMAND, jumptextfaceplayer, Route2NorthCooltrainermText, EVENT_VERMILION_CITY_SNORLAX

GenericTrainerPokefanEd:
	generictrainer POKEFANM, POKEFAN_ED, EVENT_BEAT_POKEFANM_ED, PokefanEdSeenText, PokefanEdBeatenText

	text "Clefairy and"
	line "Sandshrew are my"
	cont "favorites!"
	done

PokefanEdSeenText:
	text "I've been raising"
	line "these two since"
	cont "they hatched!"
	done

PokefanEdBeatenText:
	text "Ouch, ouch, ouch!"
	done

Route2NorthCooltrainermText:
	text "Diglett's Cave is"
	line "just a dead end."

	para "The Vermilion City"
	line "exit is blocked"

	para "by a sleeping"
	line "Snorlax."
	done

Route2DiglettsCaveSignText:
	text "Diglett's Cave"
	done
