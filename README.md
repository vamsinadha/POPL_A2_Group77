# CS F301 Principles of Programming Languages - Assignment 2 (Group 77)

All deliverables are in the `77/` folder.

| Problem | File | Owner |
|---|---|---|
| P1 | 77/code/77_q1.pl | Vamsi |
| P2 | 77/code/77_q2.pl | Vamsi |
| S1 | 77/code/77_q3.rkt | Vinay |
| S2 | 77/code/77_q4.rkt | Nischal |

## Running

From the `77/` folder:

```
swipl -q -f code/77_q1.pl -g main -t halt
swipl -q -f code/77_q2.pl -g "<goal>" -t halt
racket code/77_q3.rkt
racket code/77_q4.rkt
```

## Tests

From the `77/` folder:

```
swipl -q -f tests/test_q1.pl -g run_tests -t halt
swipl -q -f tests/test_q2.pl -g run_tests -t halt
raco test tests/test_q3.rkt
raco test tests/test_q4.rkt
```
