#lang scheme

(require web-server/http/request-structs)
(require web-server/http/response-structs)
(require web-server/servlet/web)
(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))
(require text/libxslt/suiker)

(require (prefix-in mapping: "mapping.scm"))
(require (prefix-in wyrm:    "wyrm.scm"))
(require (prefix-in util:    "util.scm"))

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
    (let ((rs (query conn "SELECT * FROM post")))
      (xsltproc-3 "/var/plt-web-server/tmpl/onepost.xsl"
                  (util:xml->string
                   (util:element->document
                    (util:arrayize
                     (wyrm:transform
                      (first (util:record-set->alists rs))
                      mapping:post))))))))
