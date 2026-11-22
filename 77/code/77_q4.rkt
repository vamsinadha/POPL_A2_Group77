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

;; (is-list? e) -> boolean
;; e is a list: either () or a pair. (Elements are atoms or proper lists,
;; there are no dotted pairs.)
(define (is-list? e)
  (or (null? e) (pair? e)))

;; (make-inserter x len-ok?) -> function
;; Returns a function insert of one argument, a list lst. (insert lst) is
;; lst with x inserted at the front of every list (lst itself included, at
;; every level of nesting) whose original length satisfies len-ok?.
;; Every element of lst that is a list is first processed by insert itself
;; (my-map); then x is consed in front if (len-ok? (my-length lst)) holds.
;; The length is taken on the original lst, before anything is inserted.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed (my-map (lambda (e)
                                         (if (is-list? e)
                                             (insert e)
                                             e))
                                       lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert))

;; (insert-if-short x lst n) -> list
;; lst with x inserted at the front of every list (lst itself included, at
;; every level of nesting) whose original length is less than n: the
;; inserter made by make-inserter with the test "length < n", applied to lst.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; (print-insert-result)
;; Reads x, lst and n from standard input (in that order, with read) and
;; prints (insert-if-short x lst n) followed by a newline. let* makes the
;; three reads happen in order.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
