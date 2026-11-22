---
name: scheme-dev
description: Conventions, allowed built-ins, run/test commands and a self-review checklist for writing Racket 8.x (#lang racket/base) code for CS F301 Assignment 2 (S1 tree traversals in code/77_q3.rkt, S2 nested list insert in code/77_q4.rkt). Use for any Scheme function, test or review in this repository.
---

# scheme-dev

Instructions for an AI assistant writing or reviewing Scheme for CS F301 Assignment 2 (Group 77).

## Language and version

- **Racket 8.x** (tested with 8.18 CS). Every solution file starts with the line `#lang racket/base`.
- Solution files: `code/77_q3.rkt` (S1), `code/77_q4.rkt` (S2). Tests: `tests/test_q3.rkt`, `tests/test_q4.rkt`.
- Even though `racket/base` provides much more, a solution file may use **only** the built-ins listed below.

## Scope of each answer

- One prompt = one unit of work (one function or a small group of helpers for one task, one test file or one review). Write only what was asked for. Do not add functions "for later" and do not rewrite parts of the file that were not mentioned.
- Never call functions at the top level of a solution file and never print when the file is loaded.

## Allowed built-ins (the complete list)

| Kind | Allowed |
|---|---|
| Definitions and binding | `define`, `lambda`, `let`, `let*`, `letrec`, named `let` |
| Control | `if`, `cond` (with `else`), `and`, `or`, `not`, `begin` |
| Data | `quote` (`'`), `cons`, `car`, `cdr`, `list`, every `c[ad]{2,4}r` (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, ...) |
| Predicates and lookup | `null?`, `pair?`, `eq?`, `assq`, `assoc` |
| Arithmetic and comparison | `+ - * < > <= >= =`, `max` |
| Output | `display`, `newline` |
| Input (**S2 only**) | `read` |

**Forbidden** (non-exhaustive): `set!` and every mutation (`set-car!`, `set-box!`, ...), vectors, hash tables, strings and string functions, characters, `do`, `for` and every `for/...` loop, `length`, `append`, `reverse`, `map`, `for-each`, `filter`, `foldl`/`foldr`, `apply`, `member`, `memq`, `list-ref`, `list-tail`, `list?`, `number?`, `symbol?`, `equal?`, `zero?`, `add1`/`sub1`, `min`, `displayln`, `printf`, `write`, `print`, `void`, `when`, `unless`, `case`, `match`, `provide`, `require`, `struct`, `define-values`, `values`.

If one of these is needed, write it yourself with the `my-` prefix (`my-length`, `my-map`, `my-append`, `my-reverse`).

## Coding conventions

- Names in `kebab-case`; predicates end in `?` (`leaf?`, `len-ok?`); our own versions of library functions start with `my-`.
- Above every function, a comment with its **recursive reading**: what it returns for the base case and how the result for a bigger input is built from the results for smaller ones.

  ```racket
  ;; (my-length lst) -> number
  ;; The length of () is 0; the length of (a . rest) is 1 + the length of rest.
  (define (my-length lst)
    (let loop ((lst lst) (count 0))
      (if (null? lst)
          count
          (loop (cdr lst) (+ count 1)))))
  ```
- Pass all state through arguments (accumulators); no global mutable state.
- Prefer tail recursion (named `let` with an accumulator) where it is natural, especially for walking long lists (S2 hidden tests use lists of 10,000 elements and nesting depth 100).
- When walking a tree, pass the accumulator from the right so `cons` produces the final order directly (no reversing needed). For a long flat list (like S2's 10,000 elements), collecting results backwards in a tail-recursive loop and turning them around once with your own `my-reverse` at the end is the accepted pattern; what to avoid is reversing repeatedly or using `append` to add at the end.
- Small helpers with clear readings are better than one long function. Two-space indentation, standard Racket layout, closing parentheses on the same line.

## How to run code

From the 77/ folder:

```
racket code/77_q3.rkt
```

This must print **nothing** (only definitions). To try a call the way the grader does (it appends its own calls to the end of the file), copy the file and append a call:

```powershell
Copy-Item code\77_q3.rkt $env:TEMP\try.rkt; Add-Content $env:TEMP\try.rkt "(print-inorder '(4 (2 () ()) (6 () ())))"; racket $env:TEMP\try.rkt
```

S2 reads from standard input, so pipe the input in:

```powershell
Copy-Item code\77_q4.rkt $env:TEMP\try.rkt; Add-Content $env:TEMP\try.rkt "(print-insert-result)"; "42 ((1 2) (3 4 5) (6) ()) 3" | racket $env:TEMP\try.rkt
```

## How to test (rackunit)

The solution files have no `provide` and must not get one. The test files reach the definitions through the module's namespace instead:

```racket
#lang racket/base
(require rackunit racket/port racket/runtime-path)

(define-runtime-path solution-file "../code/77_q3.rkt")
(dynamic-require solution-file #f)
(define solution-ns (module->namespace solution-file))
(define (solution name) (eval name solution-ns))

;; output-of: the text a thunk prints
(define (output-of thunk) (with-output-to-string thunk))

(check-equal? (output-of (lambda () ((solution 'print-inorder) '(4 (2 () ()) (6 () ())))))
              "(2 4 6)\n")
```

Run with:

```
raco test tests/test_q3.rkt
raco test tests/test_q4.rkt
```

- Test files may use `rackunit`, `racket/port` and other libraries freely; the built-in restriction applies to solution files only.
- For S2, feed standard input with `with-input-from-string`.
- Every example from the assignment PDF must appear as a test (compare the exact printed text, including the final newline), plus edge cases: empty tree or list, a single node, one-sided trees, symbols as values, deep nesting, long lists.

## Assignment constraints (hard rules)

1. The file starts with `#lang racket/base` and contains only `define`s (and comments).
2. No top-level calls, no output when the file loads, no `provide`/`require`.
3. Only the built-ins in the table above. Anything else is written by hand.
4. Every printing function prints exactly what is specified with `display` and ends with exactly one `newline`.
5. S1: trees are `()` or `(value left right)`; visit left before right; height of `()` is 0; a leaf is a node with two empty subtrees.
6. S2: lengths are measured on the **original** list, before insertion; the top-level list is treated like any other list; `()` has length 0; the final file has exactly one `insert-if-short`, defined with `make-inserter`. `make-inserter` itself must still use `my-length` and `my-map` (S2.b requires them), so moving to `make-inserter` must not drop those helpers.
7. S2 `print-insert-result` takes no arguments, calls `read` three times in the order `x`, `lst`, `n` (the values `read` returns are already data, so never quote them), and prints only the resulting list with `display` followed by one `newline`: no prompt and no other text.

## Self-review checklist (apply before every answer)

- [ ] I wrote only the unit that was asked for, and it fits into the existing file without breaking other functions.
- [ ] Every identifier I used is either in the allowed table, a parameter/local, or a function defined in this file. (Scan for `length`, `append`, `reverse`, `map`, `list?`, `equal?`, `else` outside `cond`, `when`, `displayln`.)
- [ ] No `set!` or other mutation, no strings, no vectors, no loops.
- [ ] Every new function has a comment with its recursive reading.
- [ ] Base cases cover `()` and recursion always moves to a strictly smaller list or subtree.
- [ ] Long lists are walked with tail recursion; non-tail recursion only goes as deep as the nesting or tree height.
- [ ] Output matches the specification exactly: `display` of a list prints `(1 2 3)`, an empty list prints `()`, and each printing function ends with one `newline`.
- [ ] Loading the file prints nothing (`racket code/77_qN.rkt` gives empty output).
- [ ] I traced at least one example from the PDF by hand or gave the exact command to run it.

## Common AI mistakes in Scheme (watch for these)

- **Reaching for forbidden built-ins out of habit:** `length`, `append`, `reverse`, `map`, `for-each`, `apply`, `list?`, `equal?`, `add1`, `displayln`, `printf`, `when`/`unless`. They all work in `racket/base`, so nothing warns you; they are still forbidden here.
- **`append` inside a traversal:** `(append (inorder left) (list v) (inorder right))` is both forbidden and quadratic. Use an accumulator instead.
- **Build-then-reverse:** consing in the wrong order and fixing it with `reverse` (forbidden) or a hand-written reverse that was not needed.
- **Mutation:** using `set!` to keep a counter or result list instead of passing it as an argument.
- **Top-level test calls or `(module+ test ...)` / `(module+ main ...)` in the solution file**, which print when the grader runs it.
- **Adding `provide` or `require`** to the solution file to make testing easier.
- **Wrong output form:** using `write`/`print` (quotes symbols, differs for strings), forgetting the final `newline`, or printing an extra newline or space.
- **Treating `()` as special or as an atom wrongly:** in Racket `(pair? '())` is `#f` and `(null? '())` is `#t`; a sublist is detected with `pair?` or `null?`, not `list?`.
- **Measuring length after inserting** (S2), or skipping the top-level list.
- **Deep non-tail recursion over long lists:** recursing on `cdr` without an accumulator for 10,000 elements; keep the deep recursion only where the problem forces it (nesting, tree height).
- **`if` and `cond` mix-ups:** `if` has no `else` keyword (it is always `(if test then-part else-part)`), and a `cond` without an `else` clause returns `#<void>` when no test matches, which `display` then prints.
- **Confusing `eq?` with `equal?`:** `eq?` is fine for symbols and small numbers, not for comparing lists.
