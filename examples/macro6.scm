(define-syntax nlet
  (syntax-rules ()
    ((_ ((X E) ...) B ...) ((lambda (X ...) B ...) E ...))))

(nlet ((a 5) (b 6)) (display (+ a b)) (display (* a b)))
