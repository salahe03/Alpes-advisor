# Alpes Advisor - Quiz Sheet

Instance: small. Predicates below use the assignment's names.

## Part 1 - FOL

Q1.1: true: (c), E3, E4. False: (a), (b), (d), E1, E2.
Q1.2: E2 fails for massif_du_faucigny: its listed summit plateau_des_saix has altitude 1,639 m.

## Part 2 - Resolution

Q2.1: E2 clauses: `not Massif(m) or Summit(f(m))`; `not Massif(m) or InMassif(f(m),m)`;
`not Massif(m) or High2400(f(m))`. Axiom (c): `not Commune(c) or not Department(d1) or`
`not Department(d2) or not LocatedIn(c,d1) or not LocatedIn(c,d2) or d1=d2`.
Q2.2: `Neighbour`: MGU `{z/a, x/h(a)}`. `LocatedIn`: no unifier (`y=g(y)`, occurs check).

Q2.3 Resolvents generated; `cap=100,000` (C means cap reached, no proof found):

| n | Goal | Naive | SOS | Unit |
|---|---|---:|---:|---:|
| 10 | provable | C | 25,199 | 354 |
| 10 | false, uniqueness | C | 386 | 226 |
| 10 | not provable | C | C | 842 |
| 12 | provable | C | 56,005 | 470 |
| 12 | false, uniqueness | C | 602 | 322 |
| 12 | not provable | C | C | 1,298 |
| 14 | provable | C | C | 602 |
| 14 | false, uniqueness | C | 865 | 433 |
| 14 | not provable | C | C | 1,818 |

Q2.4: Unit is best here, especially on provable and uniqueness-refuted goals. For the
unprovable goal there is no empty clause; search saturates or reaches the cap.
Q2.5: `clauses = F + n(n-1)(n-2) + C*D(D-1)/2`. Counts at n=10/12/14: 736/1,338/2,204.
Small: 28 entities give about 19,696 clauses; the provided extractor selects 22 and emits 9,276.
Medium: 501 entities imply about 125 million clauses. Cubic growth makes full propositional
resolution impractical.

## Part 3 - Prolog (small)

Q3.1: `summits_in_department(savoie)` = aiguille_croche, chard_du_beurre,
montagne_d_outray, tete_de_la_cicle. Haute-Savoie = aiguille_croche, arete_de_tricot,
montagne_d_anterne, tete_de_la_cicle. `high_resorts(1500)` = Flaine, Les Saisies;
`high_resorts(2000)` = [].
Q3.2: `findall` = 32; `setof` = 8 unique communes; `aggregate_all(count,...)` = 32.
`setof` fails on no solutions. Hauteluce's highest known summit is Tete de la Cicle, 2,552 m;
`aggregate_all(max(Altitude,Summit),...)` fails if no known altitude exists.
Q3.3: From Combloux, at most 1/2/3 steps: 6/12/12 communes. Naive reachability loops
on graph cycles; tabling memoizes answers, and `reaches/3` is bounded.
Q3.4: `not_snowy` = 3 (domaine_de_praz_sur_arly, plaine_joux, saint_nicolas_de_veroce);
no resort altitude = 2 (domaine_de_praz_sur_arly, saint_nicolas_de_veroce).
Adding an altitude can change `not_snowy` based on its value; NAF treats lack of proof as false.
Q3.5/Q3.6: two altitudes: aiguille_croche; asymmetric: combloux -> sallanches;
no department: les_houches; no summit without massif: []. These match Q1.1.
The last result means "not known to have a massif" under NAF, not explicit proof of none.

## Part 4 - ASP (small unless noted)

Q4.1: k=2: value 5,773; 1 stay: les_saisies + saint_nicolas_de_veroce.
k=3: value 7,773; 2 stays: les_saisies + plaine_joux + saint_nicolas_de_veroce;
flaine + les_saisies + saint_nicolas_de_veroce.
Q4.2: clingo prints -5,773 / -7,773 because maximize objectives are shown as negative costs.
Q4.3/Q4.4: medium k=3: without distinct communes, 15 optimal stays (was 5); with it,
5 optimal stays in 0.044 s. Propositional resolution at 501 entities needs about 125M clauses.
Q4.5: Brave snowy: flaine, les_saisies, domaine_de_praz_sur_arly, saint_nicolas_de_veroce.
Cautious: flaine, les_saisies. With `exception(flaine)`, remove flaine from both.
Choice models represent possible snow for unknown altitude; it is not certain.
Q4.6: same as Prolog: aiguille_croche has two altitudes; les_houches has no department;
combloux -> sallanches is asymmetric; no summit_without_massif atoms.

## Formalism Comparison

| | Resolution | Prolog | ASP |
|---|---|---|---|
| Expressiveness | Ground propositional clauses | Variables, rules, recursion | Rules, choices, optimization |
| Missing data | Absence is not negation | NAF uses closed-world assumption | Choices model possible vs certain |
| Termination | Finite saturation; can explode | Recursion may loop; tables/bounds help | Finite grounding and solving |
| Explainability | Resolution proof trace | Rule/query trace | Answer sets and constraints |

## First-Order Axioms

T: `L(x,y) and L(y,z) -> L(x,z)`; symmetric: `N(x,y) -> N(y,x)`;
unique department: commune in d1,d2 implies d1=d2; summit -> some containing commune.
E1: each commune in a department. E2: each massif has a summit >2400 m.
E3: resort-free commune neighbors a commune with a resort. E4: every resort's commune
has a department. I: `not L(x,x)`. S: every entity has a `LocatedIn` successor.
