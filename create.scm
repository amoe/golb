#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (stage2 
   (send/suspend
    (lambda (k-url)
      (make-response/full 200 "OK"
                          (current-seconds) #"text/plain"
                          '()
                          (list "Hello, world!\n" k-url))))))

(define (stage2 req)
  (send/back
   (make-response/full 200 "OK"
                       (current-seconds) #"text/plain"
                      '()
                      (list "Hello from stage2!\n"))))
