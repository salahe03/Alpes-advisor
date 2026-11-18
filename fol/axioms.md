# Part 1: first-order logic

Use `High2400(x)` for “x is higher than 2,400 m”. `LocatedIn(x, y)` means that
entity `x` is located in entity `y`.

## 1. Axioms
- (a) Transitivity of `LocatedIn`:

  $$\forall x\forall y\forall z\; ((LocatedIn(x,y) \land LocatedIn(y,z)) \rightarrow LocatedIn(x,z)).$$

- (b) Symmetry of `Neighbour`:

  $$\forall x\forall y\; (Neighbour(x,y) \rightarrow Neighbour(y,x)).$$

- (c) A commune lies in at most one department:

  $$\forall c\forall d_1\forall d_2\; ((Commune(c) \land Department(d_1) \land Department(d_2) \land LocatedIn(c,d_1) \land LocatedIn(c,d_2)) \rightarrow d_1=d_2).$$

- (d) Every summit lies in at least one commune:

  $$\forall s\; (Summit(s) \rightarrow \exists c\; (Commune(c) \land LocatedIn(s,c))).$$

## 2. Formalisations
- (E1) Every commune lies in a department:

  $$\forall c\; (Commune(c) \rightarrow \exists d\; (Department(d) \land LocatedIn(c,d))).$$

- (E2) Every massif contains at least one summit higher than 2,400 m:

  $$\forall m\; (Massif(m) \rightarrow \exists s\; (Summit(s) \land InMassif(s,m) \land High2400(s))).$$

- (E3) There is a commune without a resort that is a neighbour of a commune with a resort:

  $$
  \begin{aligned}
  \exists c_1\exists c_2\; (&Commune(c_1) \land Commune(c_2) \land Neighbour(c_1,c_2)\\
  &\land\; \neg\exists r_1\; (Resort(r_1) \land LocatedIn(r_1,c_1))\\
  &\land\; \exists r_2\; (Resort(r_2) \land LocatedIn(r_2,c_2))).
  \end{aligned}
  $$

- (E4) No resort lies in a commune without a department:

  $$
  \begin{aligned}
  \forall r\forall c\; (&(Resort(r) \land Commune(c) \land LocatedIn(r,c)) \rightarrow\\
  &\exists d\; (Department(d) \land LocatedIn(c,d))).
  \end{aligned}
  $$

## 3. Models of {transitivity, I, S}
- (I) Irreflexivity:

  $$\forall x\; \neg LocatedIn(x,x).$$

- (S) Every entity has a `LocatedIn` successor:

  $$\forall x\; \exists y\; LocatedIn(x,y).$$

Assume the usual non-empty domain. To show every model is infinite, start with
any entity `a0`. By (S), choose
`a1` such that `LocatedIn(a0, a1)`, then choose `a2` such that
`LocatedIn(a1, a2)`, and continue. By transitivity, `LocatedIn(ai, aj)` for
every `i < j`. If the domain were finite, two terms in this sequence would be
equal: `ai = aj` for some `i < j`. This gives `LocatedIn(ai, ai)`, contradicting
(I). Therefore the domain is infinite.

An infinite model has domain the natural numbers and interprets
`LocatedIn(x, y)` as `x < y`. This relation is transitive and irreflexive, and
for every natural number `x`, `LocatedIn(x, x + 1)` holds. The other predicates
can be interpreted as empty relations.

The instance does not satisfy (S). For example, a massif has no outgoing
`located_in` fact: massifs are linked to summits by `in_massif/2`, not by
`located_in/2`.
