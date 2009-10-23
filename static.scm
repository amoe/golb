#lang scheme

(require web-server/http/response-structs)
(require web-server/http/request-structs)
(require web-server/servlet/web)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (let ((path (get-binding req #"path")))
    (send/back
     (make-response/full 200 "OK"
                       (current-seconds) #"application/xhtml+xml"
                       '()
                       (list
                        (file->bytes (bytes->path path)))))))

(define (get-binding req id)
  (binding:form-value
   (bindings-assq id (request-bindings/raw req))))
