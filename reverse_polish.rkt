#lang racket
(define (f? v)
  (define l '())  
  (cond    
    [(empty? v) "empty list"] 
    [(for ([i v]) 
       (cond [(number? i) (set! l (cons i l))]
             [(match i
                           ['+ (set! l (cons (apply + (reverse (take l 2))) (cdr (cdr l))))]
                           ['- (set! l (cons (apply - (reverse (take l 2))) (cdr (cdr l))))]
                           ['* (set! l (cons (apply * (reverse (take l 2))) (cdr (cdr l))))]
                           )
                         ]
                        )
                     )]
    
  )
 (print l)
  )
  
