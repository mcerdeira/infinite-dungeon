# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

"Infinite Dungeon" (working titles also considered: "Shifting Hell", "Shifting Caves" — see `docs/Nombres?.txt`) is a 2D action-platformer built in **Godot 4.7** (GDScript, GL Compatibility renderer). The player explores a randomly-generated, screen-by-screen dungeon, fighting enemies, collecting key items (map, double jump, fly, radar, homing, bomb arrows) and secondary items (extra arrows, life, flasks), using an estus-flask-style healing system.

There is no other language/build toolchain in this repo (no npm/cmake/etc.) — everything is Godot scenes (`.tscn`) and GDScript (`.gd`).

## Running / editing

- Open the project in the Godot editor: `godot -e --path .` (or just open `project.godot` with the Godot 4.7 editor).
- Run the game headless from the CLI: `godot --path .`
- The main scene is set via `run/main_scene` in `project.godot` (currently `scenes/main.tscn`, which loads `main_game.tscn`).
- There is no automated test suite, linter, or CI config in this repo — verify changes by running the game in the editor.
- `.godot/` is the editor's generated cache (gitignored) — never hand-edit files there.

## Architecture

### Global autoload (`scripts/Global.gd`)
Singleton (`Global`) holding all cross-scene state: player position in dungeon-grid coordinates (`player_posision`), the dungeon layout (`rooms_array`), the actual room scenes picked for each cell (`rooms_objs_array`), per-room metadata (`rooms_metadata_array` — visited/cleared/which key item spawns there/etc.), player upgrade flags (`DOUBLEJUMP`, `FLY`, `HOMING`, `BOMB`, `HASMAP`, `HASRADAR`), and consumables (`LIFE`, `ARROWS`, `FLASK`). It also owns the seeded RNG (`dungeon_rng`, seeded from `DUNGEON_SEED`) and helpers for picking random rooms/items. `Global.MainGame` and `Global.player_obj` are back-references set by those nodes at `_ready()`.

### Dungeon generation is two parallel grids
The world is a 1000×1000 logical grid (`Vector2` cell coordinates), generated once per run:
- `scenes/main_game.gd` (`generate_dungeon()`) does a random walk from `Global.map_center` in the 4 cardinal directions to carve out the dungeon shape, then stores a **room-type id** (0–14, encoding which of the 4 sides — up/down/left/right — connect to a neighboring room) per cell in `Global.rooms_array`. It also decides which cells hold the 3 key items and which hold secondary items, storing that in `Global.rooms_metadata_array`.
- Each cell's room-type id maps to a folder name via `Global.foldername_by_id()` (e.g. `LEFT_UP_RIGHT`), and `Global.get_random_room(folder_id)` picks a random `.tscn` from `res://scenes/rooms/<FOLDER>/` matching that connectivity shape. Room scene variants live under `scenes/rooms/<DIRECTION_COMBO>/*.tscn` (folders: `DOWN`, `UP`, `LEFT`, `RIGHT`, `UP_DOWN`, `LEFT_RIGHT`, `FULL`, and diagonal combos like `LEFT_UP_RIGHT`).
- `scenes/main.gd` builds a **separate minimap representation** (`map_room.tscn` instances, one per occupied cell) from the same `Global.rooms_array`/`rooms_objs_array`, toggled visible with the `map` input action.

### Room switching (screen-by-screen, not scrolling)
Only one room is ever instantiated as the actual playable scene at a time. `main_game.gd`'s `switch_room()`/`gen_room()`:
1. Frees the current room (group `"rooms"`) and instantiates `Global.rooms_objs_array[x][y]` for the player's current cell.
2. Re-activates any persisted `"items"`/`"arrows"` group nodes belonging to that cell (`room_bellong == Global.player_posision`) — this is how dropped/uncollected items persist across room visits.
3. Applies `set_item()`/`set_item2()` on the room based on that cell's metadata (key item vs. secondary item).

The player leaving the visible screen rect triggers `player.gd`'s `_on_visibility_notif_screen_exited()` → `Global.MainGame.navigate_dugeon()`, which increments/decrements `Global.player_posision` by one grid cell in the exit direction and calls `switch_room()` again. The very first two scenes shown are hardcoded (`Global.hardcoded_intro_room`, then `hardcoded_pre_room`) before the generated dungeon takes over.

### Player, items, enemies
- `scenes/player.gd`: movement/combat state machine (run, jump, double-jump, fly, ranged shoot via `bullet.tscn`, melee whip attack, estus flask heal, hit/death, "going inside/outside" transition animation used when switching rooms).
- `scenes/item.gd`: generic pickup (`@export var wich_item`) — floats in place, and on player contact calls the matching `Global.got_*()`/`arrow_catch()`/`get_life()` and plays a pickup animation on the player. Items track which grid cell they belong to (`room_bellong`) for the activate/deactivate persistence described above.
- `scenes/enemy.gd` is the base enemy behavior; `enemy_walker.gd` and `enemy_eye.gd` extend/specialize it for specific enemy types (sprites under `sprites/enemies/`).
- `scenes/door.gd` / `door_big.gd`: bounce/knockback triggers used as connectors between rooms and hazards.
- `scenes/ui.gd`: HUD (life hearts, arrow count, flask charges, debug coordinate label).

### Coordinate systems to keep straight
- **Dungeon-grid coordinates** (`Vector2` of small integers, e.g. `Global.player_posision`, `Global.rooms_array` indices) — one unit = one room/screen.
- **World/pixel coordinates** (`global_position`) — used within a single room for actual gameplay physics.
Don't confuse the two when touching dungeon-generation or room-transition code.
