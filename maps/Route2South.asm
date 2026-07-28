Route2South_MapScriptHeader:
	def_scene_scripts

	def_callbacks

	def_warp_events
	warp_event 19,  3, ROUTE_2_GATE, 3
	warp_event  9,  7, VIRIDIAN_FOREST_VIRIDIAN_GATE, 3

	def_coord_events

	def_bg_events
	bg_event  9, 29, BGEVENT_JUMPTEXT, Route2SignText

	def_object_events
	object_event 14, 23, SPRITE_CAMPER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 5, GenericTrainerCamperRob, -1
	object_event  4, 16, SPRITE_BUG_MANIAC, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, 0, OBJECTTYPE_GENERICTRAINER, 3, GenericTrainerBug_maniacDoug, -1
	itemball_event 18, 30, ELIXIR, 1, EVENT_ROUTE_2_ELIXIR
	cuttree_event 15, 16, EVENT_ROUTE_2_CUT_TREE_3
	cuttree_event 16, 24, EVENT_ROUTE_2_CUT_TREE_4
	cuttree_event 16, 30, EVENT_ROUTE_2_CUT_TREE_5

GenericTrainerCamperRob:
	generictrainer CAMPER, CAMPER_ROB, EVENT_BEAT_CAMPER_ROB, CamperRobSeenText, CamperRobBeatenText

	text "I caught these"
	line "#mon on my"
	cont "camping trip!"
	done

GenericTrainerBug_maniacDoug:
	generictrainer BUG_MANIAC, DOUG, EVENT_BEAT_BUG_MANIAC_DOUG, Bug_maniacDougSeenText, Bug_maniacDougBeatenText

	text "Bug #mon squish"
	line "like plush toys"

	para "when you squeeze"
	line "their bellies."

	para "I love how they"
	line "feel!"
	done

CamperRobSeenText:
	text "My #mon"
	line "won't budge. Get"
	cont "ready!"
	done

CamperRobBeatenText:
	text "Crushed like"
	line "gravel…"
	done

Bug_maniacDougSeenText:
	text "Why don't girls"
	line "like bug #mon?"
	done

Bug_maniacDougBeatenText:
	text "No good!"
	done

Route2SignText:
	text "Route 2"

	para "Viridian City -"
	line "Pewter City"
	done
