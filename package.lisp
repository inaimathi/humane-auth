;;;; package.lisp
(defpackage #:humane-auth
  (:use #:cl)
  (:import-from #:split-sequence #:split-sequence)
  (:export #:new-account! #:sign-in))

