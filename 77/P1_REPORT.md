# P1 Report

## Value of N

```
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

So with all eight clues, 3 out of the 13824 possible assignments still work.

## The three solutions

| # | Alex | Ben | Carla | Dana |
|---|------|-----|-------|------|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## What this tells us

The puzzle doesn't have a unique answer. The clues narrow it down a lot, but not all the way.

Ben is the same in all three (development, javascript, web), so the clues pin him down completely. The confusion is only between Alex, Carla and Dana, mainly about who gets the AI project and who works in testing.

This is also why `main` prints just one of them (the first one found) and why we need a ninth clue to make the answer unique, which is done in P1.c.

## Picking the solution to keep (P1.c)

We couldn't keep solution 1 or 3. If you ignore names, they use exactly the same four combinations (design-java-AI, development-javascript-web, research-c++-data, testing-python-embedded), just handed out to different people. A clue that only talks about attribute values can't tell them apart, and clue 9 isn't allowed to name anyone.

Solution 2 is the odd one out: there the tester gets the AI project. So we kept solution 2 and added

> CLUE 9: The friend who prefers the AI project works in the testing department.

It holds in solution 2 and fails in 1 and 3 (the AI person works in design there), so `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives `N = 1`.
