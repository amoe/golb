#lang scheme

(require (prefix-in xml: xml))

(provide xml date number transform)

(define identity (lambda (x y) x))

; A wyrm transform transforms from a value to an XML element.

(define (xml val key)
  (xml:read-xml/element (open-input-string val)))

(define (generic val key)
  (xml:make-element #f #f key '()
                    (list (xml:make-pcdata #f #f (format "~a" val)))))

(define date   generic)
(define number generic)

; fixme: verify that key exists, also that result is an xml:element?
(define (transform alist mapping)
  (map (lambda (pair)
         ((cdr (assoc (car pair) mapping))
          (cdr pair)
          (car pair)))
       alist))

; Breaking abstraction layers here, since wyrm operates on rows and has no
; business knowing about result sets.  The code has to go somewhere though.
; Next step is to code up a servlet using WYRM

(define (record-set->alists rs)
  (map (curry row->alist (first rs)) (rest rs)))

(define (row->alist cols row)
  (map (lambda (col row) (cons (string->symbol col) row)) cols row))
  
