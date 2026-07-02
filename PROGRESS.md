# Gold vs Victoria — progress notes

## Setup
- Forked `Rangi42/polishedcrystal` to `MichaelDragan/polishedcrystal` on GitHub, cloned into `~/DraganIndustries/PolishedCrystal`.
  - `origin` = your fork, `upstream` = Rangi42's original (for pulling updates).
- RGBDS v1.0.1 toolchain installed to `~/.local/bin` (rgbasm/rgblink/rgbfix/rgbgfx), no sudo/system install needed.
- `make` builds the normal ROM; `make debug` builds the debug variant with the changes below. The
  regular build stays vanilla except for one addition that isn't gated: Victoria's NPC placement in
  Oak's Lab (harmless — Kanto is legitimate postgame content in this hack either way).

## Current game flow (`make debug`)
Starting **New Game**:
1. Skips the interactive "how do you want to play" settings menu — uses the game's own defaults
   (see `data/options/default_options.asm`) except **Natures is off** (user preference) and Exp gain
   stays "Old" (unscaled/harder leveling, already the default).
2. Player name defaults to **RED** (yes, this coincides with the existing postgame "Red" NPC/Mt.
   Silver superboss already in this hack — confirmed intentional, no technical conflict, just a
   narrative coincidence).
3. Spawns in **Pallet Town** (`SPAWN_PALLET`).
4. Walk to **Oak's Lab**: three Poke Balls (green/red/blue = Bulbasaur/Charmander/Squirtle,
   `SPRITE_BALL_CUT_TREE`) sit **inside the glass display case** at (6,3)/(7,3)/(8,3) — this is the
   same case that used to hold the Eevee doll; the doll was moved to floor tile (2,4) instead so the
   balls could have the case (real "on display" look, not floor placement). Picking one gives it at
   level 5 and makes the other two disappear, mirroring the exact mechanic used for the Johto
   starters in `maps/ElmsLab.asm` (`CyndaquilPokeBallScript` etc.) but simplified — no Lyra-style
   choreography since no one else is present for this moment. Reuses the existing
   `EVENT_GOT_A_POKEMON_FROM_OAK` flag as the "already chose" gate, which also correctly prevents
   Oak's other unrelated dialogue from re-offering a starter later.
5. **Talking to Oak before picking a starter** now just says "Go ahead and choose a Pokémon to be
   your partner!" (`OakChooseStarterText`) instead of the vanilla "welcome to Kanto" + Elite Four
   badge-check dialogue tree, which made no sense this early. Once a starter is picked
   (`EVENT_GOT_A_POKEMON_FROM_OAK` true), Oak's normal vanilla dialogue resumes as before — confirmed
   no regression there.
6. **Victoria** is a real trainer NPC standing in Oak's Lab too (`SPRITE_LEAF` reused for her overworld
   sprite, at (5,6)), trainer class `GREEN`, currently holds a single level 5 Eevee (matching what
   Gold used to auto-receive before the 3-starter change — see "Open question" below, this may now be
   stale/mismatched given Gold picks a real Kanto starter). Talking to her triggers a genuine trainer
   battle via the standard engine (not an instant/scripted battle) — confirmed working end-to-end
   including a loss. Her dialogue now correctly uses `<PLAYER>` instead of a hardcoded "Gold" (that
   was a real bug — confirmed fixed, she now says "RED").
7. **Losing to Victoria (blackout) correctly respawns you in Pallet Town**, not some unrelated
   fallback location. This needed an explicit fix — see "Whiteout fix" below.
8. **Player character uses Red's actual overworld sprite** (`gfx/sprites/red.png`, already present in
   this hack, same dimensions as the default "Chris"/Gold sprite sheet so it was a straight swap in
   `data/player/state_sprites.asm`) instead of the default male protagonist look — confirmed visually.
   Note: Red only has normal-walk frames so far, no run/bike/surf art, so those states still fall back
   to the default sprite until that art exists.

## Story pivot: Oak's Lab is a library for now, becomes a lab later
Working narrative: the game takes place before Oak's Lab exists as a lab. The room (still
`maps/OaksLab.asm`) currently functions as a library that stores documents recovered on the journey
(explains the pre-existing bookshelf tiles/`difficultbookshelf` events nicely, no art changes needed
for that). Concretely, for this early phase:
- **Oak and the two Scientist NPCs removed** from `def_object_events` (AromaLady kept — not a
  "scientist", not mentioned for removal). `object_const_def` renumbered with `const_skip` entries
  preserved for the still-present-but-unlisted AromaLady slot (matching the established
  index-alignment discipline from the earlier `disappear`/`turnobject` bug).
- **Oak's own late-game script (`Oak:` label) was NOT deleted** — it still holds the Mt. Silver
  postgame trigger (`PROF_OAK` superboss), Catch/Oval/Shiny Charm logic, and the Kanto badge-check
  dialogue tree, all gated behind flags that can't be true this early anyway. Only the
  `turnobject OAKSLAB_OAK` / `setlasttalked OAKSLAB_OAK` calls that referenced his now-nonexistent
  object were removed (left a comment marking `setlasttalked` for restoration once Oak has a real
  object again, i.e. once the room becomes an actual lab later in the story).
- **A table for Olive**, on the right side of the room: reused the *exact same* display-case graphic
  that already holds the 3 starter Poke Balls (blocks 26/27 + their base row 44/45, discovered by
  reading `maps/OaksLab.ablk` as a 5x6 grid of block IDs and identifying the display case's footprint
  against known object coordinates) — placed a second copy at grid row 4, cols 3-4. This was the
  *second* attempt: the first tried an unidentified block (43) that turned out to render as plain
  floor, not furniture — there's no reliable way to preview raw tileset blocks in this environment, so
  this needed an empirical rebuild-and-screenshot test rather than a confident guess.
- **Olive repositioned** to sit at that table (currently `object_event 8, 8`, facing down toward
  where the player enters) instead of standing near the starter balls.
- **Recoloring the table (green → brown) and bookshelves (→ charcoal) was attempted and abandoned**:
  dumped the raw tileset attribute bytes (`data/tilesets/kanto_attributes.bin`) for the relevant
  blocks, expecting a simple per-tile palette index. Instead, blocks that render in completely
  different colors (the green display case vs. the gray PC/counter) turned out to share nearly
  identical attribute bytes — meaning color isn't controlled by a safely-editable attribute layer
  here, it's most likely baked into which raw tile graphic data each block references. Left as-is per
  user's call; would need real tile-editing tooling to revisit.
- **First-move auto-trigger**: added a `SCENE_OAKSLAB_INTRO` / `SCENE_OAKSLAB_GREETED_OLIVE` scene
  pair (`def_scene_scripts`) and two `coord_event`s at (4,10)/(5,10) — the tiles immediately inside the
  door — gated on the default `SCENE_OAKSLAB_INTRO` state. Stepping onto either tile (your first move
  after entering) fires `OliveNoticesScript`, which shows an emote + a short "come sit with me" text
  box, applies a short movement so the player walks over and ends up beside her at the table, then
  advances the scene so it only fires once. Modeled on the identical `coord_event` mechanism
  `ElmsLab.asm` uses for its rival-intercept scene.
  - **Fixed: the trigger silently did nothing at first.** Root cause: `coord_event`/`setscene` only
    work for maps explicitly registered in the separate `MapScenes` table
    (`data/maps/scenes.asm`) — this is not implied by adding `def_scene_scripts` to a map's own
    header. `GetMapSceneID` (`home/map.asm`) looks up the current map there to find its WRAM storage
    address; if the map isn't listed, the lookup just fails silently (no crash, no error, the
    scene-gated `coord_event` simply never matches). Oak's Lab was never in that table before now.
    Fixed by adding `scene_var OAKS_LAB, wOaksLabSceneID` to `data/maps/scenes.asm` and declaring
    `wOaksLabSceneID:: db` in `ram/wramx.asm` (same pattern as every other map with scene support,
    e.g. `wElmsLabSceneID`).
  - Adding that WRAM byte shifted the SRAM save-data layout by 1 byte, tripping three hardcoded
    checksum-address assertions in `ram/sram.asm` (`sChecksum`, `sCheckValue2`, `sBackupChecksum`) that
    exist to catch accidental save-layout shifts. Updated all three to their new correct addresses
    (found via the `.sym` file after a build with the asserts temporarily disabled) rather than
    removing the safety check.
  - Diagnosed by walking the player physically out of the room and back in through the door under
    manual control — earlier test attempts kept landing already-inside the room without an actual
    "step through the door" happening, which never gave the `coord_event` a chance to fire in the
    first place, and looked identical to the trigger being broken until this was ruled out.
- **Olive doesn't battle yet**: she was originally wired as `OBJECTTYPE_TRAINER` (auto-battle on
  sight, via the `trainer GREEN, 1, ...` macro/`TrainerVictoria` script) — too aggressive for what's
  meant to be a friendly first meeting ("we are friends" per the user, not rivals yet at this point in
  the story). Switched her object to `OBJECTTYPE_SCRIPT` pointing at a new plain-conversation
  `OliveScript`/`OliveFriendlyText`, sight_range 0. The original trainer-battle data
  (`TrainerVictoria:`, `EVENT_BEAT_VICTORIA`) is left intact but unwired — re-enabling the battle
  later is just pointing her object_event back at it.

## Olive's own overworld sprite
She used to just reuse `SPRITE_LEAF` (Leaf's stock overworld sprite). Forked her a real sprite:
- `gfx/sprites/olive.png` — copied from `gfx/sprites/aroma_lady.png` as a starting point (per user
  request, "use her sprite as a baseline"), since AromaLady's own object still uses her original file
  directly and editing it in place would have changed AromaLady too. User is hand-editing this file in
  LibreSprite now (confirmed saves are landing correctly — file size/timestamp updates each save, and
  `rgbgfx` picks up the changes on rebuild automatically).
- New `SPRITE_OLIVE` constant appended at the very end of the normal overworld-sprite range in
  `constants/sprite_constants.asm` (right before the `SPRITE_POKEMON`/`SPRITE_VARS` reserved-index
  jump) — appending rather than inserting mid-list to avoid renumbering every sprite after it.
  Registered the GFX include in `gfx/sprites.asm` and the `overworld_sprite` table entry in
  `data/sprites/sprites.asm` (also strictly positional/append-only, same reasoning).
- New named NPC palette **`PAL_OW_OLIVE`** (`constants/sprite_data_constants.asm`, also appended at
  the end of the time-of-day palette list) using the exact hair-color RGB from her battle portrait
  (`10,12,08` GBC scale) per user's request to match her battle sprite colors. Added the matching RGB
  entries to `gfx/overworld/npc_sprites.pal` (all 4 time-of-day blocks: morn/day/nite/eve, with a
  dimmed night variant matching the pattern every other named color follows).
  - Adding this new palette index shifted `NUM_OW_TIME_OF_DAY_PALS`, which two OTHER palette files
    assert their exact byte length against: `gfx/overworld/npc_sprites_darkness.pal` (a single flat
    list covering all time-of-day + individual/emote palettes together) and
    `gfx/overworld/npc_sprites_overcast.pal` (same 4-block structure as the main file). Both needed a
    matching new entry added or the build failed with an `assert_table_length` mismatch — caught this
    immediately via the build erroring out with exact expected-vs-actual byte counts, not a silent
    bug.
- Olive's `object_event` in `maps/OaksLab.asm` now uses `SPRITE_OLIVE` + `PAL_NPC_OLIVE` instead of
  `SPRITE_LEAF` + `PAL_NPC_DARK_GREEN`.
- **Fully custom colors, not the shared NPC skin tone**: the first version of `PAL_OW_OLIVE` copied
  the same shared skin-tone/second-tone RGB values every other named palette uses (only the 3rd
  "accent" slot actually varies between named colors normally) — user correctly called this out as
  "way too tan." Realized this sharing was just a stylistic convention in the original data, not a
  technical requirement: since she already has her own dedicated palette row (not literally shared at
  the byte level), all 4 RGB slots in her `npc_sprites.pal` entries were changed to fully custom
  values matching her battle portrait's actual skin tone (`23,19,16`) instead of reusing any other
  NPC's tones. No "break out of the shared system" work was needed — the system already supported
  this per-entry.
- **Tried and reverted: a chair block under her.** No dedicated chair sprite/block exists. Tested one
  blind guess at an unidentified tileset block (graphic ID 24) at her tile position — rendered as a
  gray ledge/hospital-bed-like shape, not a chair, and obscured her sprite. Reverted immediately back
  to the known-good table graphic (ID 27). Same underlying limitation as the earlier table-color
  question: no way to preview raw tileset blocks in this environment, so finding a real chair graphic
  would need either proper tooling or the user spotting one while playing.

## Fixed: Victoria's Eevee was absurdly strong
`data/trainers/dvs.asm`'s `; green` entry still had `252, PERFECT_DVS` (max IVs + 252 EVs) left over
from when Victoria was a level 50 endgame-caliber Sylveon/Flareon duo — never scaled down when her
team became a single level 5 Eevee. Changed to `0, $66, $66, $66` (0 EVs, modest DVs), matching the
stat tier this hack uses for early low-level trainers like Youngster. Fair starter-vs-starter fight
now.

## Kanto difficulty scaling — in progress, one region at a time
Discovered that Kanto is entirely postgame-difficulty content in this hack (levels 50-70+ across the
board), since it's normally only reachable after the Elite Four. Since we hacked New Game to start
directly in Pallet Town at level 5, every nearby trainer/wild encounter was at that postgame
difficulty — e.g. a Route 1 trainer had a level 63 Venusaur. Rebalancing the whole region is too big
to do at once, so doing it incrementally, area by area, starting with Pallet Town → Route 1 →
Viridian City.

**Done so far** (target: levels 2-8 for this stretch):
- Route 1 wild grass (`data/wild/kanto_grass.asm`): was Pidgeotto/Raticate/Furret/Pidgeot/Noctowl at
  56-60, now Pidgey/Rattata/Sentret/Hoothoot (swapped to unevolved forms too, not just lower level —
  a level-3 Pidgeot looked bizarre) at 2-5.
- Pallet Town / Viridian City water (`data/wild/kanto_water.asm`): was Tentacool/Tentacruel and
  Poliwag/Poliwhirl at 50-55, now Tentacool/Poliwag only (unevolved) at 2-4.
- Route 1's four trainers (`data/trainers/parties.asm`): Danny (Jynx/Electabuzz/Magmar), Sherman
  (Furret/Pidgeot), French (Houndoom/Alakazam), Quinn (Venusaur/Starmie) — species/items left as-is,
  levels dropped from the 56-63 range down to 5-8.

**Explicitly deferred, not yet touched**: Viridian Gym's trainers and Blue (gym leader) are still at
their original postgame levels (62-69, Blue has EV-trained competitive movesets). User wants to reach
the gym naturally in-game first and decide its difficulty then, rather than pre-rebalancing it now.

**Not yet done**: everything past Viridian City (Route 2, Viridian Forest, Pewter, Mt. Moon, Cerulean,
etc.) is still at postgame levels — this was intentionally scoped down from "all the way to Vermilion"
to just Pallet/Route 1/Viridian for this first pass. Expect the next area past Viridian City to have
the exact same problem when reached.

## Open question for next session
Victoria's own starter (single level 5 Eevee) was set back when *both* Gold and Victoria started with
Eevee. Now that Gold picks a real 1-of-3 Kanto starter via the Poke Balls, Victoria's Eevee is
probably no longer the intended match — worth deciding: does she also get a real choice, a fixed
starter, or a type-advantage "rival counter-pick" (classic mechanic: beats whichever you chose,
cycling Bulbasaur→Charmander→Squirtle→Bulbasaur)? Not yet implemented either way.

## Fixed: starter balls all vanishing after a Victoria battle
Root cause confirmed by reading the actual engine code (`engine/overworld/scripting.asm`): the
`disappear` script command doesn't just hide an object for the current session — it calls
`ApplyEventActionAppearDisappear`, which **permanently sets that object's own associated event flag**
(its trailing `object_event` parameter) via `EventFlagAction`. Object visibility on every map
load/reload is later decided by `CheckObjectFlag` (`engine/overworld/map_setup.asm`): hidden if that
flag is set, shown otherwise.

Each ball script was calling `disappear` not just on itself, but also on the *other two* balls (to
hide them immediately once you'd chosen one) — e.g. picking Charmander called
`disappear OAKSLAB_BULBASAUR_BALL` and `disappear OAKSLAB_SQUIRTLE_BALL` too. That permanently set
all three balls' own flags to "collected" in one go, so any later map reload (a Victoria battle
triggers one via `reloadmapafterbattle`) correctly-per-the-engine hid all three.

Fix: removed the "also disappear the other two balls" calls from all three scripts — each script now
only ever calls `disappear` on its own ball. The other two remain visibly present after a choice is
made (a minor cosmetic difference from the classic single-frame instant-hide), but they're inert:
their own scripts still gate on `EVENT_GOT_A_POKEMON_FROM_OAK` and show `OakPokeBallText` ("that
Pokémon is doing fine") instead of re-offering a starter. Rebuilt clean; not yet re-verified live with
an actual before/after-battle comparison in mGBA.

## Fixed: object index mismatch broke `disappear`/`turnobject` in Oak's Lab
`object_const_def`'s sequential numbering must match each object's actual position in the *full*
`def_object_events` list, not just the objects that happen to have a `const` declared. When Victoria
and the three balls were added after 4 existing unnamed NPCs (aroma lady, 2 scientists, pokedex book)
without `const_skip` for each of them, every `OAKSLAB_*` constant after `OAKSLAB_EEVEE_DOLL` was off
by 4, so `disappear`/`turnobject` calls were hitting the wrong objects. Fixed by adding 4
`const_skip` entries. This was the cause of an earlier "wrong ball disappeared" symptom (now fixed;
the separate "all balls vanish after a battle" bug above is a different, still-open issue).

## Fixed: starter balls now sit in the display case, not on the floor
Moved the Eevee doll off its display case (was at object coords (7,3)) to floor tile (2,4), and moved
the three Poke Balls into that case at (6,3)/(7,3)/(8,3) instead. Confirmed visually — balls now
render neatly inside the glass case, matching the classic "starter selection" look, instead of sitting
on bare floor tiles. (Earlier considered hand-editing the map's block-level tile data to build a table
from scratch — abandoned that approach as too fragile without visual tile-editing tools; reusing the
existing display case was much simpler and lower-risk.)

## Where the code lives
- `engine/menus/intro_menu.asm`: `DebugGoldVsGreenBattle` (now nearly a no-op — starter giving moved
  to the Oak's Lab Poke Ball scripts) and `DebugPlayerName` ("RED"), hooked into
  `_NewGame_FinishSetup`, gated by `if DEF(DEBUG)`. Also sets `wInitialOptions`/`wInitialOptions2`
  directly (skipping the menu) and `wDefaultSpawnpoint` + `wLastSpawnMapGroup`/`wLastSpawnMapNumber`
  (the whiteout-respawn fix, see below).
- Victoria registered as a real trainer class (constant `GREEN`, display name "Victoria") across the
  parallel per-class tables: `constants/trainer_constants.asm`, `data/trainers/{class_names,
  attributes,dvs,party_pointers,pic_pointers,palettes,final_text}.asm`, `data/trainers/parties.asm`
  (`GreenGroup` section — uses `DEF _tr_class = GREEN` to resync the class-ordering assert, since
  `FIREBREATHER_ASHES` skips registration and reuses `FirebreatherGroup`'s data).
- Her battle sprite: `gfx/trainers/green.png` (56x56, 4-shade grayscale, hand-edited by the user in
  LibreSprite — see Sprite status below) + `gfx/trainers/green.pal`, registered in `gfx/trainers.asm`.
- Her overworld placement + trainer script (`TrainerVictoria`) and the three starter Poke Ball
  scripts (`BulbasaurPokeBallScript`/`CharmanderPokeBallScript`/`SquirtlePokeBallScript`) all live in
  `maps/OaksLab.asm`. New event flags for this: `EVENT_BEAT_VICTORIA`,
  `EVENT_{BULBASAUR,CHARMANDER,SQUIRTLE}_POKEBALL_IN_OAKS_LAB` (added near the end of
  `constants/event_flags.asm`, before `const_next $8ff`).

## Whiteout/blackout respawn fix
`GetWhiteoutSpawn` (`engine/events/whiteout.asm`) reads `wLastSpawnMapGroup`/`wLastSpawnMapNumber` to
decide where to send you after blacking out — **not** `wDefaultSpawnpoint`. That pair is normally only
set by physically walking into a Pokemon Center tileset map (`engine/overworld/warp_connection.asm`).
Since this debug flow never visits one, it defaulted to garbage/zero, causing blackouts to send the
player to `SPAWN_HOME` instead of Pallet Town. Fixed by explicitly setting
`wLastSpawnMapGroup = GROUP_PALLET_TOWN` / `wLastSpawnMapNumber = MAP_PALLET_TOWN` alongside the
spawnpoint in the debug hook. Verified live: intentionally lost to Victoria, confirmed respawn in
Pallet Town.

## Resolved: "Sylveon's movepool shown before your turn" — not a bug (from an earlier design)
This was `AIDebug` (`engine/battle/ai/move.asm:348`), an existing debug-only feature already built
into Polished Crystal. Shows the opponent's current Pokémon's 4 moves plus the AI's calculated score
for each, whenever the AI scores its options. Normal for `make debug` builds, doesn't affect real
gameplay logic. Left as-is (useful for seeing AI reasoning). Note: this was from the earlier
"Sylveon/Flareon instant battle" design — now that starters are level 5 Eevee/Kanto-starter, the same
mechanism still applies but is less likely to be noticed given weaker movesets.

## Sprite status — paused here for now (user's call)
`gfx/trainers/green.png` (Victoria's battle portrait) has been hand-edited by the user in LibreSprite
across many passes: background fixed to white (was inverted by an earlier auto-generation bug),
proportions corrected, legs/dress added by hand (original reference art was a bust portrait with no
legs), eyes added, and a proper hairline drawn separating hair from face (earlier passes had hair and
face sharing one shade with no drawn boundary — that's fixed now, they're genuinely separate regions).
Still 56x56, 4-shade grayscale, compiles cleanly. LibreSprite (`~/.local/bin/LibreSprite.AppImage`,
desktop launcher installed) is the tool.

**Color system**: this format allows exactly 4 shades total — white and black are fixed, and exactly
2 more (the source PNG's light-gray/170 and dark-gray/85 pixel values) are freely recolorable via
`gfx/trainers/green.pal`. This is a hard Game Boy hardware limit (`rgbgfx -c dmg`, DMG-compatible
mode), not something specific to this file — every trainer portrait in the game follows the same
rule, and even Pokémon's own battle sprites (checked Umbreon/Eevee/Sylveon/back sprites too) are
equally limited to 4 shades and even share the same `.pal` file between front/back; they just read as
more colorful because their 2 tunable colors are chosen to contrast more (e.g. Sylveon uses pink +
blue) or because back sprites render larger on screen, not because of extra color slots.

**Current final assignment** (moved on from the earlier "dark forest" green theme to black
hair + pale skin tone):
- White (255, fixed) = eye whites
- Light-gray (170) = pale neutral skin tone, `RGB 23,19,16` — used for face/hands
- Dark-gray (85) = muted dark olive-brown, `RGB 10,12,08` (started from hex `#2d3225`, converted to
  GBC's 5-bit-per-channel scale, then brightened ~2x after the first pass was too close to black to
  read against the outfit/outline) — used for hair shading detail
- Black (0, fixed) = hair (main mass), outfit, outlines

User paused active sprite work here — no further changes planned until they pick it back up.

## Testing notes
- Launch with `mgba-qt -C mute=1 -C autoload=0 <rom>` — `mute=1` keeps it silent without touching the
  user's global mGBA config (which would also mute their other ROMs); `autoload=0` is important,
  otherwise mGBA resumes the last savestate instead of actually booting fresh, which was a real
  source of confusion during testing (looked like code changes weren't taking effect).
- Automated input/screenshot testing in this environment used Xlib (XTEST) directly against the X11
  display — no root needed. Tab toggles mGBA's fast-forward (held), useful for skipping through
  battles quickly during testing.
- Always `pkill -9 -f mgba-qt` and confirm no process remains (`pgrep`) before relaunching for a test
  — stale processes/windows caused confusing stale-state screenshots more than once this session.

## Git
Everything through this session is committed on `master` (local only, not pushed to GitHub).
Commits so far: initial Gold vs Victoria debug harness, sprite background-inversion fix, and this
session's changes (skip-settings-menu + Natures off, Pallet Town spawn + whiteout fix, Victoria moved
from an instant battle to a real Oak's Lab NPC encounter, RED name, 3-starter Poke Ball choice,
sprite leg/proportion edits). Working in
`.claude/worktrees/polishedcrystal-setup/PolishedCrystal`, not yet moved back to
`~/DraganIndustries/PolishedCrystal`.
