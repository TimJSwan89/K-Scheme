;;;This is a small example of call/cc originally designed to schowcase
;;;how environments are stored with continuations. Notice
;;;how interleaved evaluation of foo results in
;;;a change in the output of (n 4)
(define n #f)
(define foo (lambda(val) (+ val (call/cc (lambda(x) (set! n x) 3)))))
(display (foo 3))
(n 4)
(display (foo 4))
(n 4)
