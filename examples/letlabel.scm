;;;let label is still currently implemented with the keyword letl, it is actually
;;;defined via macro in the prelude (hence the differing name)
(letl f ((n 0))
   (if (= n 10)
       (display "done")
       (begin (display n) (f (+ n 1)))
    )
)