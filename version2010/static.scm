#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)
(require text/libxslt/suiker)

(provide make-static-handler)

(define *template-path* "/var/plt-web-server/tmpl")

(define (make-static-handler template-name)
  (lambda (req)
    (send/back (make-response/full 200 "OK"
                                   (current-seconds) #"application/xhtml+xml"
                                   '()
                                   (list
                                    (xsltproc (build-path *template-path*
                                                          template-name)))))))
