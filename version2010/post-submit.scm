#lang scheme

(require web-server/http/request-structs)
(require web-server/http/response-structs)
(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (make-response/full 200 "OK"
                       (current-seconds) #"text/plain"
                       '()
                       (serve req)))

(define (serve req)
  (let ((conn (connect 'jazmysql "localhost" 3306 "golb" "golb"
                       '#:schema "golb")))
    (let ((effect (query conn "INSERT INTO post (post) VALUES (?t)"
           (list (cons 't (string-append "<entry>"
                                         (bytes->string/utf-8
                                          (get-binding req #"body"))
                                         "</entry>"))))))
      (list (format "inserted: ~s\n" (effect-insert-id effect))))))
  
(define (get-binding req id)
  (let ((ret (bindings-assq id (request-bindings/raw req))))
    (if ret
        (binding:form-value ret)
        (error 'get-binding "binding not found: ~a" id))))

