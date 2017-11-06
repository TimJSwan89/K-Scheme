;;; This example illustrates how quasiquote evaluates its unquote
;;; expressions non-deterministically
;;; Note: this example takes a while
(display `( #(,(begin (display 0) 0)) (,(begin (display 1) 1) ,(begin (display 2) 2))))

;;; The keyword SEARCH (always at the end of a program) tells maude to use search rather 
;;; than rewrite, for when multiple answers due to non-determinism are desired
SEARCH