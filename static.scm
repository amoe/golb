#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define *xhtml-path* "skeleton.xhtml")

(define (start req)
  (send/back
   (make-response/full 200 "OK"
                       (current-seconds) #"application/xhtml+xml"
                       '()
                       (list (file->bytes *xhtml-path*)))))
