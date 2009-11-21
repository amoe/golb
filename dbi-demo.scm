#lang scheme

(require (planet bzlib/dbi)
         (planet bzlib/dbd-jsqlite))


(define handle (connect 'jsqlite ':temp:))

handle

