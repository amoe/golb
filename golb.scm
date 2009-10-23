#lang scheme

(require web-server/http/response-structs)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (make-response/basic 403 "Forbidden"
                       (current-seconds) #"text/plain"
                       '()))
                        
                       
