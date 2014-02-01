(in-package #:humane-auth)

;;;; Dictionary-related
(defconstant +dict+ (coerce 
                     (with-open-file (s "/usr/share/dict/american-english")
                       (loop for line = (read-line s nil :eof) until (eql line :eof)
                          unless (cl-ppcre:scan "[^a-zA-Z]" line)
                          collect (string-downcase line)))
                     'vector))

(defun random-words (count &optional (dict +dict+))
  (loop repeat count
     collect (aref dict (random (length dict)))))

;;;; Hash-related
(defmethod iterated-digest ((count integer) (digest-spec symbol) (message string))
  (assert (> count 0))
  (loop with res = (ironclad:ascii-string-to-byte-array message)
     repeat count do (setf res (ironclad:digest-sequence digest-spec res))
     finally (return res)))
