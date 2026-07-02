PlayerStateSprites:
	table_width NUM_PLAYER_STATES

; PLAYER_MALE
; Uses Red's existing overworld sprite (gfx/sprites/red.png) instead of the
; default Chris/"Gold" design, since Red is this hack's actual protagonist.
; Red only has normal-walk frames so far (no run/bike/surf art yet) --
; those states fall back to the default Chris sprites until that art exists.
	db SPRITE_RED             ; PLAYER_NORMAL
	db SPRITE_CHRIS_RUN       ; PLAYER_RUN
	db SPRITE_CHRIS_BIKE      ; PLAYER_BIKE
	db SPRITE_RED             ; PLAYER_SKATE
	db SPRITE_CHRIS_SURF      ; PLAYER_SURF
	db SPRITE_SURFING_PIKACHU ; PLAYER_SURF_PIKA

; PLAYER_FEMALE
	db SPRITE_KRIS            ; PLAYER_NORMAL
	db SPRITE_KRIS_RUN        ; PLAYER_RUN
	db SPRITE_KRIS_BIKE       ; PLAYER_BIKE
	db SPRITE_KRIS            ; PLAYER_SKATE
	db SPRITE_KRIS_SURF       ; PLAYER_SURF
	db SPRITE_SURFING_PIKACHU ; PLAYER_SURF_PIKA

; PLAYER_ENBY
	db SPRITE_CRYS            ; PLAYER_NORMAL
	db SPRITE_CRYS_RUN        ; PLAYER_RUN
	db SPRITE_CRYS_BIKE       ; PLAYER_BIKE
	db SPRITE_CRYS            ; PLAYER_SKATE
	db SPRITE_CRYS_SURF       ; PLAYER_SURF
	db SPRITE_SURFING_PIKACHU ; PLAYER_SURF_PIKA

; PLAYER_BETA
	db SPRITE_BETA            ; PLAYER_NORMAL
	db SPRITE_BETA_RUN        ; PLAYER_RUN
	db SPRITE_BETA_BIKE       ; PLAYER_BIKE
	db SPRITE_BETA            ; PLAYER_SKATE
	db SPRITE_BETA_SURF       ; PLAYER_SURF
	db SPRITE_SURFING_PIKACHU ; PLAYER_SURF_PIKA

	assert_table_length NUM_PLAYER_GENDERS
