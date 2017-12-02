#lang racket

(require racket/file)
(require math/base)

(define file_text
  (map (lambda (line)
    (map string->number (string-split line))) (file->lines "input.txt" #:mode 'text)))

(define (val n) n)

(define (difference lst)
  (- (argmax val lst) (argmin val lst)))

(define (divide_if_no_remainder pair)
  (match-define (list a b) pair)
  (if (equal? 0 (modulo a b))
    (/ a b)
    0))

(define (divide lst)
  (sum (map divide_if_no_remainder (map ((curryr sort) >) (combinations lst 2)))))

(sum (map difference file_text))
(sum (map divide file_text))
