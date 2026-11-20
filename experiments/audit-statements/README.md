# Statement audit check

This check shows that the revised `Audit.lean` accepts the published statements and rejects weakened ones. It compiles the archive's `Statements.lean` (task M175184, SHA-256 `79ef7ca7…47bf`, matching the tracker index) and a stub `Main` whose five theorems are `sorry`. Then it runs the current and revised audits. A second pass uses `Statements.tampered.lean`, which weakens each of the four project definitions as follows.

| Definition | Weakening |
|---|---|
| `RiemannZetaZerosOnLine` | adds `0 < s.im →` |
| `DirichletLNonvanishingRightOfHalf` | replaces `1 / 2 < s.re` with `1 < s.re` |
| `DirichletLZerosOnLine` | adds `N = 1 →` |
| `PrimitiveDirichletLZerosOnLine` | adds `χ = 1 →` |

## Result

Lean 4.33.1 (`819816b2`) and mathlib `0df444a3` came from `./verify.sh … --prepare-only`.

| Statements | Current audit | Revised audit |
|---|---|---|
| Published | statement checks pass; stops at `sorryAx` in `riemannHypothesis` | all five statement checks pass; reports `sorryAx` for all five theorems |
| Weakened | detects 1 of 4 (`RiemannZetaZerosOnLine`) | detects 4 of 4 |

Both audits exit with status 1 on the stub, as they should. The `sorry` stub cannot test the accepting branch of the axiom check. That branch is unchanged apart from its target list. Full transcripts are in [`transcripts/`](transcripts).

## Reproduce

```bash
./verify.sh /path/to/empty-volume --prepare-only
experiments/audit-statements/run.sh /path/to/empty-volume/lean
```

`NewAudit.lean` is byte-identical to the proposed `Audit.lean`. `OldAudit.lean` is `Audit.lean` at `e953be0`.
