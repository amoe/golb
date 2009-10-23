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
   (mode:confirm
    (send/suspend (curry mode:create req)))))

(define (mode:confirm req)
  (make-response/full 200 "OK"
                      (current-seconds) #"text/plain"
                      '()
                      (list "Accepted form input")))


(define (mode:create req k-url)
  (let* ((cur (xslt:parse-stylesheet-file *create-template-path*))
         (xml (k-url->document k-url))
         (doc (xslt:parse-memory xml (string-length xml)))
         (res (xslt:apply-stylesheet cur doc #f)))
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      (make-response/full 200 "OK"
                          (current-seconds) #"text/html"
                          '()
                          (list r2)))))

(define (k-url->document k-url)
  (format "<?xml version=\"1.0\"?> <k-url>~a</k-url>"
          k-url))
