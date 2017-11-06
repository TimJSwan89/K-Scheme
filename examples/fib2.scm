;;;this is a function which generates the fibonacci numbers
;;;using recursion
(define (fib n)
  (if (or (= 1 n) (= 2 n))
      1
      (+ (fib (- n 1))(fib (- n 2)))))
(display (fib 4))
(display (fib 8))
