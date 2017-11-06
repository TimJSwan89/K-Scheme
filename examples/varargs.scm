(define (create-vector . l)
    (letrec ((aux (lambda (l v n)
               (if (eq? l '())
                 v
                (begin (vector-set! v n (car l)) (aux (cdr l) v (+ n 1)))
               ))))
      (aux l (make-vector (length l)) 0)
    )
)
(display (create-vector 1 2 3))
(display (create-vector '(1 2 3) '#[4] 'x))
               
