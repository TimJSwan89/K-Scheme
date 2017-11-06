(define-syntax test
  (syntax-rules ()
    ((_ (X) ...) (list (list X) ...))))

(display (test (1) (2) (3) (4)))
(display (test (#(1 2 3))))