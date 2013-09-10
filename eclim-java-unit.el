;;; eclim-java-unit.el --- Unit test support for emacs eclim

;;; Commentary:
;; Bring unit test utilities into Emacs

;;; Code:
(require 'compile)
(require 'eclim)
(require 's)
(define-key eclim-mode-map (kbd "C-t s") 'eclim-test-switch)
(define-key eclim-mode-map (kbd "C-t r") 'eclim-run-test)

(defun guess-test-name (name)
  (replace-regexp-in-string
   "\\.\\(\\w+\\)" "Test.\\1"
   (replace-regexp-in-string "src/main" "src/test" name)))

(guess-test-name "src/main/foo.java")

(defun touch-and-open (filename)
  (unless (file-exists-p (file-name-directory filename))
    (mkdir (file-name-directory filename)))
  (unless (file-exists-p filename) (write-region "" nil filename))
  (switch-to-buffer (find-file filename)))

(defun eclim-run-test ()
  (interactive)
  (if(not(string= major-mode "java-mode"))
      (message "Not a java class"))
  (compile (concat eclim-executable " -command java_junit -p " eclim--project-name " -t " (eclim-package-and-class))))


(defun create-test-buffer (name)
  (touch-and-open (guess-test-name name)))

(defun find-file-of-test (name)
  (replace-regexp-in-string "src/test" "src/main"
                            (replace-regexp-in-string "Test\\.java" ".java" name )))
(defun switch-to-origin (name)
  (switch-to-buffer (find-file (find-file-of-test name))))
;; switch to test or original class
(defun eclim-test-switch ()
  (interactive)
  (if (string-match-p "\\Test.java$" (buffer-file-name))
      (switch-to-origin (buffer-file-name)) (create-test-buffer (buffer-file-name))))

(provide 'eclim-java-unit)

;;; eclim-java-unit.el ends here
