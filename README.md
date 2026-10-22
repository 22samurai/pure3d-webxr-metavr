# Godot XR Template

![GitHub forks](https://img.shields.io/github/forks/godotvr/godot-xr-template?style=plastic)
![GitHub Repo stars](https://img.shields.io/github/stars/godotvr/godot-xr-template?style=plastic)
![GitHub contributors](https://img.shields.io/github/contributors/godotvr/godot-xr-template?style=plastic)
![GitHub](https://img.shields.io/github/license/godotvr/godot-xr-template?style=plastic)

This repository contains a template Godot project for building a simple VR game.

## Codex Cospi inspection prototype

This checkout is an experiment in viewing a PURE3D edition on Meta Quest 3. The current startup scene, `game/cospi/cospi_zone.tscn`, shows a decoded Codex Cospi model against a procedural sky with the template's tracked hands and pointers. The original demo scenes remain in the project. Model grabbing, SVX annotations, articles, and guided tours are not implemented yet.

The working Quest build is a native Godot/OpenXR Android APK. `export_presets.cfg` also contains a WebXR preset, but that path has not yet been tested with this edition. The decoded model and its textures are in `assets/cospi/`; see `assets/cospi/ATTRIBUTION.md` for source and rights information. `tools/DRACO_CONVERSION.md` explains how to recreate a Godot-compatible model from a Draco-compressed GLB.

Open the project with Godot 4.7.2, install the matching Android export and build templates, and choose the **Android Quest** export preset. The generated `android/build/gradle.properties` file is ignored by Git. For the current asset set on a 16 GB development PC, set `org.gradle.jvmargs=-Xmx6g -XX:MaxMetaspaceSize=1g` and `org.gradle.workers.max=2` in that file before exporting. Reapply those settings if the Android build template is regenerated. The exported APK belongs in a GitHub Release rather than in the source tree.


## Versions

Official releases are tagged and can be found [here](https://github.com/GodotVR/godot-xr-template/releases).

The following branches are in active development:
|  Branch  |  Description                  |  Godot version  |
|----------|-------------------------------|-----------------|
|   main   | Current development branch    |  Godot 4.6+     |
|    4.2   | Godot 4.2 development branch  |  Godot 4.2-4.5  |
|    4.1   | Godot 4.1 development branch  |  Godot 4.1      |
|    3.x   | Godot 3.x development branch  |  Godot 3.5+     |


# Assets

This project uses the following assets:
 - [Godot XR Tools](https://godotengine.org/asset-library/asset/1515)
 - [OpenXR Vendors](https://github.com/GodotVR/godot_openxr_vendors)

> [!NOTE]
> OpenXR Vendors is not included in the repo but will be downloaded by CI scripts.
> When cloning this repository, manually download the version correct for the version of
> Godot you are using.

# Getting Started

Start by downloading this asset from github; or by installing it from the Godot
Asset Library.

The game should be playable with a splash screen and two example scenes the player
can move between.

The game should be customized by:
 - Modifying the splash-screen texture to represent the game
 - Modifying the icon.png for the game
 - Add game state variables to the game_state.gd singleton class
 - Replacing the demo zones with zones suitable to the game


# Exporting to Android

The template contains a copy of the XR loaders plugin
and preconfigured exports for android based headsets that support OpenXR.

Before this can be used you do need to install the android build template.
Select the menu `Editor->Manage Export Templates...` to download the templates.
Select the menu `Project->Install Android Build Template...` to install the template.

Make sure you set the correct entry in the export templates to runable
if you want to use one click deploy to your device.

Please refer to the official documentation for Godots prerequisits for exporting to android:
https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

# Recommended Asset Locations

Common areas to find assets are:
 - [Godot Asset Library](https://godotengine.org/asset-library/asset)
 - [AmbientCG](https://ambientcg.com/) for object and sky textures
 - [Pixabay-Music](https://pixabay.com/en/music/search/) for music 
 - [FreeSound](https://freesound.org/) for sound effects
 - [Kenney.nl](https://kenney.nl/) 


# More Information

Information on the Godot XR Tools can be found on [the website](https://godotvr.github.io/godot-xr-tools/).

