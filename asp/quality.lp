% Detection of inconsistencies: inconsistency(two_altitudes,S), inconsistency(commune_without_department,C),
% inconsistency(asymmetric_neighbour,A,B), inconsistency(summit_without_massif,S).

inconsistency(two_altitudes, S) :-
	summit(S),
	altitude(S, A1),
	altitude(S, A2),
	A1 < A2.
inconsistency(two_altitudes, R) :-
	resort(R),
	altitude(R, A1),
	altitude(R, A2),
	A1 < A2.

commune_has_department(C) :-
	commune(C),
	department(D),
	located_in(C, D).
inconsistency(commune_without_department, C) :-
	commune(C),
	not commune_has_department(C).

inconsistency(asymmetric_neighbour, A, B) :-
	neighbour(A, B),
	not neighbour(B, A).

summit_has_massif(S) :-
	summit(S),
	in_massif(S, M).
inconsistency(summit_without_massif, S) :-
	summit(S),
	not summit_has_massif(S).

#show inconsistency/2.
#show inconsistency/3.
