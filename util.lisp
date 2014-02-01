(in-package #:humane-auth)

;;;; Part of Speech DB
(defparameter char->label
  (list #\N :noun
	#\p :plural
	#\h :noun-phrase
	#\V :verb
	#\t :transitive-verb
	#\i :intransitive-verb
	#\A :adjective
	#\v :adverb
	#\C :conjunction
	#\P :preposition
	#\! :interjection
	#\r :pronoun
	#\D :definite-article
	#\I :indefinite-article
	#\o :nominative))

(defparameter parts-of-speech (make-hash-table))

(defun line->entry! (line)
  (destructuring-bind (word labels) (split-sequence #\tab line)
    (loop for l across labels
       do (push word (gethash (getf char->label l) parts-of-speech)))))

(with-open-file (s "part-of-speech.txt")
  (loop for ln = (read-line s nil nil)
     while ln do (line->entry! ln)))

(loop for k being the hash-keys of parts-of-speech
   for v being the hash-values of parts-of-speech
   do (setf (gethash k parts-of-speech) (coerce v 'vector)))

(defun pick (type)
  (let ((words (gethash type parts-of-speech)))
    (aref words (random (length words)))))

(defun phrase (word-types)
  (loop for w in word-types collect (pick w)))

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
