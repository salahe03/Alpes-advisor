resort_massif(R, M) :-
	resort(R),
	located_in(R, C),
	commune(C),
	summit(S),
	located_in(S, C),
	in_massif(S, M).

has_summit_altitude(C) :-
	commune(C),
	summit(S),
	located_in(S, C),
	altitude(S, _).

highest_summit_altitude(C, A) :-
	has_summit_altitude(C),
	A = #max { H : summit(S), located_in(S, C), altitude(S, H) }.

k { stay(R) : resort(R) } k.

1 { step(R, M) : resort_massif(R, M) } 1 :- stay(R).

:- step(R1, M), step(R2, M), R1 != R2.
:- stay(R1), stay(R2), R1 != R2,
   located_in(R1, C), located_in(R2, C), commune(C).

#maximize { A, R : stay(R), located_in(R, C),
					 highest_summit_altitude(C, A) }.

#project stay/1.
#show stay/1.
