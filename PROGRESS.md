# Gold vs Victoria — progress notes

## Setup
- Forked `Rangi42/polishedcrystal` to `MichaelDragan/polishedcrystal` on GitHub, cloned into `~/DraganIndustries/PolishedCrystal`.
  - `origin` = your fork, `upstream` = Rangi42's original (for pulling updates).
- RGBDS v1.0.1 toolchain installed to `~/.local/bin` (rgbasm/rgblink/rgbfix/rgbgfx), no sudo/system install needed.
- `make` builds the normal ROM; `make debug` builds the debug variant with the test harness below.

## Debug test harness: Gold vs Victoria
In `make debug` builds only (the regular `make` build is untouched), starting **New Game** skips
name entry, gender selection, and the Elm intro cutscene entirely, and drops straight into a battle:

- **Gold** (you) gets a fixed party, both level 50, **Umbreon leads**:
  - **Umbreon** (lead, slot 1): Calm Mind, Substitute, Baton Pass, Moonlight (Healing Light) —
    classic Calm Mind + Sub Baton Passer build.
  - **Jolteon** (slot 2): Thunderbolt, Agility, Thunder Wave, Double-Edge
- **Victoria** (opponent, internal trainer class name is still `GREEN` — only the in-battle display
  name was changed, renaming the code symbol wasn't necessary), level 50 duo:
  - **Sylveon** @ Leftovers, Pixilate — Moonblast, Play Rough, Draining Kiss, Light Screen
  - **Flareon** @ Life Orb, Flash Fire — Flare Blitz, Double-Edge, Bite, Flame Charge

Verified end-to-end in mGBA: party injection works, movesets/PP are correct, Umbreon correctly leads
in slot 1, Victoria's data compiles and battles correctly (in-battle text confirmed showing
"Pkmn Trainer Victoria"), AI plays sensibly.

### Where the code lives
- `engine/menus/intro_menu.asm`: `DebugGoldVsGreenBattle` (party injection + battle trigger) and
  `DebugPlayerName`, hooked into `_NewGame_FinishSetup` right after `SetInitialOptions`, gated by
  `if DEF(DEBUG)`.
- Victoria registered as a real trainer class (constant `GREEN`) across the parallel per-class tables:
  `constants/trainer_constants.asm`, `data/trainers/{class_names,attributes,dvs,party_pointers,
  pic_pointers,palettes,final_text}.asm`, `data/trainers/parties.asm` (`GreenGroup` section — note
  it uses `DEF _tr_class = GREEN` to resync the class-ordering assert, since `FIREBREATHER_ASHES`
  skips registration and reuses `FirebreatherGroup`'s data).
- Her sprite: `gfx/trainers/green.png` (56x56, 4-shade grayscale) + `gfx/trainers/green.pal`,
  registered in `gfx/trainers.asm`.

## Known issue (not yet investigated)
Sylveon's movepool sometimes displays before your own turn in battle. Flagged, needs a repro + look
at the battle menu flow.

## Sprite status
`gfx/trainers/green.png` is still just a rough auto-downscaled draft generated from your reference
art (`~/Pictures/green.png`) — it compiles fine but needs a real hand redraw (outlines are noisy,
face isn't legible yet). LibreSprite (`~/.local/bin/LibreSprite.AppImage`, installed with a desktop
launcher entry) has both files open for that.

## Open items / next steps
- Redraw Victoria's sprite properly in LibreSprite.
- Investigate the Sylveon-movepool-before-your-turn glitch.
- Moves can be changed to anything in the game since they're injected directly, not taught via TM —
  just ask for a specific moveset/role and it's a quick edit in `engine/menus/intro_menu.asm`.
- Nothing has been committed to git yet — current work is uncommitted in the worktree at
  `.claude/worktrees/polishedcrystal-setup/PolishedCrystal` (not yet moved back to the normal
  `~/DraganIndustries/PolishedCrystal` location).
