#Prompts for skill files


## prolog-dev — Prompt 1
Write skills/prolog-dev/SKILL.md, a skill file for an AI assistant doing the Prolog part of our CS F301 Assignment 2. Include: a YAML header (name: prolog-dev, description); language and version (SWI-Prolog 9.2.x); coding conventions (snake_case names, a comment above each predicate giving its declarative reading and argument modes); how to run code (swipl -q -f file.pl -g main -t halt and swipl -q -f file.pl -g "<goal>" -t halt) and how to run plunit tests in tests/; the assignment constraints (no assert/retract/b_setval/nb_setval, no initialization directive, never call halt, only the lists/apply/yall/aggregate libraries, print nothing except what is specified); a self-review checklist to apply before every answer; and a list of common AI mistakes in Prolog.

## scheme-dev — Prompt 1
Write skills/scheme-dev/SKILL.md, a skill file for the Scheme part of the same assignment (S1 tree traversals in code/77_q3.rkt, S2 nested list insert in code/77_q4.rkt). Use skills/prolog-dev/SKILL.md as the model. Include: a YAML header (name: scheme-dev, description); language and version (Racket 8.x, files start with #lang racket/base); the exact list of allowed built-ins from the assignment (and that S2 may also use read) and the ones that are forbidden (set!, vectors, hash tables, strings, loops, length, append, reverse, map, filter, member, memq, list-ref, list-tail); coding conventions (kebab-case names, my- prefix for our own versions of library functions, a comment above each function with its recursive reading); how to run a file and how to try a call the way the grader does (it appends its own calls to the end of the file), and how to test in tests/ without adding provide to the solution file; a self-review checklist to apply before every answer; and a list of common AI mistakes in Scheme.


## scheme-dev — Prompt 2 (review)
Review skills/scheme-dev/SKILL.md against the S2 part of the assignment before I use it for the rest of S2. Is it correct, and does it cover everything S2 needs?

## scheme-dev — Prompt 3 (fixes)
Fix the four things you found in skills/scheme-dev/SKILL.md: the rule about not building lists backwards clashes with my-map (collect backwards then my-reverse once is fine for long flat lists), say that make-inserter must still use my-length and my-map, add what print-insert-result has to do (read x, lst, n in that order, no prompt, just the list and a newline), and reword the "else in if" mistake so it's clear. Don't change anything else in the file.
