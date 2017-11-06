;;;This example show cases the non-deterministic evaluation of sub-terms
;;;in an application form.  Change the number of x's to change the number of results!
;;;WARNING: adding more results can exponentially increase search time
(define x 0)
(display (
              (begin (set! x 1) +) 
              x x x x
             ))
;;;the keyword SEARCH (always at the end of a program) tells maude to use search rather 
;;;than rewrite, for when multiple answers due to non-determinism is desired
SEARCH
