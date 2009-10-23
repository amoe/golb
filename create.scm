#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)

(require (prefix-in xslt: libxslt))

(define *create-template-path*         ; For some reason, libxslt wants this to
  "/var/plt-web-server/create.xsl")    ; be absolute.


(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (send/back
   (make-response/full 200 "OK"
                       (current-seconds) #"text/plain"   ; FIXME: change to real
                       '()
                       (list (mode:create)))))

(define (mode:create)
  (format "~s" (xslt:parse-stylesheet-file *create-template-path*)))
