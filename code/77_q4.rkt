#lang racket/base
;; CS F301 Assignment 2 - Group 77
;; S2: Conditionally Insert into a Nested List

;; (my-length lst) -> number
;; The number of top-level elements of lst. The length of () is 0; the
;; length of (a . rest) is 1 + the length of rest. A sublist counts as one
;; element. Tail recursive: count holds the elements seen so far.
(define (my-length lst)
  (let loop ((rest lst) (count 0))
    (if (null? rest)
        count
        (loop (cdr rest) (+ count 1)))))
