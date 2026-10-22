# Codex Cospi model and textures

`CodiceCospi_godot.glb` and the six `CodiceCospi_godot_*.jpg` textures are derived from the 3D model in Alice Bordignon and Davide Domenici's *Codex Cospi* PURE3D scholarly edition (2025).

- Edition: https://editions.pure3d.eu/project/14/edition/1/index.html
- PURE3D introduction and author credit: https://pure3d.eu/new-3d-scholarly-edition-codex-cospi/
- Authors' article: https://doi.org/10.1016/j.daach.2025.e00474
- Source asset base used on 2026-10-22: https://main.57-129-98-223.sslip.io/assets/project/14/edition/1/

The authors describe the bilingual edition and its downloadable model, articles, media, and scene description as published under a **CC BY** license. Their accessible description does not specify a version of CC BY. Preserve attribution to Bordignon and Domenici, link the edition and license information, and identify changes when redistributing these assets. This attribution applies to the Cospi edition assets, not to the Godot XR template's MIT-licensed software.

The original `CodiceCospi.glb` uses `KHR_draco_mesh_compression`. `tools/Convert-DracoGlbForGodot.ps1` used glTF Transform CLI 4.5.1 to decode that compression and prepare the Godot copy. The original geometry was not intentionally edited; duplicate texture entries were merged during conversion. The six JPGs are texture images extracted for Godot import. The project currently includes the model and textures, but not the edition's SVX document, articles, audio, or other media.
