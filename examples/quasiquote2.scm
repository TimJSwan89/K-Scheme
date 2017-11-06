;;;this showcases some of the features of quasiquote in k-scheme
;;;note that a car function result can be spliced, so long
;;;as it is a list... unquote-splicing is general
(define x `(((1 ,@(list 1 2))3)4))
(display `#(1 2 ,@(car x) 16 17 ,(+ 3 4 5 6)))
