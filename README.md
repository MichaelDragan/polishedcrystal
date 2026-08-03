# Pokémon Polished Crystal

This is a custom Pokémon game based on [the Pokémon Crystal disassembly](https://github.com/pret/pokecrystal).

My goal is to create what the title says: an improved, polished version of Pokémon Crystal. It fixes bugs, takes into account the official game changes since 2001, and adds some new ideas of my own. Many features restore what was removed from R/B/Y, or original to HG/SS.

I've had vague plans to make a Pokémon game for years. I'm very impressed by the effort that's gone into disassembling Pokémon Crystal and making the code so well-organized. Thanks to making it open-source (and to the ROM hackers that inspired me), I'm finally making this game a reality.

> There are many ways to create games but the way we work at Game Freak may be a little different from other companies. That is, we constantly change and tweak what we have come up with. To make a fun game even more fun and polish it up, we take what we have made and start thinking about it from scratch. And to make the game the most fun to play we make endless changes and tweaks no matter how long it takes. It may not be the best way, but I think these tweaks are important to make our games fun and better.
>
> — Junichi Masuda, "[HIDDEN POWER of masuda No. 7](https://www.gamefreak.co.jp/blog/dir_english/?p=21)"

## Download and Play

The **current official release** is **v3.2.3** (the “Polished Crystal” release). It's fully playable from start to finish and includes major overhauls to gameplay, mechanics, and quality of life. A more detailed changelog is forthcoming, but you can find the major highlights below.

- **[Download v3.2.3 here](https://github.com/Rangi42/polishedcrystal/releases/tag/v3.2.3)**

The previous official version was [v3.1.1](https://github.com/Rangi42/polishedcrystal/releases/tag/v3.1.1) (February 1, 2025).

*If you have any questions about playing or patching, [read the FAQ](FAQ.md)!*

## What’s New in v3.2.3

Below is a brief summary of the major changes and additions. A more detailed changelog will be released soon.

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

## Discussion

If you have questions or comments, please check or post on any of these sites. (Read the [FAQ](FAQ.md) first if you have general questions!)

- [Discord](https://discord.gg/ZK5pqK8)
- [Skeetendo](https://hax.iimarckus.org/topic/6874/)
- [PokéCommunity](http://www.pokecommunity.com/showthread.php?t=373172)
- [Romhack.me](http://www.romhack.me/polishedcrystal/wall/)
- [/r/PokemonROMHacks](https://www.reddit.com/r/PokemonROMhacks/comments/51kbcn/pok%C3%A9mon_polished_crystal_200/)
- [Nuzlocke Forums](http://s7.zetaboards.com/Nuzlocke_Forum/topic/11003710/)
- [Pokémon Hackers Online](http://www.pokemonhackersonline.com/showthread.php?t=15811)

Additional resource:

- [PolishedDex](https://www.polisheddex.app/) — An online companion for Polished Crystal. PolishedDex provides a searchable Pokédex, move list, item list, locations, abilities, special events, and a team builder. It also includes a FAQ and links to the official ROM releases, making it a convenient reference while playing.

## Screenshots

![title-screen](screenshots/title-screen.png)
![which-photo](screenshots/which-photo.png)
![running-shoes](screenshots/running-shoes.png)
![town-map](screenshots/town-map.png)
  
![lyra](screenshots/lyra.png)
![cherrygrove-city](screenshots/cherrygrove-city.png)
![pokemon-center](screenshots/pokemon-center.png)
![bag](screenshots/bag.png)
  
![oaks-aide](screenshots/oaks-aide.png)
![move-tutor](screenshots/move-tutor.png)
![moss-rock](screenshots/moss-rock.png)
![rich-boy](screenshots/rich-boy.png)
  
![tm43](screenshots/tm43.png)
![game-corner-prizes](screenshots/game-corner-prizes.png)
![goldenrod-move-tutor](screenshots/goldenrod-move-tutor.png)
![eviolite](screenshots/eviolite.png)
  
![wonder-trade](screenshots/wonder-trade.png)
![ecruteak-shrine](screenshots/ecruteak-shrine.png)
![cowgirl](screenshots/cowgirl.png)
![olivine-city](screenshots/olivine-city.png)
  
![remoraid](screenshots/remoraid.png)
![team-rocket](screenshots/team-rocket.png)
![steelix](screenshots/steelix.png)
![custom-map](screenshots/custom-map.png)
  
![ice-rock](screenshots/ice-rock.png)
![hex-maniac](screenshots/hex-maniac.png)
![route-45](screenshots/route-45.png)
![summary](screenshots/summary.png)

![leppa-berry](screenshots/leppa-berry.png)
![regional-forms](screenshots/regional-forms.png)
![move-reminder](screenshots/move-reminder.png)
![moves](screenshots/moves.png)
  
![sylveon-moonblast](screenshots/sylveon-moonblast.png)
![togetic-fairy-wind](screenshots/togetic-fairy-wind.png)
![aerodactyl-fossil](screenshots/aerodactyl-fossil.png)
![cerulean-city](screenshots/cerulean-city.png)
  
![celadon-city](screenshots/celadon-city.png)
![weather](screenshots/weather.png)
![viridian-forest](screenshots/viridian-forest.png)
![mismagius](screenshots/mismagius.png)
  
![fighting-dojo](screenshots/fighting-dojo.png)
![silph-co](screenshots/silph-co.png)
![stormy-beach](screenshots/stormy-beach.png)
![rock-tunnel](screenshots/rock-tunnel.png)
  
![safari-zone](screenshots/safari-zone.png)
![soul-house](screenshots/soul-house.png)
![cinnabar-island](screenshots/cinnabar-island.png)
![seafoam-islands](screenshots/seafoam-islands.png)

---

## DraganIndustries: Project Journal

*This section covers my own fork's work on top of Polished Crystal — not the upstream project above. Notes to myself on the direction, in roughly the order I've been figuring it out.*

### The pitch: a Kanto-first story
Polished Crystal is built around Johto, with Kanto as postgame content you unlock after the Elite Four — every trainer and wild encounter over there sits at levels 50-70+. I flipped that: the game now starts fresh in **Pallet Town at level 5**, picking one of the three classic Kanto starters, and plays through Kanto as the *first* region rather than the last. Johto presumably comes after, once Kanto's 8 badges are in hand — Route 22 now has a pair of guards blocking Victory Road until then, so the story order is enforced rather than just implied.

That flip means basically the entire Kanto side of the map was tuned for a level-70 postgame visit, not a level-5 opening act. Most of the work so far has been rebalancing it region by region — swapping evolved trainer teams for their unevolved forms (a level-8 Venusaur is not a fair fight for a fresh starter, evolved-or-not) and dragging levels down into a sane early curve, rather than trying to rebalance all of Kanto in one giant pass.

**Rebalanced so far:** Pallet Town, Route 1, Viridian City, Viridian Gym (Oak's tutorial stage), Route 2 (both halves), Viridian Forest, Route 3, Mt. Moon, and the Pewter Gym.
**Still at old postgame levels, not yet touched:** everything past Pewter — Cerulean and beyond.

### Olive
Introduced a new companion character, Olive, who meets you in Oak's Lab right at the start — re-themed as a library for this early point in the story rather than a working Pokémon lab (Oak isn't really a professor yet here). She's a friend, not a rival: no ambush battle in the lab, just a chat, and Oak sends you off with a starter kit of Poké Balls and berries. She resurfaces later as a rematch at the Viridian Forest exit, and her Eevee's Hidden Power move is tuned to counter whichever starter you picked (Grass beats Squirtle, Water beats Charmander, Fire beats Bulbasaur) — a small "she's been paying attention" touch.

Gave her a fully custom overworld sprite and palette instead of reusing a stock NPC recolor, and a hand-edited battle portrait (paused for now, no further art changes planned until I pick it back up).

### Viridian Gym: a tutorial stage before it's a real Gym
Blue is the actual Gym Leader here, but true to character he's usually off adventuring somewhere — not an emergency, just typical Blue. Oak fills in and runs a practice battle (Pikachu plus whichever two starters you *didn't* pick), but he's explicit that he can't hand out a real Badge in Blue's place. The real fight — and the Earth Badge — waits until you've cleared the other 7 Kanto Gyms, at which point Blue's back and the tutorial trainers are swapped out for the real gauntlet. Added three new early trainers here (Youngster Milo, Lass Nadia, Schoolboy Percy) so the gym has some life in it even before the real fight unlocks.

### New trainers throughout
Beyond the gym, added and reworked a bunch of the wild-route cast: Youngster Joey and retuned teams on Route 1; Camper Rob and a reordered Doug on Route 2 South; Pokéfan Ed on Route 2 North; two new Bird Keepers (Porter with a solo Noctowl, Wesley with Hoothoot/Spearow) in Viridian Forest alongside the existing Bug Maniacs; and a reworked Brock lineup at Pewter (Sudowoodo in, Sandslash out, Onix promoted to a Life Orb-holding ace).

### Smaller systems
- **Badge-gated level cap**: your Pokémon won't out-level the current badge tier through grinding (cap rises with each Kanto badge, lifted entirely once Kanto's done) — keeps the curve from being trivialized by just grinding wild encounters.
- **Hoe key item** + tillable garden plots in Pallet Town, with tilled state persisting across map reloads.
- Route 1's grass entrance is gated until you've actually picked a starter, so you can't wander into wild encounters with an empty party.

### What's next
Continuing the level-curve rebalance past Pewter City (Mt. Moon is done, Cerulean onward isn't). No decisions yet on what changes on the Johto side once that's reachable — for now the assumption is Johto stays closer to vanilla Polished Crystal, arrived at post-Kanto instead of pre-Kanto.
