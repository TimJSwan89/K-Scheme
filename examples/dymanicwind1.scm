(define c #f)
(call/cc (lambda(k)
   (dynamic-wind 
       (lambda() (display 1))
       (lambda() (set! c k)(display 2))
       (lambda() (display 3))
   ))
)
(c #f)  


