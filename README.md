# Pokémon Crystal Origins


## Changes

* Red's origin story.
  * Player starts as Red in lieu of Gold.
  * Player starts in Kanto in lieu of Johto.
  * Gold is the final boss in Mt Silver [TODO].
* Game Changes:
  * Dialog prevents player from entering patch of grass in route 1 until player selects a starter.
  * Guards prevent player from entering path to the elite 4.
    * Player is permitted to pass once 8 badges are obtained.
  * Two extra trainers in viridian forest (bird keepers).
  * Redesign of Viridian's Gym.
* Younger Oak
  * Oak is the first and last gym leader in Kanto.
    * Instead of receiving a gym badge, player unlocks farming.
  * Oak's team depends on the player's starter Pokemon.
    * If player chose Charmander, Oak has Squirtle and Bulbasaur.
    * Always starts with a Pikachu (Pokemon Yellow reference).
* New Characters
  * Olive:
    * First appearance in Oak's lab.
    * Gives you 5 Pokeballs and 2 oran berries when you defeat her.
    * Starts with a level 4 Eevee.
    * Appears again at the end of Viridian Forest.
    * Blocks you from entering Pewter City until you defeat Oak [TODO].
      * She will battle you once Oak is defeated
      * Her Eevee will have hidden power. The type will depend on the player's starter pokemon [DONE].
* Farming Simulation
  * Added hoe + tilling (WIP)
  * Gardener Adam [TODO]
   * Tends to your gardens while player is completing other objectives.
* Increased difficulty
*   Brock's ace is lvl 25.

## Plans
* Replace HM functionality with farming simulation features.
  * Pick-axe -> Gets rid of boulders -> Player can collect stones.
  * Hatchet -> Gets rid of trees -> Player can collect wood.
* Farming Materials
  * Stones and Wood can be used to upgrade Gardener Adam's capabilities.
    * For example, 50 stones + 20 wood allows for silver rated crop.
    * Discoverable Key items can be given to Adam upgrade beyond built in constraints.
      * Example: Fertilizer can be given to Adam which allow for gold crop to grow.

## How to Build

Requires [RGBDS 1.0.1](https://rgbds.gbdev.io/) and `make`.

```bash
git clone https://github.com/MichaelDragan/PokemonCrystalOrigins.git
cd PokemonCrystalOrigins
make
```

Full platform-specific setup (Windows/Mac/Linux) is in [INSTALL.md](INSTALL.md).

## Download and Play

**[Download the latest build here](https://github.com/MichaelDragan/PokemonCrystalOrigins/releases/tag/latest)** — `CrystalOrigins.gbc`, rebuilt automatically from the newest commit on `main`. Load it in an accurate Game Boy Color emulator (e.g. [SameBoy](https://sameboy.github.io/), [mGBA](https://mgba.io/), [BGB](https://bgb.bircd.org/)).

## Reference

Living companion docs, updated as the game changes:

- **[Trainer Roster](https://claude.ai/code/artifact/09bea257-d18c-4a5f-9b21-ee4639983125)** — every trainer battle, in walking order.
- **[Wild Encounters](https://claude.ai/code/artifact/ee6ccff9-640a-4670-b0ac-c25f724a4651)** — wild grass/water tables by species, level, and time of day.

## Changes introduced in Polished Crystal

- **Customizable New Game Setup:** You can now toggle Natures and Abilities on/off, choose how EVs work (classic no-limit, modern 510 limit, or disabled), and configure various other gameplay options before starting a new adventure.
- **DVs No Longer Determine Natures/Shininess/Gender/Unown Form:** DVs still affect color variation (slightly different hues for the same species), but everything else is now handled separately.
- **Overhauled Battle Engine and HUD:**
  - Abilities are now supported.
  - Moves have been updated to behave more like their modern counterparts.
  - Minor HUD improvements make battles more streamlined.
- **Revamped Move Animations:** Many moves have updated animations.
- **Optimized Engine and 60fps Overworld:** The game engine has been heavily optimized for smoother performance, and the overworld now runs at 60 frames per second.
- **Storage System Redesign:** The PC storage interface is more like modern Pokémon games. You can switch boxes, move Pokémon around, and manage your party with minimal saving hassles.
- **HGSS-Inspired Pokédex:** The new Pokédex includes base stats, egg groups, and a more comprehensive encounter map showing *all* methods of obtaining Pokémon.
- **Enhanced Overworld Weather:** Instead of just darkening the screen, you’ll now see proper rain, snow, or sandstorms in applicable areas.
- **Revamped Summary Screen:** Replaces the vanilla stats screen. Shows nature, abilities, seen and caught data, and more.

## Features
A full list of features is in [FEATURES.md](FEATURES.md). Some highlights:

- **289 Pokémon species**, including some new evolutions, plus **56 cosmetic forms** (e.g., Magikarp patterns, Pikachu Fly/Surf, Arbok patterns, Unown Forms) and **46 variants** (Alolan, Galarian, Hisuian, etc.)—for a total of **391 unique Pokémon**.
- **73 new moves** (72 on faithful builds), **75 TMs**, and **31 move tutors**.
- Modern mechanics, such as the **Fairy type**, **Physical/Special split**, **Natures**, **Abilities**, and more.
- **Unlimited TMs** and quality-of-life features like **Running Shoes** and continuous **Repel**.
- **New/Revamped Maps**: Some from R/B/Y, some devamped from HG/SS, plus original locations.
- **New Characters** including Lorelei and Agatha (R/B/Y), Lyra and the Team Rocket Executives (HG/SS), and others.
- **More Post-Game Content**: Gym Leader rematches, a new event after battling Red, and more.
- **Improved Level Curve** with steadily increasing challenges.
- **Music and Graphics** devamped from newer generations.

---

### What's next
Continuing the level-curve rebalance past Pewter City (Mt. Moon is done, Cerulean onward isn't). No decisions yet on what changes on the Johto side once that's reachable — for now the assumption is Johto stays closer to vanilla Polished Crystal, arrived at post-Kanto instead of pre-Kanto.
