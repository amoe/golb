#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)

(require (prefix-in xslt: libxslt))
(require (prefix-in xml: xml))

(provide interface-version
         timeout
         start)

(define *read-template-path* "/var/plt-web-server/read.xsl")

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (make-response/full 200 "OK"
                       (current-seconds) #"application/xhtml+xml"
                       '()
                       (list
                        (process-template *read-template-path*
                                          (entry->xml (get-entries))))))

; MODEL CODE

(define (get-entries)
  (with-handlers ((exn:fail? (lambda args "nowt")))
    (file->value "main.dat")))

(define (entry->xml body)
  (xml->string
   (xml:make-document
    (xml:make-prolog '() #f)
    (xml:make-element #f #f 'entry '()
                      (list (xml:make-pcdata #f #f
                                             (escape-string-for-xml body))))
    '())))

; DISPLAY CODE

(define (process-template template-path input-xml)
  (let* ((cur (xslt:parse-stylesheet-file template-path))
         (doc (xslt:parse-memory input-xml (string-length input-xml)))
         (res (xslt:apply-stylesheet cur doc #f)))
    (let-values (((r1 r2 r3) (xslt:save-result-to-string res cur)))
      r2)))

(define (process-static-template template-path)
  (process-template template-path
                           "<?xml version=\"1.0\"?> <root/>"))

(define (xml->string elt)
  (let ((os (open-output-string)))
    (xml:write-xml elt os)
    (get-output-string os)))

(define (escape-string-for-xml str)
  (let ((os (open-output-string)))
    (xml:write-xml/content (xml:xexpr->xml str) os)
    (get-output-string os)))
