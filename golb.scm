#lang scheme

(require web-server/http/response-structs)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (make-response/full 200 "OK"
                       (current-seconds) #"text/plain"
                       '()
                       '("Hello, world!\n")))
