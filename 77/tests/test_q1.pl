% Tests for P1 (code/77_q1.pl)
% Run from the 77/ folder:
%   swipl -q -f tests/test_q1.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- ensure_loaded('../code/77_q1').

% Hand-made solutions used by the clue tests.

% sol_one(-Solution)
% The first solution of clues 1-8 (the one main/0 prints).
sol_one([p('Alex',  design,      java,       'AI'),
         p('Ben',   development, javascript, web),
         p('Carla', research,    'c++',      data),
         p('Dana',  testing,     python,     embedded)]).

% sol_two(-Solution)
% The solution of clues 1-8 that is kept by clue 9.
sol_two([p('Alex',  design,      java,       embedded),
         p('Ben',   development, javascript, web),
         p('Carla', testing,     python,     'AI'),
         p('Dana',  research,    'c++',      data)]).

% sol_layout(-Solution)
% The layout example from the assignment. Clues 2, 4 and 7 hold in it;
% clues 1, 3, 5, 6 and 8 fail.
sol_layout([p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)]).

% sol_bad(-Solution)
% A valid assignment that breaks clues 2, 4, 7 and 9: Alex works in
% development, Ben prefers data, Dana works in design, and the AI friend
% does not work in testing.
sol_bad([p('Alex',  development, 'c++',      'AI'),
         p('Ben',   testing,     python,     data),
         p('Carla', research,    java,       web),
         p('Dana',  design,      javascript, embedded)]).

:- begin_tests(clues).

% Each clue holds in a real solution ... (nondet: member/2 may leave a
% choice point, which is fine for a check that only has to succeed)
test(clue_1_holds, [nondet]) :- sol_one(S), clue(1, S).
test(clue_2_holds, [nondet]) :- sol_one(S), clue(2, S).
test(clue_3_holds, [nondet]) :- sol_one(S), clue(3, S).
test(clue_4_holds, [nondet]) :- sol_one(S), clue(4, S).
test(clue_5_holds, [nondet]) :- sol_one(S), clue(5, S).
test(clue_6_holds, [nondet]) :- sol_one(S), clue(6, S).
test(clue_7_holds, [nondet]) :- sol_one(S), clue(7, S).
test(clue_8_holds, [nondet]) :- sol_one(S), clue(8, S).
test(clue_9_holds, [nondet]) :- sol_two(S), clue(9, S).

% ... and fails in a hand-made one that breaks it.
test(clue_1_fails, [fail]) :- sol_layout(S), clue(1, S).
test(clue_2_fails, [fail]) :- sol_bad(S),    clue(2, S).
test(clue_3_fails, [fail]) :- sol_layout(S), clue(3, S).
test(clue_4_fails, [fail]) :- sol_bad(S),    clue(4, S).
test(clue_5_fails, [fail]) :- sol_layout(S), clue(5, S).
test(clue_6_fails, [fail]) :- sol_layout(S), clue(6, S).
test(clue_7_fails, [fail]) :- sol_bad(S),    clue(7, S).
test(clue_8_fails, [fail]) :- sol_layout(S), clue(8, S).
test(clue_9_fails, [fail]) :- sol_one(S),    clue(9, S).

% Clues that hold in the layout example really do hold there.
test(layout_partial, [nondet]) :-
    sol_layout(S),
    clue(2, S), clue(4, S), clue(7, S).

:- end_tests(clues).

:- begin_tests(main).

test(exact_output, [true(Out == Expected)]) :-
    with_output_to(string(Out), main),
    Expected = "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n".

:- end_tests(main).

:- begin_tests(count).

test(no_clues, [true(N == 13824)]) :-
    count_solutions([], N).

test(one_clue, [true(N == 3456)]) :-
    count_solutions([3], N).

test(clues_1_to_8, [true(N == 3)]) :-
    count_solutions([1,2,3,4,5,6,7,8], N).

test(order_does_not_matter, [true(N == 3)]) :-
    count_solutions([8,7,6,5,4,3,2,1], N).

test(clues_1_to_9, [true(N == 1)]) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N).

test(kept_solution_is_solution_two, [true(S == Two)]) :-
    sol_two(Two),
    once(( candidate(S),
           satisfies_all([1,2,3,4,5,6,7,8,9], S) )).

:- end_tests(count).
