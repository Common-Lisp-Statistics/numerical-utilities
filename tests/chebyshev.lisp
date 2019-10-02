;;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: NUM-UTILS-TESTS -*-
;;;; Copyright (c) 2019 by Symbolics Pte. Ltd. All rights reserved.
(in-package #:num-utils-tests)

#+genera (setf *print-array* t)

(def-suite chebyshev
    :description "Test chebyshev functions"
    :in all-tests)
(in-suite chebyshev)

(defun maximum-on-grid (f interval &optional (n-grid 1000))
  "Maximum of F on a grid of N-GRID equidistand points in INTERVAL."
  (loop for index below n-grid
        maximizing (funcall f
                            (interval-midpoint interval
                                               (/ index (1- n-grid))))))

(defun approximation-error (f f-approx interval &optional (n-grid 1000))
  "Approximation error, using MAXIMUM-ON-GRID."
  (maximum-on-grid (lambda (x)
                     (abs-diff (funcall f x) (funcall f-approx x)))
                   interval n-grid))

(defun test-chebyshev-approximate (f interval n-polynomials test-interval
                                   &rest rest)
  (let ((f-approx (apply #'chebyshev-approximate f interval n-polynomials rest)))
    (approximation-error f f-approx test-interval)))

(test chebyshev-open-inf
  (is (<= (test-chebyshev-approximate (lambda (x) (/ x (+ 4 x)))
				      (interval 2 :plusinf) 15
				      (interval 2 102))
	  1e-5))
  (is (<= (test-chebyshev-approximate (lambda (x) (exp (- x)))
				      (interval 0 :plusinf) 15
				      (interval 0 10)
				      :n-points 30)
	  1e-4)))

(test chebyshev-finite-interval
  (is (<= (test-chebyshev-approximate (lambda (x) (/ (1+ (expt x 2))))
				      (interval -3d0 2d0) 20
				      (interval -1.5d0 1d0))
	  1e-3)))
