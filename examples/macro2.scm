(define-syntax test
  (syntax-rules ()
    ((_ (X)...) (list X ...))))

(display (test (1) (2) (3)))
