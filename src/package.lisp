(defpackage #:cl-num-utils
    (:nicknames #:clnu)
  (:use #:cl #:cl-utilities #:iterate #:metabang-bind #:anaphora
        #:tpapp-utils)
  (:shadowing-import-from :iterate #:collecting #:collect)
  (:export

   ;; misc
   
   divides? square

   ;; seq

   vector* numseq vector-satisfies? cumsum sort-order

   ;; pretty

   real-epsilon *default-min-step-correction* pretty-step

   ;; bins

   bin-range bin-index bin-function bin-domain-error
   evenly-distributed-bins pretty-bins integer-bins sturges-bins 
   irregular-bins within? breaks

   ;; statistics

   size sum sse mean variance

   ;; interval
   
   interval interval-left interval-right make-interval forced-interval
   make-forced-interval interval-diff interval-width interval-midpoint
   positive-interval-p negative-interval-p weakly-positive-interval-p
   weakly-negative-interval-p zero-interval-p flip-interval 
   make-interval-or-nil range combined-range interval-intersection
   fraction fraction-value fractions percent percents spacer
   spacer-value spacers split-interval

   ;; histogram

   histogram-counter with-histogram-counter histogram-count
   hash-key-range hash-key-range2 hash-table->array hash-table->array2

   ;; sub

   sub-incompatible-dimensions sub-invalid-array-index 
   sub-invalid-range transform-index sub-all sub-index sub-range
   transform-range transform-ranges row-major-coefficients
   column-major-coefficients drop-dimensions range-dimension
   range-dimensions with-range-indexing sub map-columns map-rows
   transpose create collect-rows collect-vector

   ;; ix
   
   ix ix-keys make-ix ix->spec

   ))
