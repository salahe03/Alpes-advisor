:- encoding(utf8).
:- use_module(library(aggregate)).

threshold(1500).

inside(A, B) :- located_in(A, B).
inside(A, B) :- located_in(A, C), inside(C, B).

adjacent(A, B) :- neighbour(A, B).
adjacent(A, B) :- neighbour(B, A).

resort_massif(R, M) :-
	resort(R),
	located_in(R, C),
	summit(S),
	located_in(S, C),
	in_massif(S, M).

summits_in_department(D, L) :-
	department(D),
	setof(S, (summit(S), inside(S, D)), L).

high_resorts(Threshold, L) :-
	findall(R,
		(resort(R), altitude(R, A), A >= Threshold),
		Resorts),
	sort(Resorts, L).

commune_with_resort(C) :-
	commune(C),
	resort(R),
	located_in(R, C).

commune_without_resort_near_resort(C) :-
	commune(C),
	adjacent(C, Other),
	commune_with_resort(Other),
	\+ commune_with_resort(C).

highest_summit(C, S, A) :-
	aggregate_all(max(Altitude, Summit),
		(summit(Summit), located_in(Summit, C), altitude(Summit, Altitude)),
		max(A, S)).

reaches(A, B, N) :-
	integer(N),
	N >= 0,
	reaches_within(A, B, N).

reaches_within(A, A, _).
reaches_within(A, B, N) :-
	N > 0,
	adjacent(A, C),
	Next is N - 1,
	reaches_within(C, B, Next).

communes_within(A, N, L) :-
	commune(A),
	integer(N),
	N >= 0,
	setof(C, reaches(A, C, N), L).

reachable_naive(A, B) :- adjacent(A, B).
reachable_naive(A, B) :- adjacent(A, C), reachable_naive(C, B).

:- table reachable/2.
reachable(A, B) :- adjacent(A, B).
reachable(A, B) :- adjacent(A, C), reachable(C, B).

snowy(R) :-
	resort(R),
	altitude(R, A),
	threshold(T),
	A >= T.

not_snowy(R) :-
	resort(R),
	\+ snowy(R).

resort_without_altitude(R) :-
	resort(R),
	\+ altitude(R, _).

summit_without_massif(S) :-
	summit(S),
	\+ in_massif(S, _).

two_altitudes(E) :-
	(summit(E); resort(E)),
	altitude(E, A1),
	altitude(E, A2),
	A1 < A2.

asymmetric_neighbour(A, B) :-
	neighbour(A, B),
	\+ neighbour(B, A).

commune_without_department(C) :-
	commune(C),
	\+ (located_in(C, D), department(D)).
