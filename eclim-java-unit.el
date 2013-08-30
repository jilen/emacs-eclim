;;; eclim-java-unit.el --- Unit test support for emacs eclim

;;; Commentary:
;; Bring unit test utilities into Emacs

;;; Code:

(defun guess-test-name (name)
  (replace-regexp-in-string
   "\\.\\(\\w+\\)" "Test.\\1"
   (replace-regexp-in-string "src/main" "src/test" name))
  )

(guess-test-name "src/main/foo.java")

(defun touch-and-open (filename)
  (unless (file-exists-p (file-name-directory filename))
    (mkdir (file-name-directory filename)))
  (unless (file-exists-p filename) (write-region "" nil filename))
  (switch-to-buffer (find-file filename)))

(defun create-test-buffer (name)
  (touch-and-open (guess-test-name name))
  )

(defun eclim-test-case ()
  (interactive)
  (create-test-buffer (buffer-file-name)))


(provide 'eclim-java-unit)

;;; eclim-java-unit.el ends here
