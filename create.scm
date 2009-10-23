#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)

(require (prefix-in xslt: libxslt))
(require (prefix-in xml: xml))

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
         (xml (k-url->xml k-url))
         (doc (xslt:parse-memory xml (string-length xml)))
         (res (xslt:apply-stylesheet cur doc #f)))
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      (make-response/full 200 "OK"
                          (current-seconds) #"application/xhtml+xml"
                          '()
                          (list r2)))))

(define (k-url->xml k-url)
  (xml->string
   (xml:make-document
    (xml:make-prolog '() #f)
    (xml:make-element #f #f 'k-url '()
                      (list (xml:make-pcdata #f #f
                                             (escape-string-for-xml k-url))))
    '())))

(define (xml->string elt)
  (let ((os (open-output-string)))
    (xml:write-xml elt os)
    (get-output-string os)))

(define (escape-string-for-xml str)
  (let ((os (open-output-string)))
    (xml:write-xml/content (xml:xexpr->xml str) os)
    (get-output-string os)))
