readWord(InStream,Chars):-
    get_code(InStream,Char),
    checkCharAndReadRest(Char,Chars,InStream).


checkCharAndReadRest(-1,[],_):-  !.
checkCharAndReadRest(end_of_file,[],_):-  !.
checkCharAndReadRest(10,[],_):-  !.
checkCharAndReadRest(Char,[Char|Chars],InStream):-
    get_code(InStream,NextChar),
    checkCharAndReadRest(NextChar,Chars,InStream).


splitAt(_, [], [], []).
splitAt(Index, [E|RestSource], [E|RestA], B) :-
    Index > 0,
    NewIndex is Index - 1,
    splitAt(NewIndex, RestSource, RestA, B).

splitAt(Index, [E|RestSource], A, [E|RestB]) :-
    splitAt(Index, RestSource, A, RestB).


iterateAcc([], [], Acc, Sum) :- Sum is Acc.
iterateAcc([E1|R1], [E2|R2], Acc, Sum) :-
    E1 =:= E2,
    atom_codes(C, [E1]),
    atom_number(C, Number),
    NewAcc is Acc + Number,
    iterateAcc(R1, R2, NewAcc, Sum).

iterateAcc([_|R1], [_|R2], Acc, Sum) :-
    iterateAcc(R1, R2, Acc, Sum).

iterate(Code, RotateValue, Sum) :-
    splitAt(RotateValue, Code, FirstPart, SecondPart),
    append(SecondPart, FirstPart, RotatedCode),
    iterateAcc(Code, RotatedCode, 0, Sum).


run :-
    open('input.txt', read, Str),
    readWord(Str, Code),
    iterate(Code, 1, Z),
    write(Z), nl,
    length(Code, Length),
    RotateValue is Length / 2,
    iterate(Code, RotateValue, X),
    write(X).
