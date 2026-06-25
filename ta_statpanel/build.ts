import { build } from "bun";
import { mkdirSync, writeFileSync } from "fs";
import { transform } from "lightningcss";

const result = await build({
  entrypoints: ["ta_statpanel/index.jsx"],
  format: "iife",
  target: "browser",
  minify: true,

  jsx: "automatic",
  jsxImportSource: "preact",
});

const js = await result.outputs[0].text();
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
