# PUREQuest Cospi: A proof of concept.

An experiment to use Godot's WebXR tools to create a native PURE3D experience that can be used on Meta Quest VR platforms.

v0.3 presents the Codex Cospi, supports walking around the floor-plane (don't fall off!) and interacting with editions via grab-and-drop functionality. Resolution is surprisingly high and interaction with objects in this manner is extremely natural.

[Watch the v0.3 Quest recording](media/purequest-cospi-v0.3.mp4)

Goals for further iterations: reading svx files, placing annotations on objects, VR information panels and labels, actual walls (you can walk off the floor right now [hey, proof of concepts have these kinds of things!]), and continuing to refine the experience.

AI Disclosure: Chat GPT Sol used for configuration and removing the .glb file's Draco compression so Godot can run them. I walked through a custom tutorial, but the world was built manually upon the OpenXR demo world by myself.

## Technical notes

The current Quest APK is a native Godot/OpenXR application. The repository also contains a WebXR export preset, which targets a browser and has not yet been tested with this edition. The project builds on the [Godot XR Template](https://github.com/GodotVR/godot-xr-template) and [Godot XR Tools](https://godotvr.github.io/godot-xr-tools/).

The decoded Codex Cospi model and textures are in [`assets/cospi/`](assets/cospi/). See [`assets/cospi/ATTRIBUTION.md`](assets/cospi/ATTRIBUTION.md) for source and rights information. [`tools/DRACO_CONVERSION.md`](tools/DRACO_CONVERSION.md) explains the Draco conversion. The original XR demo scenes remain available.

Open the project in Godot 4.7.2 with matching Android export and build templates, then select the **Android Quest** export preset. The exported APK belongs in a GitHub Release. To install over USB on Windows, connect the Quest, accept the USB debugging prompt, and run `deploy_quest.bat "build/android-quest/PQ Cospi v0.3.apk"` from this folder. The app appears under **Unknown Sources**.
