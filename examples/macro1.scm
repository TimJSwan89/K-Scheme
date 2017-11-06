(define-syntax test
  (syntax-rules ()
    ((_ X Y Z) (list X Y Z))))

(display (test 1 2 3))
