# CAD Fixture Recipes: static pages

This repository is a copy of the static pages of
[fixtures.dutchmancad.xyz](https://fixtures.dutchmancad.xyz), served by GitHub Pages.
It keeps those pages online when our own server is down for maintenance.

What is here:

- the front page, the Fixture Builder guides and their downloads (`builders/`),
- the recipe booklet (`booklet.pdf`), the reference drawings (`drawings/`),
- the progress scoreboard (`scoreboard/`), the CAM recipe list (`cam-recipes.json`) and the guide for agents (`agents.txt`).

Please use the pages at **https://fixtures.dutchmancad.xyz**, not the copies here: the site in front of this
repository sends each request to the right place.

What is not here: uploads, your private contributor page and anything else that needs our server. Those pages stay on
`fixtures.dutchmancad.xyz` and are briefly unavailable while it is down.

The files are rebuilt from the public pages every 15 minutes and after each scoreboard update, and every file passes a
privacy check before it is committed; a file that does not pass is left out here and stays on fixtures.dutchmancad.xyz only. The scoreboard holds only aggregate counts and the STEP files their authors
released under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/); native CAD files are never published
here.

Licenses: the booklet, `cam-recipes.json` and the reference drawings are licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) (credit: "Dutchman CAD fixture recipes, dutchmancad.xyz,
CC BY 4.0"). Released recipe files and the scoreboard data are [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). Please do not open pull requests against this repository: changes are overwritten on the next rebuild. To report a
problem, open an issue in [dutchman-cad/fixtures](https://github.com/dutchman-cad/fixtures).
