#lang scheme

(require web-server/http/request-structs)
(require web-server/http/response-structs)
(require web-server/servlet/web)
(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))
(require text/libxslt/suiker)

(require (prefix-in xml: xml))

(provide interface-version
         timeout
         start)

; We have 1 problem:
; Our dumb ORM simply transforms the result set into an alist, which is then
; transformed to XML as a string.
; However, we want a nicer treatment of the XML so that it can remain XML in
; the result tree when it gets to the template.  At the moment it ends up
; escaped and we can't process it.
; To do this, we'll have to effectively define an annotation to the DB schema
; that specifies how to transform each column.  That is, it specifies a
; transform from (row, data) pair (where DATA is the result of a bzlib/dbi call)
; to an xml:element.
; The WYRM - Weird Yuseless Relational Mapper.
; Once we have this, we will be able to remove the hacks around integer values,
; and also the use of disable-output-escaping.

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
    (let ((rs (query conn "SELECT * FROM post LIMIT 2,2")))
      (xsltproc-3 "/var/plt-web-server/tmpl/home.xsl"
                  (xml->string
                   (element->document
                    (arrayize
                     (map alist->xml (record-set->alists rs)))))))))
      ;(xsltproc "/var/plt-web-server/tmpl/home.xsl"))

(define (arrayize elements)
  (xml:make-element
   #f #f 'array '()
   elements))

(define (alist->xml al)
   (xml:make-element
     #f #f 'object '()
     (map (lambda (pair)
            (xml:make-element #f #f (string->symbol (car pair))
                              '()
                              (list
                                (xml:make-pcdata
                                  #f #f  (if (number? (cdr pair))
                                             (number->string (cdr pair))
                                             (cdr pair))))))
                                                      
          al)))

(define (element->document elt)
  (xml:make-document
   (xml:make-prolog '() #f)
   elt
   '()))
                                                                

(define (xml->string elt)
  (let ((os (open-output-string)))
    (xml:write-xml elt os)
    (get-output-string os)))

(define (escape-string-for-xml str)
  (if (number? str)
      (escape-string-for-xml (number->string str))
      (let ((os (open-output-string)))
        (xml:write-xml/content (xml:xexpr->xml str) os)
        (get-output-string os))))


(define (record-set->alists rs)
  (map (curry row->alist (first rs)) (rest rs)))

(define (row->alist cols row)
  (map cons cols row))
  
