# Codex Task: Build the ROBIO 2026 Academic Project Website

You are working inside a repository that contains a `webpage/` directory with the following assets:

```text
webpage/
  paper.pdf

  images/
    teaser.svg
    method-overview.svg
    waveform-short.svg
    waveform-long.svg
    release-short-poster.png
    release-long-poster.png
    robot-platform.png
    sensor-mallet-assembly.png

  videos/
    release-short.avi
    release-long.avi
    twinkle-twinkle.mp4
    school-song.mp4
    looking-for-friends.mp4
    kindergarten.mp4
    drop-a-handkerchief.mp4
```

Your task is to inspect the repository, build a complete production-ready academic project website, and continue until the production build succeeds. Do not return only a plan. Implement the site, run the build, fix errors, and leave clear deployment instructions.

---

## 1. Paper identity

Use the following project information exactly:

**Title**

> Strike and Release: Proximity-Guided Transient-Contact Control for Robotic Percussion

**Authors**

> Hongyi Yang and Chenxi Xiao

**Affiliation**

> School of Information Science and Technology, ShanghaiTech University

**One-sentence summary**

> Pre-contact proximity sensing enables a general-purpose robot to reverse its striking motion before sustained contact develops, producing rapid mallet release and clear, repeatable percussion.

The website should present the work as an academic robotics project page, not as a commercial product landing page.

---

## 2. Core scientific story

The page should follow this narrative:

1. A percussion strike is not determined only by whether the mallet reaches the target.
2. Delayed release can keep the mallet on the drum surface and suppress vibration.
3. Fixed joint-position triggering is sensitive to geometry, calibration, and tracking variation.
4. The proposed method observes the instrument surface with a wrist-mounted time-of-flight sensor and triggers retraction before prolonged contact develops.
5. Joint-space impedance control accommodates residual impact uncertainty.
6. Minimum-jerk interpolation creates smooth transitions between ready configurations.
7. Experiments on five multi-note sequences and 1,580 commanded strikes show a large improvement in strike reliability.

Do not invent additional claims beyond the information given in this prompt.

---

## 3. Required technology

If the repository does not already contain a suitable frontend project, initialize a static **Astro + TypeScript** website.

Requirements:

- Static output only; no backend.
- Avoid React unless absolutely necessary.
- Use semantic HTML, modern CSS, and minimal client-side JavaScript.
- Do not use external UI frameworks, analytics, remote fonts, or unnecessary dependencies.
- Keep the project suitable for GitHub Pages deployment.
- Use responsive layouts that work from approximately 320 px mobile width to large desktop screens.
- Ensure all local asset paths work when deployed under a GitHub Pages repository subpath.
- Use `import.meta.env.BASE_URL` or an equivalent helper rather than hard-coding root-relative paths that break under `/repository-name/`.
- Configure Astro for static GitHub Pages deployment and include a GitHub Actions workflow if appropriate.

Suggested structure:

```text
src/
  components/
  layouts/
  pages/
    index.astro
  styles/
public/
  paper.pdf
  images/
  videos/
scripts/
README.md
```

Move or copy the provided assets into the correct public asset directories without renaming them unnecessarily.

---

## 4. Critical AVI handling

The two high-speed recordings are currently AVI files:

```text
webpage/videos/release-short.avi
webpage/videos/release-long.avi
```

Do **not** reference AVI files directly in final HTML because browser playback support is unreliable.

### Required behavior

1. Check whether `ffmpeg` and `ffprobe` are available.
2. Inspect both AVI files before conversion.
3. Convert them to browser-compatible H.264 MP4 files:

```text
public/videos/release-short.mp4
public/videos/release-long.mp4
```

Use a conversion equivalent to:

```bash
ffmpeg -i INPUT.avi \
  -c:v libx264 \
  -preset medium \
  -crf 18 \
  -pix_fmt yuv420p \
  -movflags +faststart \
  -an \
  OUTPUT.mp4
```

Preserve the source timing by default. Do not arbitrarily change the playback speed or frame rate. High-speed camera files may already contain the intended slow-motion timing.

If conversion cannot be completed because `ffmpeg` is unavailable:

- create `scripts/convert-release-videos.sh` containing the conversion commands;
- document the exact command in `README.md`;
- keep the website build successful;
- display the two poster images as graceful fallbacks until MP4 files are generated;
- do not leave broken video elements;
- do not deploy the AVI files as the primary web playback source.

The final generated HTML must reference MP4 files only when those files exist.

---

## 5. Visual direction

Use a restrained academic robotics style:

- light background;
- dark readable typography;
- one muted blue, teal, or blue-gray accent;
- thin borders and subtle section separation;
- limited corner radius;
- no flashy gradients, glassmorphism, excessive animation, or oversized marketing slogans;
- generous whitespace but compact enough to present the scientific content efficiently;
- maximum content width around 1100–1200 px;
- body text should remain comfortably readable.

Use system fonts or a local font stack. Do not fetch Google Fonts.

Motion should be subtle and respect `prefers-reduced-motion`.

---

## 6. Required page sections

Create a single polished long-form project page with a sticky or compact top navigation linking to the major sections.

### A. Header / Hero

Include:

- title;
- authors;
- affiliation;
- one-sentence summary;
- buttons for:
  - `Paper`
  - `Demos`
  - `Method`
  - `BibTeX`
- `Paper` must open the local `paper.pdf` in a new tab;
- display `images/teaser.svg` prominently;
- preserve the SVG aspect ratio and do not crop important labels.

Add four compact headline metrics:

- `1,580` commanded strikes
- `5` multi-note sequences
- `97.34%` strike success rate
- `+23.16 p.p.` absolute improvement

Do not autoplay any audio in the hero section.

### B. Motivation: Strike and Release

Section title:

> A clear strike also needs a timely release.

Brief explanatory copy:

> Earlier command reversal promotes rapid mallet separation and sustained vibration, whereas delayed reversal can prolong mallet–surface contact and damp the acoustic response.

Create a responsive two-column comparison on desktop and a stacked layout on mobile.

#### Earlier reversal card

Use:

- video: `videos/release-short.mp4` after conversion;
- fallback poster: `images/release-short-poster.png`;
- waveform: `images/waveform-short.svg`.

Text labels:

- `Earlier reversal`
- `Shorter contact`
- `Rapid release`
- `Sustained vibration`
- representative contact interval: approximately `50 ms`

#### Later reversal card

Use:

- video: `videos/release-long.mp4` after conversion;
- fallback poster: `images/release-long-poster.png`;
- waveform: `images/waveform-long.svg`.

Text labels:

- `Later reversal`
- `Longer contact`
- `Delayed release`
- `Rapid acoustic decay`
- representative contact interval: approximately `95.2 ms`

Video requirements:

```html
controls
muted
loop
playsinline
preload="metadata"
```

Do not autoplay video with sound. It is acceptable to avoid autoplay entirely.

Clearly state that these contact intervals are representative qualitative examples rather than population-level statistical estimates.

### C. Method overview

Section title:

> Proximity-guided transient-contact control

Display `images/method-overview.svg` as the main method figure.

Below it, present the strike cycle as a clear five-step sequence:

1. `Ready configuration`
2. `Distal-joint approach`
3. `Pre-contact event`
4. `Command reversal`
5. `Impact and rapid release`

Then create three concise method blocks.

#### Two-stage proximity triggering

Include:

- wrist-mounted VL53L5CX time-of-flight sensor;
- 4 × 4 distance measurements at 60 Hz;
- ESP32-C3 edge-side median filtering;
- coarse distance gate on the embedded device;
- note-specific fine threshold on the host computer;
- the event is accepted only during the `APPROACH` state.

#### Compliant execution

Include:

- 1-kHz joint-space impedance controller;
- model-based feedforward compensation;
- proximal joints remain regulated near the ready configuration;
- the distal joint generates the strike;
- command reversal is triggered before sustained contact develops;
- residual momentum completes the impact.

#### Smooth inter-strike motion

Include:

- minimum-jerk interpolation is used only between successive ready configurations;
- approach and retraction retain task-defined distal-joint velocities;
- zero terminal velocity and acceleration provide a repeatable initial condition for the next strike.

Avoid presenting long equations on the webpage. Refer readers to the paper for the formal definition.

### D. Experimental setup

Section title:

> Experimental setup

Use the two provided PNG images:

- `images/robot-platform.png`
- `images/sensor-mallet-assembly.png`

Display them side by side on desktop and stacked on mobile.

Captions:

- `Franka Research 3 percussion platform with a 40-cm steel tongue drum and customized mallet.`
- `Wrist-mounted VL53L5CX proximity sensor and mallet assembly.`

Add compact setup facts:

- Franka Research 3, 7 DoF
- 1-kHz torque control
- VL53L5CX, 4 × 4 at 60 Hz
- ESP32-C3 edge processing
- five songs × five repetitions × two triggering conditions
- 790 commanded strikes per condition

PNG is a valid and intended web format. Do not convert these files merely for consistency.

### E. Quantitative results

Section title:

> Proximity triggering improves strike reliability

Use clearly labeled metric cards and a compact accessible comparison table.

Exact aggregate results:

- Strike success rate: `74.18% → 97.34%`
- Absolute SR improvement: `+23.16 percentage points`
- Valid strike success rate: `76.30% → 98.72%`
- Mean per-run SR: `73.76 ± 7.65% → 97.34 ± 2.85%`
- Minimum-jerk terminal velocity RMS median: `0.1553 → 0.0049 rad/s`
- Median segment-wise reduction: `96.41%`

Song-level results:

| Sequence | Position-trigger SR | Proximity-trigger SR | Improvement |
|---|---:|---:|---:|
| Twinkle Twinkle | 78.10% | 96.67% | +18.57 p.p. |
| School Song | 72.00% | 96.80% | +24.80 p.p. |
| Looking for Friends | 68.57% | 97.86% | +29.29 p.p. |
| Kindergarten | 75.65% | 97.39% | +21.74 p.p. |
| Drop a Handkerchief | 74.50% | 98.00% | +23.50 p.p. |
| Aggregate | 74.18% | 97.34% | +23.16 p.p. |

Use the terminology `position trigger` and `proximity trigger` consistently.

Do not introduce statistical significance tests because none are provided here.

### F. Demo gallery

Section title:

> Five multi-note percussion demos

Use the following videos exactly:

```text
videos/twinkle-twinkle.mp4
videos/school-song.mp4
videos/looking-for-friends.mp4
videos/kindergarten.mp4
videos/drop-a-handkerchief.mp4
```

Create one featured video player and a row or responsive grid of five selectable song buttons/cards. Selecting a song should update the featured player without reloading the page.

Song titles:

1. `Twinkle Twinkle`
2. `School Song`
3. `Looking for Friends`
4. `Kindergarten`
5. `Drop a Handkerchief`

Requirements:

- only one featured video should actively load at a time where practical;
- use `controls`, `playsinline`, and `preload="metadata"`;
- do not autoplay audio;
- provide a visible active-song state;
- ensure keyboard accessibility;
- display a useful message if a video fails to load;
- avoid loading five full video players simultaneously.

### G. Discussion and limitations

Include a concise section explaining:

- reliable percussion requires both impact and timely separation;
- surface-relative triggering is more direct than a fixed joint-angle threshold in the tested setup;
- minimum-jerk planning reduces residual motion before the following strike;
- the method currently uses manually calibrated note-specific thresholds;
- the current experiments focus on short structured sequences;
- expressive intensity control, long-horizon timing, online parameter adaptation, and transfer to additional instruments remain future work.

Do not overstate generalization beyond the reported platform and experiments.

### H. Paper and citation

Add a final paper section with:

- a button to open `paper.pdf`;
- a copyable provisional BibTeX block;
- a working `Copy BibTeX` button;
- an `aria-live` status message after copying.

Use this provisional citation exactly unless an existing repository citation is more authoritative:

```bibtex
@misc{yang2026strike,
  title        = {Strike and Release: Proximity-Guided Transient-Contact Control for Robotic Percussion},
  author       = {Hongyi Yang and Chenxi Xiao},
  year         = {2026},
  note         = {Submitted to the IEEE International Conference on Robotics and Biomimetics (ROBIO)}
}
```

Label it as a provisional citation so it is not mistaken for final publication metadata.

### I. Footer

Include:

- paper title in abbreviated form;
- ShanghaiTech University;
- year 2026;
- a small note that the page uses local media assets and does not require analytics or cookies.

---

## 7. Asset handling requirements

- Use SVG files directly for the teaser, method figure, and waveforms.
- Use PNG files directly for posters and experimental photographs.
- Do not convert PNG to WebP merely for uniformity.
- Add descriptive `alt` text to all images.
- Preserve aspect ratios.
- Use `object-fit: contain` for diagrams and `object-fit: cover` only where cropping is safe for photographic thumbnails.
- Avoid embedding PDF figures inside `<img>` elements.
- The complete paper remains a PDF and should be linked, not rendered as a page-sized iframe.
- Do not rename the five song video files.
- Do not modify the scientific content inside the SVG assets.

---

## 8. Accessibility and usability

Required:

- semantic landmarks and heading hierarchy;
- keyboard-accessible navigation and demo selection;
- visible focus styles;
- sufficient contrast;
- `alt` text for images;
- captions or text descriptions near videos;
- no important information conveyed only by color;
- responsive tables or compact mobile alternatives;
- respect `prefers-reduced-motion`;
- no autoplaying audio;
- no horizontal page overflow at 320 px width.

---

## 9. SEO and metadata

Add:

- page title;
- description;
- author metadata;
- Open Graph title and description;
- local teaser image as the social preview when technically practical;
- favicon generated locally from a simple text or geometric mark if no favicon exists;
- canonical URL support through a clearly documented configuration value;
- structured metadata appropriate for a scholarly article when practical.

Do not fabricate DOI, conference acceptance status, proceedings pages, or repository URLs.

---

## 10. GitHub Pages deployment

Provide a robust GitHub Pages setup.

Requirements:

- production build must be static;
- add `.github/workflows/deploy.yml` if the project does not already have a deployment workflow;
- document the required `site` and `base` values in `astro.config.*`;
- make repository-subpath deployment work;
- document how to change the repository name or use a custom domain;
- ensure local development still works with `npm run dev`;
- ensure `npm run build` succeeds.

Do not hard-code an unknown GitHub username. Use clearly marked placeholders or environment variables.

---

## 11. README requirements

Create or update `README.md` with:

1. project overview;
2. prerequisites;
3. installation;
4. local development;
5. production build;
6. AVI-to-MP4 conversion instructions;
7. asset directory structure;
8. GitHub Pages deployment;
9. how to update the paper, figures, and videos;
10. how to update the provisional BibTeX after publication.

Include the exact video conversion command or reference `scripts/convert-release-videos.sh`.

---

## 12. Quality checks and acceptance criteria

Before finishing:

1. Inspect the entire repository.
2. Install dependencies.
3. Convert the AVI files when possible.
4. Run the local development server long enough to catch obvious runtime errors.
5. Run the production build.
6. Fix all build errors.
7. Check for broken paths and case-sensitive filename mismatches.
8. Verify that GitHub Pages subpath routing does not break assets.
9. Verify that no final `<video>` element references an AVI file.
10. Verify that the page remains useful when the release MP4 conversions are absent.
11. Verify mobile layouts at narrow widths.
12. Ensure no placeholder lorem ipsum, fake links, fake DOI, or invented code repository remains.

The task is complete only when:

- the website is implemented rather than merely described;
- `npm run build` succeeds;
- all provided figures, photos, paper, and five demo videos are integrated;
- the two release AVI files are converted or a robust conversion/fallback workflow is included;
- the final response summarizes the implemented files, the build result, and any one remaining manual deployment variable such as the GitHub repository name.

