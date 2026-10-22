# Draco GLB conversion for Godot

`Convert-DracoGlbForGodot.ps1` is the repeatable conversion command. `draco-converter/package.json` and `draco-converter/package-lock.json` pin the glTF Transform CLI used by the command. The first run installs that dependency locally with `npm ci`; Node.js and npm must be installed.

From the project directory, convert one GLB or every GLB in an extracted asset folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Convert-DracoGlbForGodot.ps1 `
  -InputPath 'C:\path\to\downloaded-assets' `
  -OutputDirectory 'C:\path\to\decoded-assets'
```

Converted files end in `_godot.glb`; originals are preserved. The command checks that Draco is absent in each output and that scene, node, mesh, primitive, material, texture, and image counts match. `conversion-manifest.json` records source and output SHA-256 hashes. To replace existing outputs, add `-Overwrite`.

To import into Godot, copy a converted `_godot.glb` into the project's `assets/` directory, reopen or focus the editor, and drag the imported scene from the FileSystem dock into a 3D scene. Importing the model does not import annotations or articles from `scene.svx.json`.

The conversion uses [glTF Transform's `copy` command](https://github.com/donmccurdy/glTF-Transform/blob/main/packages/cli/src/cli.ts), which decodes Draco without intentionally changing scene, node, material, or other properties. It does not restore geometry precision that was lost during the original Draco encoding.
