;;;this is a function which generates the fibonacci numbers
;;;using a do loop
(define fib
  (lambda(n)
    (if (= n 0)
        0
        (do ((i n (- i 1)) (a1 1 (+ a1 a2)) (a2 0 a1))
            ((= i 1) a1)))))
(display (fib 4))
(display (fib 8))
