;;;This is an example from R5RS
(display
(let ((name1 'x)
      (name2 'y))
  `(a `(b ,,name1 ,',name2 d) e)) 
)
