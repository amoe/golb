#lang scheme

(require web-server/http/response-structs)
(require web-server/servlet/web)

(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))

(require "config.scm")

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

; Warning: exceptions from this stage won't be wrapped in a nice
; fatals-to-browser type handler.
(define *db-handle* (connect 'jazmysql
                             *database-host* *database-port*
                             *database-user* *database-pass*
                             '#:schema *database-name*))

(define (start req)
  (let ((ret (query *db-handle* "SELECT * FROM post" '())))
    (send/back (make-response/full 200 "OK"
                                   (current-seconds) #"text/plain"
                                   '()
                                   (list "Hello, world!\n"
                                         (format "~s" (record-set->alists ret))))))
  (disconnect *db-handle*))

(define (record-set->alists rs)
  (map (curry row->alist (first rs)) (rest rs)))

(define (row->alist cols row)
  (map cons cols row))
  
