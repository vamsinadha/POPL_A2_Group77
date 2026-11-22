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

% op_prec(?Op, ?Prec)
% Prec is the precedence of operator Op: * and / bind tighter than + and -.
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% tree_prec(+Tree, -Prec)
% Prec is the precedence of the top of Tree. A number gets 3, higher than
% any operator, so it is never put in parentheses.
tree_prec(num(_), 3).
tree_prec(op(Op, _, _), Prec) :-
    op_prec(Op, Prec).

% tree_string(+Tree, -String)
% String is the canonical text of Tree with no spaces. A left operand is
% wrapped in parentheses only if its precedence is lower than its
% parent's; a right operand is wrapped if its precedence is the same or
% lower (operators are left-associative). Numbers are never wrapped.
tree_string(num(N), String) :-
    number_string(N, String).
tree_string(op(Op, Left, Right), String) :-
    op_prec(Op, Prec),
    tree_string(Left, LeftText),
    tree_string(Right, RightText),
    tree_prec(Left, LeftPrec),
    tree_prec(Right, RightPrec),
    (   LeftPrec < Prec
    ->  wrap_parens(LeftText, LeftOut)
    ;   LeftOut = LeftText
    ),
    (   RightPrec =< Prec
    ->  wrap_parens(RightText, RightOut)
    ;   RightOut = RightText
    ),
    format(string(String), "~w~w~w", [LeftOut, Op, RightOut]).

% wrap_parens(+Text, -Wrapped)
% Wrapped is the string Text with ( in front and ) after it.
wrap_parens(Text, Wrapped) :-
    format(string(Wrapped), "(~w)", [Text]).

% generate_equation(+List, -Equation)
% Equation is a string "L=R" with no spaces, where L is an expression over
% a non-empty front part of List, R is an expression over the rest, and
% both sides have the same integer value. On backtracking it gives every
% valid equation. Fails if there is none, including for lists of length
% 0 or 1 (split_list/3 has no split for them).
generate_equation(List, Equation) :-
    split_list(List, LeftNums, RightNums),
    expr(LeftNums, LeftTree, LeftValue),
    expr(RightNums, RightTree, RightValue),
    LeftValue =:= RightValue,
    tree_string(LeftTree, LeftText),
    tree_string(RightTree, RightText),
    format(string(Equation), "~w=~w", [LeftText, RightText]).
