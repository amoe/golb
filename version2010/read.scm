#lang scheme

(require web-server/http/request-structs)
(require web-server/http/response-structs)
(require web-server/servlet/web)
(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))
(require text/libxslt/suiker)

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (send/back (make-response/full 200 "OK"
                                 (current-seconds) #"application/xhtml+xml"
                                 '()
                                 (list (serve req)))))
(define (serve req)
  (let ((conn (connect 'jazmysql "localhost" 3306 "golb" "golb"
                       '#:schema "golb")))
    (let ((rs (query conn "SELECT post FROM post WHERE id = ?i"
                   (list (cons 'i (get-binding req #"id"))))))
      (xsltproc-3 "/var/plt-web-server/tmpl/read.xsl"
                  (first (first (rest rs)))))))

                                  ;(xsltproc-2 
                                  ; "/var/plt-web-server/tmpl/read.xsl"
                                  ; "/home/amoe/code/golb/demo.xml")))))


(define (get-binding req id)
  (let ((ret (bindings-assq id (request-bindings/raw req))))
    (if ret
        (binding:form-value ret)
        (error 'get-binding "binding not found: ~a" id))))

