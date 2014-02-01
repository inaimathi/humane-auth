;;;; humane-auth.asd

(asdf:defsystem #:humane-auth
  :serial t
  :description "Implementation of the authentication system proposed in The Humane Interface book."
  :author "Inaimathi <leo.zovic@gmail.com>"
  :license "AGPL, as usual"
  :depends-on (#:cl-ppcre #:ironclad #:split-sequence)
  :components ((:file "package")
	       (:file "util")
               (:file "humane-auth")))

