# Clay
A procedural **clay** shader made in **Unity 3D**'s ShaderGraph.

<img alt="Clay demonstration gif" src="https://joebinns.com/documents/gifs/purveyor_of_stars.gif" />

## How does it work?
- **Textured fingerprints** leave dents in the normal and add smoothness to mock natural oils from skin.
- **Voronoi noise** is used to **flatten** normals, creating a handcrafted look.
- **Perlin noise** is modified to form valleys, dimming ambient occlusion and subtracting normals to create a **folded** appearance. (Doesn't look very good as yet).
- **Tileable Perlin noise** is used to displace mesh vertices at normals to the surface, providing a seamless **bumpy** look.
- **Small heptagonal impurities** are randomly generated on the surface. (Doesn't look very good as yet, and performs very poorly).

## Installation
Open the project in Unity. Open the Purveyor of Stars scene located at [*clay/Assets/Scenes/*](https://github.com/joebinns/clay/tree/main/Assets/Scenes).

## Warning
I created this procedural clay shader as an exercise in Unity 3D's ShaderGraph.  
Shaders are run every frame, and since this is an unbaked shader, it generates and then discards various noise textures each frame.  
**I would therefore strongly advise against using this shader in it's current state in commercial usage**.  
Instead, one could re-create the shader in Blender and bake it into materials and animations.  
You would then benefit from peak performance, with results that you can be just as happy with!

## Contributing
1. Fork the repository.
2. Create a branch for your feature: `git checkout -b my-shiny-feature`.
4. Commit your changes: `git commit -am 'Added my super shiny feature'`.
5. Push to the branch: `git push origin my-shiny-feature`.
6. Submit a pull request.

All contributions big and small are appreciated and encouraged!

## Credits
### Fingerprints texture
Courtesy of [cgbookcase.com](https://www.cgbookcase.com/textures/fingerprints-01/).

### All else
Is [my own](https://joebinns.com/).

## License (MIT License)
See [this page](https://github.com/joebinns/clay/blob/main/LICENSE) for more information.
