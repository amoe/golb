#lang scheme

(require web-server/http/request-structs)
(require web-server/http/response-structs)
(require srfi/19)

(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))

(provide interface-version
         timeout
         start)

(define *post-template*
"Title: ~a
Date: ~a

~a")

(define interface-version 'v1)
(define timeout 64)

(define (start req)
  (let ((conn (connect 'jazmysql "localhost" 3306 "golb" "golb"
                       '#:schema "golb")))
    (make-response/full 200 "OK"
                        (current-seconds) #"text/plain"
                        '()
                        (serve-page req conn))))

(define (serve-page req conn)
  (let ((id (get-binding req #"id")))
    (list 
     (post->string (first
                    (record-set->alists
                     (query conn "SELECT * FROM post WHERE id = ?blah"
                            (list (cons 'blah id)))))))))

(define (get-binding req id)
  (let ((ret (bindings-assq id (request-bindings/raw req))))
    (if ret
        (binding:form-value ret)
        (error 'get-binding "binding not found: ~a" id))))


(define (record-set->alists rs)
  (map (curry row->alist (first rs)) (rest rs)))

(define (row->alist cols row)
  (map cons cols row))
  
(define (post->string post)
  (let ((date (cdr (assoc "date_" post))))
    (assert-valid-date date)
    (format *post-template*
            (cdr (assoc "title" post))
            (date->string (timestamp->date (cdr (assoc "date_" post))
                                           (cdr (assoc "time_" post))))
            (cdr (assoc "body" post)))))
  
(define (assert-valid-date d)
  (when (or (zero? (date-day d))
            (zero? (date-month d)))
    (error 'assert-valid-date "invalid date: ~s" d)))

; Pretend we have ISO SQL TIMESTAMP data type.  We combine the ISO standard
; DATE and TIME fields from the DB into 1 SRFI-19 date structure.
(define (timestamp->date date time)
  (assert-valid-date date)
  (time-utc->date (add-duration (date->time-utc date) time)))
