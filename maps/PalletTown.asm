PalletTown_MapScriptHeader:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, PalletTownFlyPoint
	callback MAPCALLBACK_TILES, PalletTownTilesCallback

	def_warp_events
	warp_event  5,  5, REDS_HOUSE_1F, 1
	warp_event 13,  5, BLUES_HOUSE_1F, 1
	warp_event 12, 11, OAKS_LAB, 1

	def_coord_events
	coord_event  8,  2, -1, PalletTownGrassWarningScript
	coord_event  9,  2, -1, PalletTownGrassWarningScript

	def_bg_events
	bg_event  7,  9, BGEVENT_JUMPTEXT, PalletTownSignText
	bg_event  3,  5, BGEVENT_JUMPTEXT, RedsHouseSignText
	bg_event 13, 13, BGEVENT_JUMPTEXT, OaksLabSignText
	bg_event 11,  5, BGEVENT_JUMPTEXT, BluesHouseSignText

	def_object_events
	object_event  3,  8, SPRITE_AROMA_LADY, SPRITEMOVEDATA_WANDER, 2, 2, -1, 0, OBJECTTYPE_COMMAND, jumptextfaceplayer, PalletTownTeacherText, -1
	object_event 12, 14, SPRITE_FAT_GUY, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 2, -1, PAL_NPC_GREEN, OBJECTTYPE_COMMAND, jumptextfaceplayer, PalletTownFisherText, -1
	object_event 17,  7, SPRITE_SCHOOLBOY, SPRITEMOVEDATA_WALK_UP_DOWN, 2, 0, -1, 0, OBJECTTYPE_COMMAND, jumptextfaceplayer, PalletTownYoungsterText, -1
	fruittree_event 12, 21, FRUITTREE_ROUTE_21, ENIGMA_BERRY, PAL_NPC_BLACK

PalletTownFlyPoint:
	setflag ENGINE_FLYPOINT_PALLET
	endcallback

PalletTownTilesCallback:
; Reapplies any garden plots already tilled, so they don't reset to plain
; ground every time the map reloads. Plots are the 2x2 patch at block
; columns 2-3, rows 4-5 (tile coords 4-7, 8-11).
	checkevent EVENT_TILLED_PALLET_GARDEN_PLOT_1
	iffalsefwd .skip1
	changeblock 4, 8, TILLED_SOIL_BLOCK
.skip1
	checkevent EVENT_TILLED_PALLET_GARDEN_PLOT_2
	iffalsefwd .skip2
	changeblock 6, 8, TILLED_SOIL_BLOCK
.skip2
	checkevent EVENT_TILLED_PALLET_GARDEN_PLOT_3
	iffalsefwd .skip3
	changeblock 4, 10, TILLED_SOIL_BLOCK
.skip3
	checkevent EVENT_TILLED_PALLET_GARDEN_PLOT_4
	iffalsefwd .skip4
	changeblock 6, 10, TILLED_SOIL_BLOCK
.skip4
	endcallback

PalletTownGrassWarningScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_OAK
	iftruefwd .HasPokemon
	opentext
	writetext PalletTownNoPokemonYetText
	waitbutton
	closetext
	applyonemovement PLAYER, step_down
.HasPokemon:
	end

PalletTownTeacherText:
	text "I'm raising #-"
	line "mon too."

	para "They serve as my"
	line "private guards."
	done

PalletTownFisherText:
	text "Technology is"
	line "incredible!"

	para "You can now make"
	line "games just by"

	para "writing code in-"
	line "stead of editing"
	cont "binary data."
	done

PalletTownYoungsterText:
	text "Smell ya later!"

	para "…People started"
	line "saying that around"
	cont "here, but it's"

	para "kinda weird if you"
	line "think about it."
	done

PalletTownSignText:
	text "Pallet Town"

	para "A Tranquil Setting"
	line "of Peace & Purity"
	done

RedsHouseSignText:
	text "Red's House"
	done

OaksLabSignText:
	text "Oak #mon"
	line "Research Lab"
	done

BluesHouseSignText:
	text "Blue's House"
	done

PalletTownNoPokemonYetText:
	text "I should meet"
	line "Olive in the lab"

	para "before heading"
	line "out."
	done
