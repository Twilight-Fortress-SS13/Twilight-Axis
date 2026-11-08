import { build } from "bun";
import { mkdirSync, writeFileSync } from "fs";
import { transform } from "lightningcss";

const result = await build({
  entrypoints: ["ta_statpanel/index.jsx"],
  format: "iife",
  target: "browser",
  minify: true,

  jsx: {
    runtime: "automatic",
    importSource: "preact",
  },
});

if (!result.success) {
  for (const log of result.logs) {
    console.error(log);
  }
  process.exit(1);
}

const output = result.outputs[0];
if (!output) {
  throw new Error("TA StatPanel build produced no JavaScript output.");
}

const js = await output.text();
const css = await Bun.file("ta_statpanel/main.css").text();

const minifiedCss = transform({
    filename: "style.css",
    code: Buffer.from(css),
    minify: true,
}).code.toString();

const html = `
  <style>
${minifiedCss}
  </style>
  <div id="app"></div>
  <script>
${js}
  </script>
`;

mkdirSync("dist", { recursive: true });

writeFileSync("dist/ta-statbrowser-bundle.html", html);

console.log("built -> dist/ta-statbrowser-bundle.html");
