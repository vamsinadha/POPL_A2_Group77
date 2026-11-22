% Tests for P2 (code/77_q2.pl)
% Run from the repository root:
%   swipl -q -f tests/test_q2.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- ensure_loaded('../code/77_q2').

% Examples from the assignment.
:- begin_tests(spec_examples).

test(all_4253, [true(Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                             "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"])]) :-
    all_equations([4,2,5,3], Es).

test(count_4253, [true(N == 7)]) :-
    count_equations([4,2,5,3], N).

test(generate_4253_is_one_of_the_seven, [nondet]) :-
    generate_equation([4,2,5,3], E),
    all_equations([4,2,5,3], Es),
    memberchk(E, Es).

test(generate_234_fails, [fail]) :-
    generate_equation([2,3,4], _).

test(all_234_empty, [true(Es == [])]) :-
    all_equations([2,3,4], Es).

test(all_248, [true(Es == ["2*4=8"])]) :-
    all_equations([2,4,8], Es).

:- end_tests(spec_examples).

% Lists that are too short, and lists of zeros.
:- begin_tests(edge_cases).

test(generate_empty_fails, [fail]) :-
    generate_equation([], _).

test(all_empty, [true(Es == [])]) :-
    all_equations([], Es).

test(count_empty, [true(N == 0)]) :-
    count_equations([], N).

test(generate_single_fails, [fail]) :-
    generate_equation([5], _).

test(all_single, [true(Es == [])]) :-
    all_equations([5], Es).

test(count_single, [true(N == 0)]) :-
    count_equations([5], N).

test(all_zeros, [true(Es == ["0=0"])]) :-
    all_equations([0,0], Es).

test(equal_pair, [true(Es == ["7=7"])]) :-
    all_equations([7,7], Es).

:- end_tests(edge_cases).

% Division is allowed only when the divisor is non-zero and it is exact,
% at every node of the tree.
:- begin_tests(division).

% 3/0 is rejected, and no other operator makes 3 equal to 0.
test(divide_by_literal_zero, [true(Es == [])]) :-
    all_equations([3,0], Es).

% No equation anywhere divides by a literal 0.
test(no_slash_zero_in_results) :-
    all_equations([4,0,2,2], Es),
    forall(member(E, Es), \+ sub_string(E, _, _, _, "/0")).

% Dividing by a sub-expression whose value is 0 is rejected too.
test(divide_by_computed_zero, [fail]) :-
    expr([6,2,2], op(/, num(6), op(-, num(2), num(2))), _).

% 7/2 is not exact, so it is rejected.
test(inexact_top_level, [true(Es == [])]) :-
    all_equations([7,2], Es).

test(inexact_tree_rejected, [fail]) :-
    expr([7,2], op(/, num(7), num(2)), _).

% 1/2*4 would be 2 with real numbers, but 1/2 is not exact, so this
% equation must not appear.
test(inexact_inner_division) :-
    all_equations([1,2,4,2], Es),
    \+ memberchk("1/2*4=2", Es).

test(exact_division_allowed) :-
    all_equations([8,4,2], Es),
    memberchk("8/4=2", Es).

% Negative intermediate values are fine: (2-5)/3 = -1.
test(negative_intermediate, [true(V == -1), nondet]) :-
    expr([2,5,3], op(/, op(-, num(2), num(5)), num(3)), V).

:- end_tests(division).

% Shape of the results.
:- begin_tests(result_format).

test(all_results_are_strings) :-
    forall(member(L, [[4,2,5,3], [2,4,8], [1,1,1], [0,0], [1,2,3,4,5]]),
           ( all_equations(L, Es),
             forall(member(E, Es), string(E)) )).

test(generate_gives_string, [nondet]) :-
    generate_equation([2,4,8], E),
    string(E).

test(no_spaces) :-
    all_equations([1,2,3,4,5], Es),
    forall(member(E, Es), \+ sub_string(E, _, _, _, " ")).

test(exactly_one_equals_sign) :-
    all_equations([1,2,3,4,5], Es),
    forall(member(E, Es),
           ( split_string(E, "=", "", Parts), length(Parts, 2) )).

test(sorted_without_duplicates) :-
    all_equations([1,2,3,4,5], Es),
    sort(Es, Sorted),
    Es == Sorted.

test(count_matches_length) :-
    all_equations([1,2,3,4,5], Es),
    length(Es, Len),
    count_equations([1,2,3,4,5], N),
    N == Len.

:- end_tests(result_format).
