(call-with-values
  (lambda() (values `(3 ,(+ 3 4) (3 . ( 4 . 4)))))
  display
)
