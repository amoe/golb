#lang scheme

(require (prefix-in wyrm: "wyrm.scm"))

(provide post)

(define post
  (quasiquote ((post . (unquote wyrm:xml))
               (date . (unquote wyrm:date))
               (id   . (unquote wyrm:number)))))
