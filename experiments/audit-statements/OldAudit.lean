import Main
import Lean.Util.CollectAxioms

example : _root_.RiemannHypothesis := _root_.riemannHypothesis

example (s : ℂ) (hz : _root_.riemannZeta s = 0)
    (hnt : ¬ ∃ n : ℕ, s = -2 * ((n : ℂ) + 1)) (hp : s ≠ 1) :
    s.re = 1 / 2 :=
  _root_.riemannZeta_eq_zero_re s hz hnt hp

#print RiemannHypothesis
#check riemannHypothesis
#print axioms riemannHypothesis
#print axioms riemannZeta_eq_zero_re
#print axioms LFunction_eq_zero_re

open Lean in
run_cmd do
  let allowed : Array Name := #[`propext, `Classical.choice, `Quot.sound]
  for target in #[`riemannHypothesis, `riemannZeta_eq_zero_re, `LFunction_eq_zero_re] do
    let actual ← collectAxioms target
    for ax in actual do
      unless allowed.contains ax do
        throwError "Unexpected axiom {ax} in {target}"
