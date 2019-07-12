#lang scheme

(require "static.scm")

(provide interface-version
         timeout
         start)

(define interface-version 'v1)
(define timeout 64)

(define start (make-static-handler "post-new.xsl"))
