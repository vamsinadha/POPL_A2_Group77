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
