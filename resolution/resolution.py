#!/usr/bin/env python3
"""Skeleton: propositional resolution prover.

Usage: python resolution/resolution.py extract_10.txt prove "LocatedIn(mont_charvin_q3321741,auvergne_rhone_alpes)" sos
       python resolution/resolution.py extract_10.txt refute "LocatedIn(manigod,savoie)" unit
Modes:      prove X  -> the clause -X is added (refutation)   |   refute X -> the clause X is added
Strategies to implement: naive | sos | unit
A clause is a frozenset of integers (atom i > 0, negative literal = -i). The empty clause is frozenset().
"""
import sys, time


def load(path):
    """PROVIDED: reads the clause file. Returns (list of clauses, dict atom -> integer)."""
    atoms, kb = {}, []
    for line in open(path, encoding="utf-8"):
        if line.startswith("#"):
            continue
        c = set()
        for l in line.split("#")[0].split():
            i = atoms.setdefault(l.lstrip("-"), len(atoms) + 1)
            c.add(-i if l.startswith("-") else i)
        kb.append(frozenset(c))
    return kb, atoms


def resolve(c1, c2):
    """Return the non-tautological resolvents of two clauses."""
    resolvents = []
    for literal in sorted(c1):
        if -literal not in c2:
            continue

        resolvent = frozenset((c1 - {literal}) | (c2 - {-literal}))
        if any(-item in resolvent for item in resolvent):
            continue
        if resolvent not in resolvents:
            resolvents.append(resolvent)

    return resolvents


def prove(kb, goal, strategy, cap=100_000):
    """Try to derive the empty clause using the selected resolution strategy."""
    if strategy not in ("naive", "sos", "unit"):
        raise ValueError("strategy must be 'naive', 'sos', or 'unit'")

    goal_clauses = [goal] if isinstance(goal, frozenset) else list(goal)
    clauses = []
    clause_indices = {}

    def add_clause(clause):
        clause = frozenset(clause)
        if clause not in clause_indices:
            clause_indices[clause] = len(clauses)
            clauses.append(clause)
        return clause_indices[clause]

    for clause in kb:
        add_clause(clause)
    support = [add_clause(clause) for clause in goal_clauses]
    if frozenset() in clause_indices:
        return True, 0
    if cap <= 0:
        return False, 0

    generated = 0

    def use_resolvents(first_index, second_index):
        nonlocal generated
        for resolvent in resolve(clauses[first_index], clauses[second_index]):
            generated += 1
            if not resolvent:
                return True
            if generated >= cap:
                return False
            if resolvent not in clause_indices:
                new_index = add_clause(resolvent)
                if strategy == "sos":
                    support.append(new_index)
        return None

    if strategy == "sos":
        processed_pairs = set()
        support_position = 0
        while support_position < len(support):
            given_index = support[support_position]
            support_position += 1
            for other_index in range(len(clauses)):
                if given_index == other_index:
                    continue
                pair = tuple(sorted((given_index, other_index)))
                if pair in processed_pairs:
                    continue
                processed_pairs.add(pair)
                result = use_resolvents(given_index, other_index)
                if result is True:
                    return True, generated
                if generated >= cap:
                    return False, generated
    else:
        given_index = 0
        while given_index < len(clauses):
            for other_index in range(given_index):
                if strategy == "unit" and len(clauses[given_index]) != 1 and len(clauses[other_index]) != 1:
                    continue
                result = use_resolvents(given_index, other_index)
                if result is True:
                    return True, generated
                if generated >= cap:
                    return False, generated
            given_index += 1

    return False, generated


if __name__ == "__main__":
    file, mode, atom, strat = sys.argv[1:5]
    kb, atoms = load(file)
    if (atom not in atoms) :
        sys.exit(f"The goal {atom} is not an atom of the provided KB")
    i = atoms[atom]
    goal = [frozenset([-i if mode == "prove" else i])]
    t0 = time.time()
    found, gen = prove(kb, goal, strat)
    print(f"{strat}: {'empty clause' if found else 'no contradiction'} | resolvents generated: {gen} | {time.time()-t0:.2f}s")
