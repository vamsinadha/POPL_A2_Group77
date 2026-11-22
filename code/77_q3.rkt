#lang racket/base
;; CS F301 Assignment 2 - Group 77
;; S1: Binary Tree Traversals
;;
;; A binary tree is either () or a three-element list (value left right),
;; where left and right are binary trees. Left is always visited before right.

;; ---------------------------------------------------------------------------
;; Tree accessors

;; (node-value tree), (node-left tree), (node-right tree)
;; The value, left subtree and right subtree of a non-empty tree (value left right).
(define (node-value tree) (car tree))
(define (node-left tree) (cadr tree))
(define (node-right tree) (caddr tree))

;; ---------------------------------------------------------------------------
;; Traversals
;;
;; Each traversal uses an accumulator acc holding the values that come AFTER
;; the current subtree in the final list. The right part is added to acc
;; first, so every cons puts a value directly in front of what follows it and
;; the list comes out in the right order with no append or reverse.

;; (inorder-acc tree acc) -> list
;; For () the result is acc. For (v l r) it is the inorder list of l,
;; followed by v, followed by the inorder list of r, followed by acc.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (node-left tree)
                   (cons (node-value tree)
                         (inorder-acc (node-right tree) acc)))))

;; (inorder tree) -> list
;; The values of tree in inorder (left subtree, node, right subtree).
(define (inorder tree)
  (inorder-acc tree '()))

;; (preorder-acc tree acc) -> list
;; For () the result is acc. For (v l r) it is v, followed by the preorder
;; list of l, followed by the preorder list of r, followed by acc.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (node-value tree)
            (preorder-acc (node-left tree)
                          (preorder-acc (node-right tree) acc)))))

;; (preorder tree) -> list
;; The values of tree in preorder (node, left subtree, right subtree).
(define (preorder tree)
  (preorder-acc tree '()))

;; (postorder-acc tree acc) -> list
;; For () the result is acc. For (v l r) it is the postorder list of l,
;; followed by the postorder list of r, followed by v, followed by acc.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (node-left tree)
                     (postorder-acc (node-right tree)
                                    (cons (node-value tree) acc)))))

;; (postorder tree) -> list
;; The values of tree in postorder (left subtree, right subtree, node).
(define (postorder tree)
  (postorder-acc tree '()))

;; ---------------------------------------------------------------------------
;; Printing

;; (print-line x)
;; Displays x followed by a newline.
(define (print-line x)
  (display x)
  (newline))

;; (print-inorder tree)
;; Prints the inorder list of tree on one line, e.g. (1 2 3 4 5 6 7).
(define (print-inorder tree)
  (print-line (inorder tree)))

;; (print-all-traversals tree)
;; Prints three lines: the inorder, preorder and postorder lists of tree.
(define (print-all-traversals tree)
  (print-line (inorder tree))
  (print-line (preorder tree))
  (print-line (postorder tree)))

;; ---------------------------------------------------------------------------
;; Height and leaves

;; (leaf? tree) -> boolean
;; A non-empty tree is a leaf when both its subtrees are ().
(define (leaf? tree)
  (and (null? (node-left tree))
       (null? (node-right tree))))

;; (height tree) -> number
;; The height of () is 0; the height of (v l r) is 1 + the larger of the
;; heights of l and r.
(define (height tree)
  (if (null? tree)
      0
      (+ 1 (max (height (node-left tree))
                (height (node-right tree))))))

;; (count-leaves-acc tree acc) -> number
;; For () the result is acc. For a leaf it is acc + 1. For any other node it
;; is acc plus the leaves of the left subtree plus the leaves of the right
;; subtree (the count is carried through acc; the right subtree is a tail call).
(define (count-leaves-acc tree acc)
  (cond ((null? tree) acc)
        ((leaf? tree) (+ acc 1))
        (else (count-leaves-acc (node-right tree)
                                (count-leaves-acc (node-left tree) acc)))))

;; (count-leaves tree) -> number
;; The number of leaves in tree; the empty tree has none.
(define (count-leaves tree)
  (count-leaves-acc tree 0))

;; (print-height-and-leaves tree)
;; Prints one line: the list (height leaf-count) of tree, e.g. (3 4).
(define (print-height-and-leaves tree)
  (print-line (list (height tree) (count-leaves tree))))
