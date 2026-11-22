---
name: prolog-dev
description: Conventions, run/test commands, constraints and a self-review checklist for writing SWI-Prolog 9.2.x code for CS F301 Assignment 2 (P1 puzzle in code/77_q1.pl, P2 arithmetic equations in code/77_q2.pl). Use for any Prolog predicate, test or review in this repository.
---

# prolog-dev

Instructions for an AI assistant writing or reviewing Prolog for CS F301 Assignment 2 (Group 77).

## Language and version

- **SWI-Prolog 9.2.x** (the grader uses 9.x). Do not rely on features added after 9.2.
- Double-quoted text `"..."` is a **string** (SWI-Prolog 7+ default). Single-quoted `'...'` is an **atom**.
- Solution files: `code/77_q1.pl` (P1), `code/77_q2.pl` (P2). Tests: `tests/test_q1.pl`, `tests/test_q2.pl`.

## Scope of each answer

- One prompt = one unit of work (one predicate, one test file or one review). Write only the unit asked for. Do not add other predicates "for later" and do not rewrite parts of the file that were not mentioned.
- Never hard-code an answer that the program is supposed to derive (e.g. the puzzle solution).

## Coding conventions

- Predicate and variable names: `snake_case` predicates (`count_solutions/2`, `tree_string/2`), `CamelCase` variables (`Solution`, `LeftTree`).
- Above every predicate, a comment block giving its **mode** and its **declarative reading**:

  ```prolog
  % split_list(+List, -Left, -Right)
  % Left and Right are non-empty lists and Left followed by Right is List.
  ```

  Mode markers: `+` input (bound), `-` output (unbound), `?` either.
- The reading must say what is *true* when the predicate succeeds, not the steps it takes.
- Keep all clauses of a predicate together (contiguous). If clauses must be separated, use `:- discontiguous name/arity.`
- Use `_` or `_Name` for variables that are used once, so loading gives no singleton warnings.
- Prefer small helper predicates with clear readings over one long clause.
- Layout: 4-space indentation, one goal per line in clause bodies longer than one line.

## How to run code

Run from the repository root:

```
swipl -q -f code/77_q1.pl -g main -t halt
swipl -q -f code/77_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)" -t halt
swipl -q -f code/77_q2.pl -g "all_equations([4,2,5,3], Es), print(Es), nl" -t halt
```

- `-q` suppresses the banner, `-f` loads the file, `-g` runs the goal, `-t halt` exits afterwards.
- Loading the file must print **nothing** (no warnings either). Check by running `swipl -q -f code/77_qN.pl -g true -t halt`: the output must be empty.

## How to test (plunit)

Test files live in `tests/` and load the solution file relative to themselves:

```prolog
:- use_module(library(plunit)).
:- ensure_loaded('../code/77_q1').

:- begin_tests(q1).

test(count_all_clues) :-
    count_solutions([1,2,3,4,5,6,7,8,9], 1).

test(no_equation, [fail]) :-
    generate_equation([2,3,4], _).

test(examples, [true(Es == ["2*4=8"])]) :-
    all_equations([2,4,8], Es).

:- end_tests(q1).
```

Run with:

```
swipl -q -f tests/test_q1.pl -g run_tests -t halt
swipl -q -f tests/test_q2.pl -g run_tests -t halt
```

- `library(plunit)` is allowed in **test files only**, not in solution files.
- Use `[fail]` for goals that must fail, `[true(Expr)]` to check results, `[nondet]` if a test leaves a choice point on purpose.
- Every example from the assignment PDF must appear as a test, plus edge cases (empty lists, single elements, zero, division by zero, inexact division, no solution).

## Assignment constraints (hard rules)

1. No `assert`, `asserta`, `assertz`, `retract`, `retractall`, and no global variables (`b_setval`, `b_getval`, `nb_setval`, `nb_getval`).
2. No `:- initialization(...)` directive of any kind.
3. Never call `halt/0` or `halt/1` in a solution file.
4. Only these libraries may be used: `lists`, `apply`, `yall`, `aggregate`. Built-in predicates (`format/2,3`, `findall/3`, `sort/2`, `between/3`, `number_string/2`, `string_concat/3`, `is/2`, ...) are fine. No `clpfd`, no `dcg/basics`, no `strings` library.
5. Print nothing except what the task specifies. `main/0` in P1 prints exactly four lines; P2 prints nothing at all.
6. Solution files contain only definitions (and `:- use_module(library(...))` for the allowed libraries, or `:- discontiguous`).
7. P1: each clue is its own clause `clue(N, Solution)`; clue 9 has `% CLUE 9: <English sentence>` on the line directly above it and names no friend.
8. P2: equations are SWI-Prolog **strings** with no spaces; never build a string and parse it back into a term (no `term_string/2`, `term_to_atom/2`, `read_term_from_atom/3`, `atom_to_term/3` for evaluation).

## Self-review checklist (apply before every answer)

- [ ] I wrote only the unit that was asked for, and it fits into the existing file without breaking other predicates.
- [ ] Every new predicate has a mode line and a declarative reading comment.
- [ ] No assert/retract/global variables, no `initialization`, no `halt`, no library outside lists/apply/yall/aggregate.
- [ ] Loading the file prints nothing: no singleton variables, no discontiguous warnings, no top-level goals.
- [ ] Output (if any) matches the required format exactly: spacing, commas, newline at the end, atoms printed with `~w`/`write` (no quotes around `AI` or `c++`).
- [ ] The predicate **fails** cleanly (no exception, no infinite loop) on inputs with no answer, including `[]` and one-element lists.
- [ ] Arithmetic: every `is/2` and comparison has its right-hand side fully bound; integer division uses `//` only after checking the divisor is non-zero and `X mod Y =:= 0`.
- [ ] Strings vs atoms vs code lists are the types the spec asks for.
- [ ] `findall/3` + `sort/2` (duplicates removed) vs `msort/2` (duplicates kept) is used deliberately.
- [ ] I traced at least one example from the PDF by hand or gave the exact command to run it.
- [ ] Recursion terminates: each recursive call works on a strictly smaller list or structure.

## Common AI mistakes in Prolog (watch for these)

- **Atoms vs strings:** writing `"AI"` where the atom `'AI'` is needed, or returning an atom where a string is required (P2). `format(atom(A), ...)` gives an atom; `format(string(S), ...)` gives a string.
- **Quoted output:** using `print/1`, `writeq/1` or `~q`/`~p` prints `'AI'` and `'c++'` with quotes. Use `~w` or `write/1` for user-facing output.
- **Float division:** `X is 7/2` gives `3.5`. Use the `mod` check plus `//` for exact integer division; `/` on integers can produce floats or rationals.
- **Unbound arithmetic:** calling `is/2` or `=:=` before the operands are bound raises an instantiation error. Generate first, then compute.
- **Negation on unbound variables:** `\+ member(X, L)` with `X` unbound does not mean "X is not in L". Use `\+` only on fully instantiated terms (P1 clues run on a filled-in solution).
- **Left recursion / non-termination:** a clause such as `expr(L, T) :- expr(L, T1), ...` with the same list loops forever. Always split into strictly smaller non-empty parts.
- **Leaking choice points or duplicate answers:** generating the same tree twice, or `main/0` printing several solutions. Use `once/1` where exactly one answer is needed, and `sort/2` to deduplicate.
- **Cut misuse:** a red cut that removes valid solutions, or a cut placed before the test it should follow. Prefer pure code; add `once/1` at the call site instead.
- **Inventing predicates or libraries:** calling predicates that do not exist in SWI-Prolog 9.2 (e.g. `string_join/3`) or loading forbidden libraries (`clpfd`, `strings`, `dcg/basics`).
- **Forgetting the empty and one-element cases:** P2 must fail for `[]` and `[N]`, not throw an error.
- **Hard-coding:** writing the puzzle answer into `main/0` instead of deriving it from the clues.
- **Off-spec parentheses:** in P2, putting parentheses around single numbers or around a left operand of equal precedence (`(1-2)-3` must print as `1-2-3`).
- **Adding test calls or `:- initialization(main)` to solution files**, which makes the grader's output wrong.
- **Singleton warnings** printed at load time (`Singleton variables: [X]`), which count as unwanted output.
