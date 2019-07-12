#lang scheme

; Generalized utilities.

(require (prefix-in xml: xml))

(provide record-set->alists arrayize xml->string element->document)

(define (record-set->alists rs)
  (map (curry row->alist (first rs)) (rest rs)))

(define (row->alist cols row)
  (map (lambda (col row) (cons (string->symbol col) row)) cols row))
  
(define (arrayize elements)
  (xml:make-element
   #f #f 'array '()
   elements))

(define (element->document elt)
  (xml:make-document
   (xml:make-prolog '() #f)
   elt
   '()))

(define (xml->string elt)
  (let ((os (open-output-string)))
    (xml:write-xml elt os)
    (get-output-string os)))

