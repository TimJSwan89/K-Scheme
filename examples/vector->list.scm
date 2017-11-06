(define (vector->list v)
   (define aux 
         (lambda (v l n)
           (if (eq? n (- 1))
               l
               (aux v (cons (vector-ref v n) l) (- n 1))
           )
         )
    )
    (aux v '() (- (vector-length v) 1))
)
(display (vector->list '#(1 2 3)))
