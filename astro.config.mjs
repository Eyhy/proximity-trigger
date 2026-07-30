import { defineConfig } from 'astro/config';

const site = process.env.SITE_URL || 'https://example.github.io';
const base = process.env.BASE_PATH || '/robio-2026/';

export default defineConfig({
  site,
  base,
  output: 'static',
  trailingSlash: 'always'
});
