#lang racket/base
;; Tests for S2 (code/77_q4.rkt)
;; Run from the repository root:
;;   raco test tests/test_q4.rkt
;;
;; The solution file has no provide, so the tests reach its definitions
;; through the module's namespace. print-insert-result is tested by feeding
;; it standard input and comparing the exact printed text.

(require rackunit racket/port racket/runtime-path racket/list racket/file)

(define-runtime-path solution-file "../code/77_q4.rkt")
(dynamic-require solution-file #f)
(define solution-ns (module->namespace solution-file))
(define (solution name) (eval name solution-ns))

(define my-length (solution 'my-length))
(define my-map (solution 'my-map))
(define make-inserter (solution 'make-inserter))
(define insert-if-short (solution 'insert-if-short))
(define print-insert-result (solution 'print-insert-result))

;; (run-with-input text): what print-insert-result prints when text is
;; its standard input
(define (run-with-input text)
  (with-output-to-string
    (lambda ()
      (with-input-from-string text print-insert-result))))

;; ---------------------------------------------------------------------------
;; The file itself

(test-case "loading the solution prints nothing"
  (check-equal? (with-output-to-string
                  (lambda ()
                    (parameterize ([current-namespace (make-base-namespace)])
                      (dynamic-require solution-file #f))))
                ""))

(test-case "the file has exactly one definition of insert-if-short"
  (define text (file->string solution-file))
  (check-equal? (length (regexp-match* #rx"\\(define \\(insert-if-short" text)) 1))

;; ---------------------------------------------------------------------------
;; Examples from the assignment (standard input -> printed output)

(test-case "example 1"
  (check-equal? (run-with-input "42 ((1 2) (3 4 5) (6) ()) 3")
                "((42 1 2) (3 4 5) (42 6) (42))\n"))

(test-case "example 2"
  (check-equal? (run-with-input "0 (((1) 2) (3) ((4 5 6) ())) 3")
                "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n"))

(test-case "example 3: empty top-level list, n = 3"
  (check-equal? (run-with-input "7 () 3") "(7)\n"))

(test-case "example 4: empty top-level list, n = 0"
  (check-equal? (run-with-input "7 () 0") "()\n"))

(test-case "input spread over several lines"
  (check-equal? (run-with-input "42\n((1 2) (3 4 5) (6) ())\n3\n")
                "((42 1 2) (3 4 5) (42 6) (42))\n"))

;; ---------------------------------------------------------------------------
;; my-length and my-map

(test-case "my-length"
  (check-equal? (my-length '()) 0)
  (check-equal? (my-length '(1 2 3)) 3)
  (check-equal? (my-length '((1 2) (3 4 5) (6) ())) 4)
  (check-equal? (my-length '(())) 1)
  (check-equal? (my-length (range 10000)) 10000))

(test-case "my-map"
  (check-equal? (my-map (lambda (e) (* e 10)) '(1 2 3)) '(10 20 30))
  (check-equal? (my-map (lambda (e) e) '()) '())
  (check-equal? (my-map my-length '((1 2) () (3))) '(2 0 1))
  (check-equal? (my-map (lambda (e) (+ e 1)) (range 10000)) (range 1 10001)))

;; ---------------------------------------------------------------------------
;; make-inserter with other tests

(test-case "make-inserter: length exactly 2"
  (check-equal? ((make-inserter 'z (lambda (len) (= len 2)))
                 '((1 2) (3) (4 5 (6 7))))
                '((z 1 2) (3) (4 5 (z 6 7)))))

(test-case "make-inserter: only empty lists"
  (check-equal? ((make-inserter 'e (lambda (len) (= len 0))) '(() (1 ()) 2))
                '((e) (1 (e)) 2)))

(test-case "make-inserter: never and always"
  (check-equal? ((make-inserter 'q (lambda (len) #f)) '(1 (2) ())) '(1 (2) ()))
  (check-equal? ((make-inserter 'q (lambda (len) #t)) '(1 (2) ()))
                '(q 1 (q 2) (q))))

(test-case "make-inserter returns a reusable function"
  (define add-a (make-inserter 'a (lambda (len) (< len 2))))
  (check-equal? (add-a '(1)) '(a 1))
  (check-equal? (add-a '(1 2)) '(1 2)))

;; ---------------------------------------------------------------------------
;; Edge cases of insert-if-short

(test-case "n = 0 changes nothing, not even ()"
  (check-equal? (insert-if-short 'x '(1 (2) (()) ()) 0) '(1 (2) (()) ())))

(test-case "n = 1 only touches empty lists"
  (check-equal? (insert-if-short 'x '(1 (2) (()) ()) 1) '(1 (2) ((x)) (x))))

(test-case "a list exactly as long as n is not changed"
  (check-equal? (insert-if-short 'x '(1 2 3) 3) '(1 2 3))
  (check-equal? (insert-if-short 'x '(1 2 3) 4) '(x 1 2 3)))

(test-case "lengths are taken before inserting"
  ;; (1 2) has length 2 < 3, so it gets x and becomes length 3; the
  ;; top-level list has length 1 < 3, so it gets x too.
  (check-equal? (insert-if-short 'x '((1 2)) 3) '(x (x 1 2))))

(test-case "symbols as elements and as x"
  (check-equal? (insert-if-short 'a '(b (c d) e) 2) '(b (c d) e))
  (check-equal? (insert-if-short 'a '(b (c d) e) 3) '(b (a c d) e))
  (check-equal? (insert-if-short 'new '(old) 5) '(new old)))

(test-case "nested empty lists"
  (check-equal? (insert-if-short 0 '(() (()) ((()))) 2)
                '((0) (0 (0)) (0 (0 (0))))))

;; ---------------------------------------------------------------------------
;; Large inputs

;; (nest d): () wrapped in d lists, e.g. (nest 2) = ((()))
(define (nest d)
  (if (= d 0) '() (list (nest (- d 1)))))

;; (nest-with x d): the expected result of inserting x everywhere in (nest d)
(define (nest-with x d)
  (if (= d 0) (list x) (list x (nest-with x (- d 1)))))

(test-case "nesting depth 100"
  (check-equal? (insert-if-short 'x (nest 100) 5) (nest-with 'x 100))
  (check-equal? (insert-if-short 'x (nest 100) 0) (nest 100)))

(test-case "list of 10,000 elements"
  (define big (range 10000))
  (check-equal? (insert-if-short 'x big 10001) (cons 'x big))
  (check-equal? (insert-if-short 'x big 10000) big))

(test-case "10,000 elements through standard input"
  (define big (range 10000))
  (define input (format "x ~a 10001" big))
  (check-equal? (run-with-input input)
                (string-append (format "~a" (cons 'x big)) "\n")))
