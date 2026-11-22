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
