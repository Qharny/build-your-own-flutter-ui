#!/usr/bin/env node
// Enforces the contribution rules from CONTRIBUTING.md on incoming PRs:
//   - one link per PR
//   - table row has the right number of columns and a real [title](url) link
//   - the link isn't already listed elsewhere in the file
// Also collects newly-added links into added-links.txt for a follow-up
// reachability check with lychee.

import { execSync } from "node:child_process";
import { readFileSync, writeFileSync } from "node:fs";

const BASE_SHA = process.env.BASE_SHA;
const HEAD_SHA = process.env.HEAD_SHA;

if (!BASE_SHA || !HEAD_SHA) {
  console.error("BASE_SHA and HEAD_SHA env vars must be set.");
  process.exit(1);
}

const TRACKED_FILES = ["README.md", "curated-list/README.md"];

const diff = execSync(
  `git diff --unified=0 ${BASE_SHA} ${HEAD_SHA} -- ${TRACKED_FILES.map((f) => `"${f}"`).join(" ")}`,
  { encoding: "utf8", maxBuffer: 1024 * 1024 * 20 }
);

function isTableRow(s) {
  if (!s.startsWith("|") || !s.endsWith("|")) return false;
  const pipes = (s.match(/\|/g) || []).length;
  return pipes >= 4;
}

function isSeparatorRow(s) {
  const cells = s.slice(1, -1).split("|").map((c) => c.trim());
  return cells.length > 0 && cells.every((c) => /^:?-+:?$/.test(c));
}

const placeholderPattern = /No entries yet/i;

let currentFile = null;
const addedRowsByFile = new Map(TRACKED_FILES.map((f) => [f, []]));
let removedContentLines = 0;

for (const line of diff.split("\n")) {
  const fileMatch = line.match(/^\+\+\+ b\/(.+)$/);
  if (fileMatch) {
    currentFile = fileMatch[1];
    continue;
  }
  if (!currentFile || !TRACKED_FILES.includes(currentFile)) continue;
  if (line.startsWith("+++") || line.startsWith("---")) continue;

  if (line.startsWith("+")) {
    const content = line.slice(1).trim();
    if (isTableRow(content) && !isSeparatorRow(content) && !placeholderPattern.test(content)) {
      addedRowsByFile.get(currentFile).push(content);
    }
  } else if (line.startsWith("-")) {
    const content = line.slice(1).trim();
    if (isTableRow(content) && !isSeparatorRow(content) && !placeholderPattern.test(content)) {
      removedContentLines += 1;
    }
  }
}

const allAddedRows = [...addedRowsByFile.entries()].flatMap(([file, rows]) =>
  rows.map((row) => ({ file, row }))
);

const errors = [];
const warnings = [];
const addedLinks = [];

if (allAddedRows.length > 1) {
  errors.push(
    `Found ${allAddedRows.length} new table rows across ${TRACKED_FILES.join(" and ")}. ` +
      "Please submit **one link per PR** (see CONTRIBUTING.md)."
  );
}

const linkPattern = /\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/;

for (const { file, row } of allAddedRows) {
  const cells = row.slice(1, -1).split("|").map((c) => c.trim());

  if (cells.length !== 4) {
    errors.push(`Row added to \`${file}\` does not have exactly 4 columns:\n\`${row}\``);
  }

  const lastCell = cells[cells.length - 1] ?? "";
  const linkMatch = lastCell.match(linkPattern);
  if (!linkMatch) {
    errors.push(
      `Row added to \`${file}\` is missing a valid \`[Title](https://...)\` link in the last column:\n\`${row}\``
    );
    continue;
  }

  const url = linkMatch[2];
  addedLinks.push(url);

  const fileContent = readFileSync(file, "utf8");
  const occurrences = fileContent.split(url).length - 1;
  if (occurrences > 1) {
    errors.push(
      `The link \`${url}\` added to \`${file}\` already appears elsewhere in the file. ` +
        "Duplicate entries are not allowed (see CONTRIBUTING.md)."
    );
  }
}

if (removedContentLines > 1) {
  warnings.push(
    `This PR removes ${removedContentLines} existing table row(s). Double check that's intentional ` +
      "(e.g. fixing a broken link) and not an accidental deletion."
  );
}

writeFileSync("added-links.txt", addedLinks.length ? addedLinks.join("\n") + "\n" : "");

const summaryLines = ["## PR Contribution Check", ""];
if (errors.length === 0) {
  summaryLines.push("✅ No blocking issues found.");
} else {
  summaryLines.push("❌ **Blocking issues:**", "");
  for (const e of errors) summaryLines.push(`- ${e}`);
}
if (warnings.length > 0) {
  summaryLines.push("", "⚠️ **Warnings:**", "");
  for (const w of warnings) summaryLines.push(`- ${w}`);
}
if (addedLinks.length > 0) {
  summaryLines.push("", "**Links to verify:**", "");
  for (const l of addedLinks) summaryLines.push(`- ${l}`);
}

const summary = summaryLines.join("\n") + "\n";
console.log(summary);
const summaryPath = process.env.GITHUB_STEP_SUMMARY;
if (summaryPath) writeFileSync(summaryPath, summary, { flag: "a" });

if (errors.length > 0) process.exit(1);
