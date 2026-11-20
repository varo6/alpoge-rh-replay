import Main
import Lean.Util.CollectAxioms

/-! Each public theorem in `Main` is checked against its statement written out with
Mathlib definitions alone, so a change to `Statements.lean` cannot weaken a result
unnoticed. -/

example : _root_.RiemannHypothesis := _root_.riemannHypothesis

example (s : ℂ) (hz : _root_.riemannZeta s = 0)
    (hnt : ¬ ∃ n : ℕ, s = -2 * ((n : ℂ) + 1)) (hp : s ≠ 1) :
    s.re = 1 / 2 :=
  _root_.riemannHypothesis s hz hnt hp

example (s : ℂ) (hz : _root_.riemannZeta s = 0)
    (hnt : ¬ ∃ n : ℕ, s = -2 * ((n : ℂ) + 1)) (hp : s ≠ 1) :
    s.re = 1 / 2 :=
  _root_.riemannZeta_eq_zero_re s hz hnt hp

example (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ)
    (hs : 1 / 2 < s.re) (hχ : χ ≠ 1 ∨ s ≠ 1) :
    DirichletCharacter.LFunction χ s ≠ 0 :=
  _root_.LFunction_ne_zero_of_half_lt_re N χ s hs hχ

example (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ)
    (hs₀ : 0 < s.re) (hs₁ : s.re < 1) (hz : DirichletCharacter.LFunction χ s = 0) :
    s.re = 1 / 2 :=
  _root_.LFunction_eq_zero_re N χ s hs₀ hs₁ hz

example (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ.IsPrimitive) (s : ℂ)
    (hs₀ : 0 < s.re) (hs₁ : s.re < 1) (hz : DirichletCharacter.LFunction χ s = 0) :
    s.re = 1 / 2 :=
  _root_.LFunction_eq_zero_re_of_isPrimitive N χ hχ s hs₀ hs₁ hz

#print RiemannHypothesis
#print RiemannZetaZerosOnLine
#print DirichletLNonvanishingRightOfHalf
#print DirichletLZerosOnLine
#print PrimitiveDirichletLZerosOnLine
#check riemannHypothesis
#check riemannZeta_eq_zero_re
#check LFunction_ne_zero_of_half_lt_re
#check LFunction_eq_zero_re
#check LFunction_eq_zero_re_of_isPrimitive
#print axioms riemannHypothesis
#print axioms riemannZeta_eq_zero_re
#print axioms LFunction_ne_zero_of_half_lt_re
#print axioms LFunction_eq_zero_re
#print axioms LFunction_eq_zero_re_of_isPrimitive

open Lean in
run_cmd do
  let allowed : Array Name := #[`propext, `Classical.choice, `Quot.sound]
  for target in #[`riemannHypothesis, `riemannZeta_eq_zero_re,
      `LFunction_ne_zero_of_half_lt_re, `LFunction_eq_zero_re,
      `LFunction_eq_zero_re_of_isPrimitive] do
    let actual ← collectAxioms target
    for ax in actual do
      unless allowed.contains ax do
        logError m!"Unexpected axiom {ax} in {target}"
