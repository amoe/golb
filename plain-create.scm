#lang scheme

(require web-server/http/request-structs)
(require web-server/http/response-structs)
(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))

(require srfi/19)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (let ((conn (connect 'jazmysql "localhost" 3306 "golb" "golb"
                       '#:schema "golb")))
    (make-response/full 200 "OK"
                       (current-seconds) #"text/plain"
                       '()
                       (serve-page req conn))))

(define (serve-page req conn)
  (list "Hello, world!"
        (format "~s"
                (query conn "INSERT INTO post (title, body, date_) VALUES (?t, ?b, ?d)"
                       (list (cons 't (get-binding req  #"title"))
                             (cons 'b (get-binding req  #"body"))
                             (cons 'd (current-date)))))))
        

(define (get-binding req id)
  (let ((ret (bindings-assq id (request-bindings/raw req))))
    (if ret
        (binding:form-value ret)
        (error 'get-binding "binding not found: ~a" id))))

