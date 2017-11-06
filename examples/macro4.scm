(define-syntax or
   (syntax-rules ()
     ((_) #f)
     ((_ e) e)
     ((_ e1 e2 e3 ...)
      (let ((t e1)) (if t t (or e2 e3 ...))))))

(display (or (> 1 2) (> 3 4) (< 5 6)))

(display (or))

(display (or (< 1 2)))

(display (or (> 1 2) (> 3 4) (< 5 6)))

(display (or (> 1 2) (> 3 4) (> 5 6)))
