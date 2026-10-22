# Godot XR Template / Quest 3 change audit

Recorded: 2026-10-17 (Europe/Warsaw)

Project: `C:\Projects\pure3d handbook\godot-xr-template-4.6.0`

This audit records source code and scene changes made in this collaboration. Each entry names the exact project files, reason, and verification. Planning, research, generated-cache repair, and deployment operations are recorded separately in `Project_Operations_and_Planning_History.md` in the chat outputs folder.

## Source changes made by Codex on 2026-10-16

| Exact file | Role and change | Reason |
| --- | --- | --- |
| `game/main.tscn` | Main staging scene: set `prompt_for_continue = false`. | Let the desktop run pass the XR-only “hold trigger” prompt. |
| `game/start_scene/start_ui.gd` | Start-menu UI script: focus the first visible control when each menu pane opens. | Make keyboard menu navigation usable on the PC. |
| `game/zones/zone_base.tscn` | Shared gameplay-zone scene: attach XR Tools desktop movement, mouse look, mouse capture, and forward pointer. | Let the PC player move and interact without tracked controllers. The inherited zones use this shared scene. |
| `game/zones/desktop_input.gd` | New desktop input script: bind W/A/S/D to movement and F/left mouse to pointer interaction. | Supply actions consumed by the desktop support nodes. |

Quest controller bindings and the original XR interactions were not redesigned as part of these source changes.

### Source baselines and verification

Pre-change copies are in this chat workspace at `work/source-backup/main.tscn`, `work/source-backup/start_ui.gd`, and `work/source-backup/zone_base.before-desktop-20261016.tscn`. A diff against those copies confirmed the changes above. `game/zones/desktop_input.gd` was newly created.

After the desktop movement change, a Godot test run moved the player body about 2.9 m during one second of simulated forward input. The owner later confirmed that the project runs on the Quest 3. This verifies deployment and basic operation; it is not a complete gameplay test.

SHA-256 of the source files at the time of this record:

| File | SHA-256 |
| --- | --- |
| `game/main.tscn` | `606719CF657BBA4045B32755F4DAB25C324F4364F98AD8DF92ECB687A737B80B` |
| `game/start_scene/start_ui.gd` | `72DB6FBEC989C55DB4FED870AB2841FC94DD4F4DA521F491B0FC275A4C19638B` |
| `game/zones/zone_base.tscn` | `6BAD66725C8F0D56BC48D7D5C257E10E32EB774D2AE8DD92B81BB4BFA3A0E1A6` |
| `game/zones/desktop_input.gd` | `3B18D0AD65424FAC1FAD033A0AC6BE1F9AB4C68E1CB7CC4D653EEC4D38CD548A` |

## Conversion program added by Codex on 2026-10-22

| Exact file | Role and change | Reason |
| --- | --- | --- |
| `tools/Convert-DracoGlbForGodot.ps1` | New repeatable command that decodes one GLB or a directory of GLBs, checks that Draco is absent and basic scene counts match, and writes SHA-256 hashes to a manifest. | Make Draco-compressed Voyager/Pure3D models importable by Godot without changing the originals. |
| `tools/draco-converter/package.json` | Declares the local glTF Transform CLI dependency at version 4.5.1. | Keep the converter version explicit. |
| `tools/draco-converter/package-lock.json` | Locks the npm dependency graph used by `npm ci`. | Make future installations reproducible. |
| `.gitignore` | Excludes the installed `node_modules/` tree and converter npm cache. | Keep downloaded build dependencies out of source control. |

The Smithsonian Space Shuttle Discovery sample was converted in six detail levels. Every output passed the script's Draco and scene-count checks. Godot 4.7.2 then imported and instantiated all six decoded GLBs in a scratch project. The preview and low-detail outputs also imported inside this XR project. This confirms import compatibility on the PC; it does not validate Quest rendering, annotations, or scholarly edition metadata.

SHA-256 of the code and configuration files at the time of this record:

| File | SHA-256 |
| --- | --- |
| `tools/Convert-DracoGlbForGodot.ps1` | `6AF67111E0909A62BF0A4CEAAACACF99314701D00609B26C5F292AB0EA85C0EC` |
| `tools/draco-converter/package.json` | `78E5C7B10BB5AE1EB53920A9F6B7559B43F6AF341DA746CB555118E7F962AEF1` |
| `tools/draco-converter/package-lock.json` | `B31B0FE9319D163AFDED4E7123430FC7CF233CDC2263D0B35CBF55445E3D9FC2` |
| `.gitignore` | `1321756588EEF00E43DC8536676A18D504D895F8A8DF95594CF3E23DF3733E81` |

### Converter correction on 2026-10-22

Testing a real PURE3D GLB, `CodiceCospi.glb`, showed that glTF Transform merged duplicate texture entries from 10 to 6 while keeping six image entries and the five materials. The original count check rejected that output. `tools/Convert-DracoGlbForGodot.ps1` now permits a reduction in texture-entry count, warns that visual review is needed, and still requires scene, node, mesh, primitive, material, and image counts to match. `tools/DRACO_CONVERSION.md` documents the check. The source model was not modified.

The revised command decoded `CodiceCospi.glb` without Draco. Godot 4.7.2 imported and instantiated its output in a PC scratch project. Appearance, Quest rendering, and annotation alignment remain to be checked. SHA-256 of the revised `tools/Convert-DracoGlbForGodot.ps1`: `82625E23BDC28988DDB664F3B943D2C965B28F1E924D413C6D24245A8A4F95F0`.

