% CS F301 Assignment 2 - Group 77
% P2: Form a Valid Arithmetic Equation
%
% Given a list of non-negative integers, place + - * / and exactly one =
% between them (every number used once, in order, optional parentheses)
% so that both sides have the same integer value.

:- use_module(library(lists)).

% split_list(+List, -Left, -Right)
% Left and Right are non-empty lists and Left followed by Right is List.
% On backtracking it gives every such split, shortest Left first. Fails for
% lists with fewer than two elements.
split_list(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).

% expr(+Nums, -Tree, -Value)
% Tree is an expression over the numbers Nums (each used once, in order,
% no digits joined) and Value is its integer value. A tree is num(N) for a
% single number or op(Op, Left, Right) with Op one of + - * /. On
% backtracking it gives every such tree. Fails for [].
expr([N], num(N), N).
expr(Nums, op(Op, Left, Right), Value) :-
    split_list(Nums, LeftNums, RightNums),
    expr(LeftNums, Left, LeftValue),
    expr(RightNums, Right, RightValue),
    member(Op, [+, -, *, /]),
    apply_op(Op, LeftValue, RightValue, Value).

% apply_op(+Op, +X, +Y, -Value)
% Value is X Op Y. For / it only holds when Y is non-zero and divides X
% exactly, so Value is always an integer.
apply_op(+, X, Y, Value) :- Value is X + Y.
apply_op(-, X, Y, Value) :- Value is X - Y.
apply_op(*, X, Y, Value) :- Value is X * Y.
apply_op(/, X, Y, Value) :-
    Y =\= 0,
    X mod Y =:= 0,
    Value is X // Y.
