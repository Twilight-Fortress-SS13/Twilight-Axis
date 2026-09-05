import Juke from "../juke/index.js";
import { mkdirSync } from "node:fs";
 
export function bun_statpanel(...args: any[]): Promise<Juke.ExecReturn> {
  mkdirSync("ta_statpanel/node_modules/", { recursive: true });
 
  return Juke.exec("bun", [...args.filter((arg) => typeof arg === "string")], {
    cwd: "ta_statpanel",
    shell: true,
  });
}

export const StatBrowserBunTarget = new Juke.Target({
  name: "TA StatPanel Bun Install",
  inputs: ["ta_statpanel/package.json"],
  executes: () => bun_statpanel("install", "--frozen-lockfile", "--ignore-scripts"),
});
 
export const StatBrowserTarget = new Juke.Target({
  name: "TA StatPanel",
  dependsOn: [StatBrowserBunTarget],
  inputs: [
    "ta_statpanel/**/*.+(js|jsx|ts|tsx)",
    "ta_statpanel/ta_statpanel/*.css",
    "ta_statpanel/package.json",
  ],
  outputs: ["ta_statpanel/dist/ta-statbrowser-bundle.html"],
  executes: () => bun_statpanel("run", "build"),
});
 