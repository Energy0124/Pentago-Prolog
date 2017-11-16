threatening(board(B,R),CurrentPlayer,ThreatsCount) :- 
    (CurrentPlayer == black -> set_board(R, Board, B, OtherBoard); Board = set_board(B, Board, R, OtherBoard)),
    aggregate_all(count, almost_win(Board, OtherBoard), ThreatsCount).

set_board(A,ABoard, B, Bboard) :- A = ABoard, B = Bboard.

almost_win(Board, OtherBoard):- 
    win(WinCond), intersection(WinCond, Board, I), length(I, Size), Size >= 4,subtract(WinCond, I, Result), 
    intersection(Result, OtherBoard, Miss), length(Miss, MissSize), MissSize == 0.

% almost_win(Board, OtherBoard, Count, FCount):- win(WinCond), intersection(WinCond, Board, I), length(I, Size), Size >= 4,
% subtract(WinCond, I, Result), intersection(Result, OtherBoard, Miss), length(Miss, MissSize), (MissSize == 0 -> succ(Count, FCount); FCount = Count).

%threatening(board([3,4,9,10,21,26,27,33],[5,8,11,15,17,22,29,31]),black,S).
%threatening(board([5,8,11,15,17,22,29,31],[3,4,9,10,21,26,27,33]),black,S).
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
