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
