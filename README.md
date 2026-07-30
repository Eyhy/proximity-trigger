# Strike and Release project website

Static academic project page for **Strike and Release: Proximity-Guided Transient-Contact Control for Robotic Percussion** by Hongyi Yang and Chenxi Xiao, ShanghaiTech University.

## Prerequisites

- Node.js 20 or newer and npm
- Optional: `ffmpeg` and `ffprobe` for converting the two high-speed AVI recordings

## Install and develop

```sh
npm install
npm run dev
```

Astro prints the local development URL. The site uses only local assets and has no backend, analytics, remote fonts, or cookies.

## Production build

```sh
npm run build
npm run preview
```

The static output is written to `dist/`.

## High-speed video conversion

Browsers are not asked to play the source AVI files. If the converted MP4 files are absent, the release comparison automatically displays the supplied poster images, and the build remains valid.

On macOS, Linux, or Git Bash with FFmpeg installed:

```sh
sh scripts/convert-release-videos.sh
```

The script first inspects both sources with `ffprobe`, then runs the equivalent of:

```sh
ffmpeg -i webpage/videos/release-short.avi -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an public/videos/release-short.mp4
ffmpeg -i webpage/videos/release-long.avi -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an public/videos/release-long.mp4
```

Source timing and frame rate are preserved. Run `npm run build` again after conversion; Astro will then include the MP4 players. The generated HTML never points to AVI media.

## Asset layout

```text
public/
  paper.pdf
  favicon.svg
  images/       # teaser, method figure, waveforms, posters, and setup photos
  videos/       # five demonstrations and optional converted release MP4s
webpage/        # original supplied source assets, including the AVIs
```

To update the paper, replace `public/paper.pdf`. Replace figures or videos with the same case-sensitive filenames, or update their paths in `src/pages/index.astro`. Keep the five demonstration filenames unchanged unless every reference is updated. To refresh a release video, replace its AVI in `webpage/videos/`, remove the old generated MP4, and rerun the conversion script.

The BibTeX in `src/pages/index.astro` is explicitly provisional. After publication, replace it with authoritative venue metadata; do not add a DOI until one exists.

## GitHub Pages

The included workflow builds and deploys on pushes to `main`. In repository **Settings → Pages**, select **GitHub Actions** as the source.

`astro.config.mjs` reads two deployment variables:

- `SITE_URL`: origin only, such as `https://USERNAME.github.io`
- `BASE_PATH`: repository subpath, such as `/REPOSITORY/`

The workflow derives both from GitHub context, so no username is hard-coded. All page assets use Astro's `BASE_URL` and continue to work under a repository subpath. For a custom domain, set `SITE_URL` to that origin and `BASE_PATH=/` in the workflow (and configure the domain in GitHub Pages). For a renamed repository, the workflow automatically uses the new repository name. Local development continues to use Astro's configured default base; override it when needed, for example in PowerShell:

```powershell
$env:SITE_URL='https://example.github.io'; $env:BASE_PATH='/repository-name/'; npm run build
```
