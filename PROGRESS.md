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

## Fixed: Victoria's Eevee was absurdly strong
`data/trainers/dvs.asm`'s `; green` entry still had `252, PERFECT_DVS` (max IVs + 252 EVs) left over
from when Victoria was a level 50 endgame-caliber Sylveon/Flareon duo — never scaled down when her
team became a single level 5 Eevee. Changed to `0, $66, $66, $66` (0 EVs, modest DVs), matching the
stat tier this hack uses for early low-level trainers like Youngster. Fair starter-vs-starter fight
now.

## Open question for next session
Victoria's own starter (single level 5 Eevee) was set back when *both* Gold and Victoria started with
Eevee. Now that Gold picks a real 1-of-3 Kanto starter via the Poke Balls, Victoria's Eevee is
probably no longer the intended match — worth deciding: does she also get a real choice, a fixed
starter, or a type-advantage "rival counter-pick" (classic mechanic: beats whichever you chose,
cycling Bulbasaur→Charmander→Squirtle→Bulbasaur)? Not yet implemented either way.

## Open bug: starter balls all vanish after a Victoria battle (NOT YET CONFIRMED FIXED)
User-reported: picked Charmander (red ball correctly disappeared, Bulbasaur/Squirtle correctly stayed
visible), then after a battle with Victoria (which sits right next to the balls, easy to walk into
her by accident), all three balls were gone from the display case. Root cause not confirmed yet —
working theory is that `reloadmapafterbattle` (fired by the `trainer` macro's generated script after
any battle with Victoria) reloads the map and re-evaluates each ball object's own visibility flag
(`EVENT_{BULBASAUR,CHARMANDER,SQUIRTLE}_POKEBALL_IN_OAKS_LAB`, the trailing parameter on each
`object_event`) — and since the ball scripts never actually `setevent`/`clearevent` those specific
flags (only the shared `EVENT_GOT_A_POKEMON_FROM_OAK` gate), their reload-time visibility may not
reflect "already taken" correctly. Compare against `EeveeDollScript`, which does correctly
`setevent EVENT_DECO_EEVEE_DOLL` on its own matching flag when collected — the ball scripts are
missing that equivalent call. **Not yet fixed or verified** — next step is to add the matching
`setevent`/`clearevent` calls per ball and confirm with a deliberate before/after-Victoria-battle
comparison.

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

## Sprite status
`gfx/trainers/green.png` (Victoria's battle portrait) has been hand-edited by the user in LibreSprite
across several passes: background fixed to white (was inverted by an earlier auto-generation bug),
proportions corrected (was too large for the canvas), legs added by hand (the original reference art
was a bust portrait with no legs below the hips), and eyes added. Still 56x56, 4-shade grayscale,
compiles cleanly. LibreSprite (`~/.local/bin/LibreSprite.AppImage`, desktop launcher installed) is the
tool.

**Color system**: this format allows exactly 4 shades total — white and black are fixed, and exactly
2 more (the source PNG's light-gray/170 and dark-gray/85 pixel values) are freely recolorable via
`gfx/trainers/green.pal`. This is a hard Game Boy hardware limit (`rgbgfx -c dmg`, DMG-compatible
mode), not something specific to this file — every trainer portrait in the game follows the same
rule, and even Pokémon's own battle sprites (checked Umbreon/Eevee/Sylveon) are equally limited to 4
shades; they just read as more colorful because their 2 tunable colors are chosen to contrast more
(e.g. Sylveon uses pink + blue).

Current assignment, themed as "dark forest": dark-gray (85) = deep forest green `RGB 03,08,03`,
light-gray (170) = lighter sage green `RGB 14,18,10`, reserved for the eyes once drawn with that
shade. Known side effect to be aware of: an earlier attempt to free up a color slot for the eyes
involved flattening all light-gray pixels to dark-gray, which unintentionally also recolored her face
shading (it was using the same shade as the hair highlights) — she doesn't have a dedicated
face-shading tone right now, it shares the hair/dark-green color. User was mid-decision on whether
that's fine or needs a redraw when this was last touched.

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
