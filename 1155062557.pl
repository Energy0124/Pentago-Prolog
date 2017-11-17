%testcase:
%threatening(board([3,4,9,10,21,26,27,33],[5,8,11,15,17,22,29,31]),black,S).
%threatening(board([5,8,11,15,17,22,29,31],[3,4,9,10,21,26,27,33]),black,S).
%threatening(board([2,4,10,16,21,26,27],[5,8,12,15,24,29]),red, S).

%winning row
win([1,7,13,19,25]).
win([5,11,17,23,29]).
win([8,9,10,11,12]).
win([13,14,15,16,17]).
win([1,2,3,4,5]).
win([5,10,15,20,25]).
win([8,15,22,29,36]).
win([14,15,16,17,18]).
win([1,8,15,22,29]).
win([6,12,18,24,30]).
win([9,15,21,27,33]).
win([19,20,21,22,23]).
win([2,8,14,20,26]).
win([6,11,16,21,26]).
win([10,16,22,28,34]).
win([20,21,22,23,24]).
win([2,3,4,5,6]).
win([7,13,19,25,31]).
win([11,17,23,29,35]).
win([25,26,27,28,29]).
win([2,9,16,23,30]).
win([7,8,9,10,11]).
win([11,16,21,26,31]).
win([26,27,28,29,30]).
win([3,9,15,21,27]).
win([7,14,21,28,35]).
win([12,18,24,30,36]).
win([31,32,33,34,35]).
win([4,10,16,22,28]).
win([8,14,20,26,32]).
win([12,17,22,27,32]).
win([32,33,34,35,36]).

% start threatening

threatening(board(B,R),CurrentPlayer,ThreatsCount) :- 
    (CurrentPlayer == black -> set_board(R, Board, B, OtherBoard); set_board(B, Board, R, OtherBoard)),
    aggregate_all(count, almost_win(Board, OtherBoard), ThreatsCount).

set_board(A, BoardA, B, BoardB) :- A = BoardA, B = BoardB.

almost_win(Board, OtherBoard):- 
    win(WinCond), intersection(WinCond, Board, I), length(I, Size), Size = 4,subtract(WinCond, I, Result), 
    intersection(Result, OtherBoard, Miss), length(Miss, MissSize), MissSize == 0.

% done threatening lol

%start pentago_ai

%testcase
%pentago_ai(board([2,4,10,16,21,26,27],[5,8,12,15,24,29]),black,BestMove,NextBoard).

pentago_ai(board(B,R),CurrentPlayer, BestMove,NextBoard) :-  
    (CurrentPlayer == black -> set_board(B, Board, R, OtherBoard); set_board(R, Board, B, OtherBoard)),
   can_win(Board, OtherBoard, M, MyNextBoard, OtherNextBoard), 
   BestMove = move(M, clockwise, top-right), NextBoard = board( MyNextBoard, OtherNextBoard).

can_win(Board, OtherBoard, M, MyNextBoard, OtherNextBoard):- 
    win(WinCond), intersection(WinCond, Board, I), length(I, Size), Size = 4,subtract(WinCond, I, Move), 
    intersection(Move, OtherBoard, Miss), length(Miss, MissSize),  MissSize == 0, [M] = Move, 
    append(Board, Move, Z), sort(Z, MyNextBoard), OtherNextBoard = OtherBoard, !.

can_win(OldBoard, OldOtherBoard, M, MyNextBoard, OtherNextBoard):- 
    rotate(clockwise, top-right, OldBoard, Board), rotate(clockwise, top-right, OldOtherBoard, OtherBoard), 
    win(WinCond), intersection(WinCond, Board, I), length(I, Size), Size = 4,subtract(WinCond, I, Move), 
    intersection(Move, OtherBoard, Miss), length(Miss, MissSize),  MissSize == 0, [M] = Move, 
    append(Board, Move, Z), sort(Z, MyNextBoard), OtherNextBoard = OtherBoard, !.

replace(_, _, [], []).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- dif(H,O), replace(O, R, T, T2).

rotateA(clockwise, top-left, List, NewList):- 
    replace(1,a3,List, List2),
    replace(2,a9,List2, List3),
    replace(3,a15,List3, List4),
    replace(7,a2,List4, List5),
    replace(9,a14,List5, List6),
    replace(13,a1,List6, List7),
    replace(14,a7,List7, List8),
    replace(15,a13,List8, NewList),
    !.

rotateA(clockwise, top-right, List, NewList):- 
    replace(18,a16,List, List2),
    replace(17,a10,List2, List3),
    replace(16,a4,List3, List4),
    replace(12,a17,List4, List5),
    replace(10,a5,List5, List6),
    replace(6,a18,List6, List7),
    replace(5,a12,List7, List8),
    replace(4,a6,List8, NewList),
    !.

rotateA(clockwise, bottom-left, List, NewList):- 
    replace(33,a31,List, List2),
    replace(32,a25,List2, List3),
    replace(31,a19,List3, List4),
    replace(27,a32,List4, List5),
    replace(25,a20,List5, List6),
    replace(21,a33,List6, List7),
    replace(20,a27,List7, List8),
    replace(19,a21,List8, NewList),
    !.

rotateA(clockwise, bottom-right, List, NewList):- 
    replace(36,a34,List, List2),
    replace(35,a28,List2, List3),
    replace(34,a22,List3, List4),
    replace(30,a35,List4, List5),
    replace(28,a23,List5, List6),
    replace(24,a36,List6, List7),
    replace(23,a30,List7, List8),
    replace(22,a24,List8, NewList),
    !.

rotate(clockwise, Direction, List, SortedNewList):- 
    rotateA(clockwise, Direction, List, AList), replaceA(AList, NewList), sort(NewList, SortedNewList).

replaceA([], []).
replaceA([O|T], [RA|T2]) :- atom_concat(a, R, O),  atom_number(R, RA), replaceA( T, T2), !.
replaceA([H|T], [H|T2]) :- replaceA(T, T2).


% replace_first(X,Y,Xs,Ys) :-
%     same_length(Xs,Ys),
%     append(Prefix,[X|Suffix],Xs),
%     maplist(dif(X),Prefix),
%     append(Prefix,[Y|Suffix],Ys).

% rep1(X, Y, [Z|T]) --> [Z], { dif(Z, X) }, rep1(X, Y, T).
% rep1(X, Y, [Y|T]) --> [X], rest(T).
% rep1(_, _, []) --> [].

% rest([]) --> [].
% rest([H|T]) --> [H], rest(T).

% replace_first(X, Y, L, R) :- phrase(rep1(X, Y, R), L).

% rotate(clockwise, top-left, List, SortedNewList):- 
%     replace_first(3,15,List, List2),
%     replace_first(9,14,List2, List3),
%     replace_first(15,13,List3, List4),
%     replace_first(2,9,List4, List5),
%     replace_first(14,7,List5, List6),
%     replace_first(1,3,List6, List7),
%     replace_first(7,2,List7, List8),
%     replace_first(13,1,List8, NewList),
%     sort(NewList, SortedNewList),
%     !.


% rotate(clockwise, top-right, List, SortedNewList):- 
%     replace_first(18,16,List, List2),
%     replace_first(17,10,List2, List3),
%     replace_first(16,4,List3, List4),
%     replace_first(12,17,List4, List5),
%     replace_first(10,5,List5, List6),
%     replace_first(6,18,List6, List7),
%     replace_first(5,12,List7, List8),
%     replace_first(4,6,List8, NewList),
%     sort(NewList, SortedNewList),
%     !.

% rotate(clockwise, bottom-left, List, SortedNewList):- 
%     replace_first(33,31,List, List2),
%     replace_first(32,25,List2, List3),
%     replace_first(31,19,List3, List4),
%     replace_first(27,32,List4, List5),
%     replace_first(25,20,List5, List6),
%     replace_first(21,33,List6, List7),
%     replace_first(20,27,List7, List8),
%     replace_first(19,21,List8, NewList),
%     sort(NewList, SortedNewList),
%     !.

% rotate(clockwise, bottom-right, List, SortedNewList):- 
%     replace_first(36,34,List, List2),
%     replace_first(35,28,List2, List3),
%     replace_first(34,22,List3, List4),
%     replace_first(30,35,List4, List5),
%     replace_first(28,23,List5, List6),
%     replace_first(24,36,List6, List7),
%     replace_first(23,30,List7, List8),
%     replace_first(22,24,List8, NewList),
%     sort(NewList, SortedNewList),
%     !.
