;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: NUM-UTILS.PRINT-MATRIX -*-
(cl:in-package #:num-utils.print-matrix)

(defun print-length-truncate (dimension)
  "Return values (min dimension *print-length*) and whether the constraint is binding."
  (if (or (not *print-length*) (<= dimension *print-length*))
      (values dimension nil)
      (values *print-length* t)))

(defvar *print-matrix-precision* 5
  "Number of digits after the decimal point when printing numeric matrices.")

(defun print-matrix-formatter (x)
  "Standard formatter for matrix printing.  Respects *print-precision*, and formats complex numbers as a+bi, eg 0.0+1.0i."
  ;; ?? do we want a complex numbers to be aligned on the +, like R? I
  ;; am not sure I like that very much, and for a lot of data, I would
  ;; visualize it graphically anyhow (I hate tables of 7+ numbers in
  ;; general).  -- Tamas, 2009-sep-13
  (let ((precision *print-matrix-precision*))
    (typecase x
      (integer (format nil "~d" x))
      (real (format nil "~,vf" precision x))
      (complex (format nil "~,vf+~,vfi"
                       precision (realpart x)
                       precision (imagpart x)))
      (t (format nil "~a" x)))))

(defun print-matrix (matrix stream
                     &key (formatter #'print-matrix-formatter)
                          (masked-fn (constantly nil))
                          (aligned? t)
                          (padding " ")
                          (indent "  "))
  "Format and print the elements of MATRIX (a 2d array) to STREAM, using PADDING between columns.

MASKED-FN is called on row and column indices.  If it returns nil, the corresponding element is formatted using FORMATTER and printed.  Otherwise, it should return a string, which is printed as is.  INDENT is printed before each row.

If ALIGNED?, columns will be right-aligned.  At most *PRINT-LENGTH* rows and columns are printed, more is indicated with ellipses (...)."
  ;; QUESTION maybe column & row labels, not a high priority at the moment
  (let+ (((&values nrow row-trunc?) (print-length-truncate (aops:nrow matrix)))
	 ((&values ncol col-trunc?) (print-length-truncate (aops:ncol matrix)))
	 (formatted-elements (make-array (list nrow ncol)))
	 (column-widths (make-array ncol :element-type 'fixnum :initial-element 0)))
    ;; first pass - format elements, measure width
    (dotimes (col ncol)
      (dotimes (row nrow)
	(let+ ((masked? (funcall masked-fn row col))
               (formatted-element (aif masked?
                                       it
                                       (funcall formatter (aref matrix row col))))
	       (width (length formatted-element)))
          (maxf (aref column-widths col) width)
	  (setf (aref formatted-elements row col) formatted-element))))
    ;; second pass - print
    (dotimes (row nrow)
      (when (plusp row)
        (fresh-line stream))
      (format stream indent)
      (dotimes (col ncol)
	(when (plusp col)
	  (princ padding stream))
	(let ((elt (aref formatted-elements row col)))
	  (if aligned?
	      (format stream "~V@A" (aref column-widths col) elt)
	      (princ elt stream))))
      (when col-trunc?
	(princ padding stream)
	(princ "..." stream)))
    (when row-trunc?
      (format stream "~&..."))))
