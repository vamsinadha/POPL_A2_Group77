% CS F301 Assignment 2 - Group 77
% P1: Department Assignment Puzzle, Reloaded
%
% A solution is a list of four terms p(Name, Dept, Lang, Project) in the
% order Alex, Ben, Carla, Dana, where every department, language and
% project value is used exactly once.

:- use_module(library(lists)).

% candidate(-Solution)
% Solution is a fully filled-in assignment for Alex, Ben, Carla and Dana
% (in that order) in which each department, language and project is used
% exactly once. No clue is checked here; on backtracking it gives all
% 4! * 4! * 4! = 13824 candidates.
candidate([p('Alex',  D1, L1, P1),
           p('Ben',   D2, L2, P2),
           p('Carla', D3, L3, P3),
           p('Dana',  D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],        [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [P1, P2, P3, P4]).

% clue(+N, +Solution)
% Clue number N holds in the fully filled-in Solution.
% Every clause only inspects Solution, so it is used after generation
% (generate-and-test); == and \== are safe because all values are bound.

% Clue 1: The friend who prefers the AI project does not work in research
% and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \== research,
    Name \== 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \== development,
    Lang \== 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_, testing, Lang, _), Solution),
    Lang == python.

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, Project), Solution),
    Project == web,
    Dept \== testing.

% Clue 5: The friend whose favorite language is Java works in the design
% department.
clue(5, Solution) :-
    member(p(_, Dept, java, _), Solution),
    Dept == design.

% Clue 6: Carla's project preference is not embedded, and her department
% is not development.
clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Project \== embedded,
    Dept \== development.

% Clue 7: Dana's favorite language is not Java, and she works in research
% or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \== java,
    ( Dept == research ; Dept == testing ).

% Clue 8: The friend who prefers data projects works in research and does
% not use JavaScript.
clue(8, Solution) :-
    member(p(_, Dept, Lang, data), Solution),
    Dept == research,
    Lang \== javascript.

% satisfies_all(+Active, +Solution)
% Every clue whose number is in the list Active holds in Solution.
satisfies_all(Active, Solution) :-
    forall(member(N, Active), clue(N, Solution)).

% main
% Prints one solution that satisfies clues 1 to 8, one line per friend in
% the order Alex, Ben, Carla, Dana, as  Name = [Dept, Lang, Project].
% The solution is found by generate-and-test, not hard-coded; once/1 keeps
% only the first one.
main :-
    once(( candidate(Solution),
           satisfies_all([1,2,3,4,5,6,7,8], Solution) )),
    forall(member(p(Name, Dept, Lang, Project), Solution),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project])).
