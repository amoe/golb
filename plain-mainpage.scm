#lang scheme

(require web-server/http/response-structs)
(require srfi/19)

(require (planet bzlib/dbi)
         (planet bzlib/dbd-jazmysql))

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define *post-template*
"Title: ~a
Date: ~a

~a")


(define (start req)
  (let ((conn (connect 'jazmysql "localhost" 3306 "golb" "golb"
                       '#:schema "golb")))
    (make-response/full 200 "OK"
                        (current-seconds) #"text/plain"
                        '()
                        (serve-plain-mainpage conn))))

(define (serve-plain-mainpage conn)
  (let* ((rs (get-posts conn))
         (posts (record-set->alists rs)))
    (list
     "I'm listing the posts from the database.\n\n\n"
     (string-join (map post->string posts)
                  (string #\newline #\newline)))))

(define (post->string post)
  (let ((date (cdr (assoc "date_" post))))
    (assert-valid-date date)
    (format *post-template*
            (cdr (assoc "title" post))
            (date->string (timestamp->date (cdr (assoc "date_" post))
                                           (cdr (assoc "time_" post))))
            (cdr (assoc "body" post)))))
  

(define (get-posts conn)
  (query conn "SELECT * FROM post" '()))

(define (record-set->alists rs)
  (map (curry row->alist (first rs)) (rest rs)))

(define (row->alist cols row)
  (map cons cols row))
  
(define (assert-valid-date d)
  (when (or (zero? (date-day d))
            (zero? (date-month d)))
    (error 'assert-valid-date "invalid date: ~s" d)))

; Pretend we have ISO SQL TIMESTAMP data type.  We combine the ISO standard
; DATE and TIME fields from the DB into 1 SRFI-19 date structure.
(define (timestamp->date date time)
  (assert-valid-date date)
  (time-utc->date (add-duration (date->time-utc date) time)))
   
