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
  (let ((conn (connect 'jazmysql
                       "localhost" 3306 "root" "dr3ncr0m"
                       '#:schema "test")))
    (let ((id (string->number
               (bytes->string/utf-8
                (get-binding req #"id")))))
      (let ((ret (query conn "delete from test where id = ?c1"
                        (list (cons 'c1 id)))))
        (make-response/full 200 "OK"
                            (current-seconds) #"text/plain"
                            '()
                            (list (format "deleted row ~a (~a)" id ret)))))))
                          ;(list (format "~s" (second (row conn "select * from test where id = ?c1" (quasiquote ((c1 . (unquote id))))))))))))

(define (get-binding req id)
  (let ((ret (bindings-assq id (request-bindings/raw req))))
    (if ret
        (binding:form-value ret)
        (error 'get-binding "binding not found: ~a" id))))

