;;; This shows the non-deterministic copying/sharing of quote
(define foo (lambda() '(1 2 3)))
(define x (foo))
(set-car! x 4)
(set-car! (cdr x) 5)
(set-car! (cddr x) 6)
(display x)
(define y (foo))
(display y)

;;; SEARCH keyword tells Maude to search for multiple outputs do to 
;;; non-determinism
SEARCH