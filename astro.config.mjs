import { defineConfig } from 'astro/config';

const site = process.env.SITE_URL || 'https://eyhy.github.io';
const base = process.env.BASE_PATH || '/proximity-trigger/';

export default defineConfig({
  site,
  base,
  output: 'static',
  trailingSlash: 'always'
});
