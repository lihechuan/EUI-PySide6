# Brand icon assets

These 368 SVG files are from [Skill Icons](https://github.com/tandpfun/skill-icons) at commit `7f7e691e71aec64e8354bf697835e009d1ad80f8`. The original filenames are converted to their existing `EIcons` enum names (`-` becomes `_`, then uppercase).

They restore the colors and complete shapes of the brand icons whose individual layers are stored separately in `EFont.ttf`. The public `EIcon.iconSource` values remain unchanged. All other icons continue to use the bundled font.

Copyright (c) 2022 tandpfun. Distributed under the MIT license in [LICENSE](LICENSE).

The Firebase SVGs replace two pattern-filled rectangles with equivalent image elements containing the unchanged upstream embedded PNGs. This keeps the same artwork while allowing Qt 5 SVG rendering, which does not support those pattern references.
