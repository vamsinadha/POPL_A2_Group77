# CS F301 – Principles of Programming Languages
## Assignment 2 | Group 77

This repository contains the solutions, tests, skill files, and prompts for Assignment 2.

All assignment deliverables are organized inside the `77/` directory.

## Group Members

| Name | BITS ID |
|---|---|
| G Vamsinadha | 2024A7PS0080H |
| M Nischalreddy | 2024A7PS0151H |
| V Jitendra Vinay | 2024A7PS0087H |

## Problem Contributions

| Problem | File | By |
|---|---|---|
| P1 – Department Assignment Puzzle | `77/code/77_q1.pl` | G Vamsinadha |
| P2 – Arithmetic Equation Generator | `77/code/77_q2.pl` | G Vamsinadha |
| S1 – Binary Tree Traversals | `77/code/77_q3.rkt` | V Jitendra Vinay |
| S2 – Conditional Nested List Insertion | `77/code/77_q4.rkt` | M Nischalreddy |

## Repository Structure

```text
77/
├── code/
│   ├── 77_q1.pl
│   ├── 77_q2.pl
│   ├── 77_q3.rkt
│   └── 77_q4.rkt
├── tests/
│   ├── test_q1.pl
│   ├── test_q2.pl
│   ├── test_q3.rkt
│   └── test_q4.rkt
├── skills/
│   ├── prolog-dev/
│   │   └── SKILL.md
│   └── scheme-dev/
│       └── SKILL.md
├── prompts/
│   ├── P1.md
│   ├── P2.md
│   ├── S1.md
│   └── S2.md
└── P1_REPORT.md
```

## Prerequisites

The following tools are required:

- **SWI-Prolog 9.x** – For P1 and P2.
- **Racket 8.x** – For S1 and S2.

Ensure that the SWI-Prolog and Racket executable directories are added to your system's PATH so that `swipl`, `racket`, and `raco` commands can be used from the terminal.

## Running the Programs

Open a terminal in the repository's root directory and navigate to the `77/` folder:

```bash
cd 77
```

### Prolog

Run P1:

```bash
swipl -q -f code/77_q1.pl -g main -t halt
```

Run P2 with an example query:

```bash
swipl -q -f code/77_q2.pl -g "all_equations([4,2,5,3], Es), writeln(Es)" -t halt
```

### Racket

Run S1:

```bash
racket code/77_q3.rkt
```

Run S2:

```bash
racket code/77_q4.rkt
```

The Racket solution files contain function definitions only, so running them directly is expected to produce no output. The functions are invoked by the tests or grader.

## Running Tests

All test commands should be executed from inside the `77/` directory.

### Prolog Tests

P1:

```bash
swipl -q -f tests/test_q1.pl -g run_tests -t halt
```

P2:

```bash
swipl -q -f tests/test_q2.pl -g run_tests -t halt
```

### Racket Tests

S1:

```bash
raco test tests/test_q3.rkt
```

S2:

```bash
raco test tests/test_q4.rkt
```

