#lang racket

;Creates static list of numbers and operators
(define f null)

;static list of operands
(define op (list '+ '+ '+ '+ '+ '- '- '- '- '- '- '* '* '* '* '*  '/ '/ '/ '/ '/))



; Reverse Polish Notation function, Sourced from https://rosettacode.org/wiki/Parsing/RPN_calculator_algorithm#Racket

(define (calculate-RPN expr)
  (for/fold ([stack '()]) ([token expr])
    ;(printf "~a\t -> ~a~N" token stack) ; Uncomment to see workings, not recommended for long lists.
    (match* (token stack)
     [((? number? n) s) (cons n s)]
     [('+ (list x y s ___)) (cons (+ x y) s)]
     [('- (list x y s ___)) (cons (- y x) s)]
     [('* (list x y s ___)) (cons (* x y) s)]
     [('/ (list x y s ___)) (if (= y 0)
                                (cons 0 s)
                                (if (= x 0)
                                    (cons 0 s)
                                    (cons (/ x y) s)))]
     [(x s) (error "calculate-RPN: Cannot calculate the expression:" 
                   (reverse (cons x s)))])))

;How validation works.

;Create stack r starting at 0.
;Pass through expression.
   ;If next element in expression is number, increase r by 1.
   ;If next element in expression is operand, check if r > 1.
      ;If r > 1, decrease r by 1 and move on.
      ;if r < 2, expression is not rpn-compatible. Move on to next expression
;Stack is rpn-compatible if r = 1.
 

(define (valid-rpn? e[r 0])
  (if(null? e)
     (if (= r 1)
         #t
         #f)
     (if(number? (car e) )
        (valid-rpn? (cdr e) (+ r 1))
        (if(> r 1)
           (valid-rpn? (cdr e) (- r 1))
           #f))))



(define (sum x t)
  (if (null? x)
      0
      (cond [(valid-rpn? (car x))
             (cond [(eqv? (car (calculate-RPN (car x))) t)
                    (writeln (car x))]
                   [else (sum (cdr x) t)])]
            [else (sum (cdr x) t)])))


(define (mklist l (s 2) (g null))
  (cond ((<= s (length l))
         (mklist l (+ s 1)
                 (append g (cartesian-product (combinations l s) (remove-duplicates(combinations op (- s 1)))))))
        (else  g)))

(define (rpn l t)
  (set! f (mklist l)) (makep f t))

(define (makep l t)
  (cond [(null? l) (write 'Target:) t]
      [else (sum (permutations (flatten (car l))) t)(makep (cdr l) t)]))


'ready


