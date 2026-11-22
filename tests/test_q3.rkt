#lang racket/base
;; Tests for S1 (code/77_q3.rkt)
;; Run from the repository root:
;;   raco test tests/test_q3.rkt
;;
;; The solution file has no provide, so the tests reach its definitions
;; through the module's namespace and compare the exact printed text.

(require rackunit racket/port racket/runtime-path racket/list)

(define-runtime-path solution-file "../code/77_q3.rkt")
(dynamic-require solution-file #f)
(define solution-ns (module->namespace solution-file))
(define (solution name) (eval name solution-ns))

(define print-inorder (solution 'print-inorder))
(define print-all-traversals (solution 'print-all-traversals))
(define print-height-and-leaves (solution 'print-height-and-leaves))

;; (output-of f tree): the text that (f tree) prints
(define (output-of f tree)
  (with-output-to-string (lambda () (f tree))))

;; (lines . strs): the strings joined, each followed by a newline
(define (lines . strs)
  (apply string-append (map (lambda (s) (string-append s "\n")) strs)))

;; ---------------------------------------------------------------------------
;; Loading the file prints nothing

(test-case "loading the solution prints nothing"
  (check-equal? (with-output-to-string
                  (lambda ()
                    (parameterize ([current-namespace (make-base-namespace)])
                      (dynamic-require solution-file #f))))
                ""))

;; ---------------------------------------------------------------------------
;; Examples from the assignment

(define t1 '(4 (2 (1 () ()) (3 () ()))
               (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

(test-case "t1"
  (check-equal? (output-of print-inorder t1) (lines "(1 2 3 4 5 6 7)"))
  (check-equal? (output-of print-all-traversals t1)
                (lines "(1 2 3 4 5 6 7)" "(4 2 1 3 6 5 7)" "(1 3 2 5 7 6 4)"))
  (check-equal? (output-of print-height-and-leaves t1) (lines "(3 4)")))

(test-case "t2 (right-only chain)"
  (check-equal? (output-of print-inorder t2) (lines "(1 2 3)"))
  (check-equal? (output-of print-all-traversals t2)
                (lines "(1 2 3)" "(1 2 3)" "(3 2 1)"))
  (check-equal? (output-of print-height-and-leaves t2) (lines "(3 1)")))

(test-case "t3 (symbol values)"
  (check-equal? (output-of print-inorder t3) (lines "(b a c)"))
  (check-equal? (output-of print-all-traversals t3)
                (lines "(b a c)" "(a b c)" "(b c a)"))
  (check-equal? (output-of print-height-and-leaves t3) (lines "(2 2)")))

(test-case "empty tree"
  (check-equal? (output-of print-inorder '()) (lines "()"))
  (check-equal? (output-of print-all-traversals '()) (lines "()" "()" "()"))
  (check-equal? (output-of print-height-and-leaves '()) (lines "(0 0)")))

;; ---------------------------------------------------------------------------
;; Edge cases

(test-case "single node"
  (define t '(5 () ()))
  (check-equal? (output-of print-inorder t) (lines "(5)"))
  (check-equal? (output-of print-all-traversals t) (lines "(5)" "(5)" "(5)"))
  (check-equal? (output-of print-height-and-leaves t) (lines "(1 1)")))

(test-case "left-only chain"
  (define t '(3 (2 (1 () ()) ()) ()))
  (check-equal? (output-of print-all-traversals t)
                (lines "(1 2 3)" "(3 2 1)" "(1 2 3)"))
  (check-equal? (output-of print-height-and-leaves t) (lines "(3 1)")))

(test-case "unbalanced tree"
  ;;        8
  ;;      /   \
  ;;     3     10
  ;;    / \      \
  ;;   1   6      14
  ;;      / \    /
  ;;     4   7  13
  (define t '(8 (3 (1 () ()) (6 (4 () ()) (7 () ())))
                (10 () (14 (13 () ()) ()))))
  (check-equal? (output-of print-all-traversals t)
                (lines "(1 3 4 6 7 8 10 13 14)"
                       "(8 3 1 6 4 7 10 14 13)"
                       "(1 4 7 6 3 13 14 10 8)"))
  (check-equal? (output-of print-height-and-leaves t) (lines "(4 4)")))

(test-case "node with one empty and one leaf child is not a leaf"
  (define t '(x (y () ()) ()))
  (check-equal? (output-of print-all-traversals t)
                (lines "(y x)" "(x y)" "(y x)"))
  (check-equal? (output-of print-height-and-leaves t) (lines "(2 1)")))

(test-case "mixed symbols and numbers"
  (define t '(m (1 () ()) (z (2 () ()) ())))
  (check-equal? (output-of print-inorder t) (lines "(1 m 2 z)"))
  (check-equal? (output-of print-height-and-leaves t) (lines "(3 2)")))

;; ---------------------------------------------------------------------------
;; Large trees

;; (left-chain n): a tree n -> n-1 -> ... -> 1 where every node has only a
;; left child
(define (left-chain n)
  (if (= n 0) '() (list n (left-chain (- n 1)) '())))

;; (full-tree depth start): a complete tree of the given depth whose inorder
;; list is start, start+1, ...; returns the tree
(define (full-tree depth start)
  (if (= depth 0)
      '()
      (let ([half (- (expt 2 (- depth 1)) 1)])
        (list (+ start half)
              (full-tree (- depth 1) start)
              (full-tree (- depth 1) (+ start half 1))))))

;; (list-text xs): the text display prints for the list xs
(define (list-text xs)
  (with-output-to-string (lambda () (display xs))))

(test-case "deep left chain (depth 10000)"
  (define n 10000)
  (define t (left-chain n))
  (define up (range 1 (+ n 1)))
  (check-equal? (output-of print-all-traversals t)
                (lines (list-text up) (list-text (reverse up)) (list-text up)))
  (check-equal? (output-of print-height-and-leaves t)
                (lines (format "(~a 1)" n))))

(test-case "complete tree of depth 12"
  (define t (full-tree 12 1))
  (check-equal? (output-of print-inorder t)
                (lines (list-text (range 1 (expt 2 12)))))
  (check-equal? (output-of print-height-and-leaves t)
                (lines (format "(12 ~a)" (expt 2 11)))))
