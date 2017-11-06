;;;Note how the end guard is executed despite the early exit 
;;;due to the application of the continuation k
(call/cc (lambda(k)
   (dynamic-wind 
       (lambda() (display 1))
       (lambda() (k #f) (display 2))
       (lambda() (display 3))
   ))
)


