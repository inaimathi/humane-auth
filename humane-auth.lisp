;;;; humane-auth.lisp
(in-package #:humane-auth)

(setf *random-state* (make-random-state t))

(defparameter *users* (make-hash-table :test 'equal))

(defun hash (passphrase)
  (ironclad:byte-array-to-hex-string (iterated-digest 10000 :sha256 passphrase)))

(defun fresh-passphrase ()
  (let ((u-mod (/ (hash-table-count *users*) 100000)))
    (loop for num-words = (+ 2 (floor u-mod) (random (+ 2 (ceiling u-mod))))
       for passphrase = (format nil "~{~(~a~)~^-~}" (random-words num-words))
       unless (gethash passphrase *users*) do (return passphrase))))

(defun new-account! (&optional (user-data t))
  (let ((passphrase (fresh-passphrase)))
    (setf (gethash (hash passphrase) *users*) user-data)
    passphrase))

(defun sign-in (passphrase)
  (gethash (hash passphrase) *users*))
