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

;; (my-reverse lst) -> list
;; The elements of lst in reverse order. The reverse of () is (); the
;; reverse of (a . rest) is the reverse of rest followed by a. Tail
;; recursive: acc holds the already reversed front part, so each element is
;; consed in front of the ones before it.
(define (my-reverse lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc)))))

;; (my-map f lst) -> list
;; The list of (f e) for each top-level element e of lst, in the same order.
;; my-map of () is (); my-map of (a . rest) is (f a) followed by my-map of
;; rest. Tail recursive: the results are collected backwards in acc and
;; turned around once with my-reverse at the end.
(define (my-map f lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        (my-reverse acc)
        (loop (cdr rest) (cons (f (car rest)) acc)))))
