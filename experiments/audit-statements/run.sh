#!/usr/bin/env bash
# Usage: run.sh <prepared replay lean dir>
# Compiles the archive's Statements.lean (genuine and a weakened copy) plus a stub Main whose five
# theorems are `sorry`, against the pinned Lean and Mathlib, then runs the old and new Audit.lean.
set -u
here="$(cd "$(dirname "$0")" && pwd -P)"; lean_dir="$1"; tc="$(cat "$lean_dir/lean-toolchain")"
export ELAN_HOME="$(dirname "$lean_dir")/elan" XDG_CACHE_HOME="$(dirname "$lean_dir")/cache"
lean_bin="$(ls -d "$ELAN_HOME"/toolchains/*v4.33.1*/bin/lean)"; echo "lean binary: ${lean_bin#$HOME/}"
mathlib_path="$(cd "$lean_dir" && elan run "$tc" lake env printenv LEAN_PATH)"
"$lean_bin" --version
git -C "$lean_dir/.lake/packages/mathlib" rev-parse HEAD
for variant in genuine tampered; do
  out="$here/build-$variant"; rm -rf "$out"; mkdir -p "$out"
  cp "$here/Statements.$variant.lean" "$out/Statements.lean"; cp "$here/Main.stub.lean" "$out/Main.lean"
  export LEAN_PATH="$out:$mathlib_path"
  "$lean_bin" --root="$out" -o "$out/Statements.olean" "$out/Statements.lean" || { echo STATEMENTS_FAILED; exit 1; }
  echo "stub sorry warnings: $("$lean_bin" --root="$out" -o "$out/Main.olean" "$out/Main.lean" 2>&1 | grep -c 'declaration uses')"
  for audit in OldAudit NewAudit; do
    echo "=== $variant statements / $audit ==="
    "$lean_bin" --root="$here" "$here/$audit.lean" > "$out/$audit.out" 2>&1; echo "exit $?"
    grep -E ': error' "$out/$audit.out" | sed "s|$here/||"
  done
done
