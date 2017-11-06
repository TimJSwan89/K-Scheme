(define-syntax p-or-m
  (syntax-rules (plus times)
    ((_ plus x ...) (+ x ...))
    ((_ times x ...) (* x ...))))

(display (p-or-m plus 1 2 3 4))
(display (p-or-m times 1 2 3 4))
(display (+ (p-or-m plus 1 2 3 4) (p-or-m times 1 2 3 4)))
