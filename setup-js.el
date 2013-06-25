;;; setup-js.el --- Javascript setup / options

;;; Commentary:

;;; Code:
(flycheck-declare-checker flycheck-checker-jslint
  "jslint checker"
  :command '("jsl" "-process" source)
  :error-patterns '(("^\\(.+\\)\:\\([0-9]+\\)\: \\(SyntaxError\:.+\\)\:$" error)
                    ("^\\(.+\\)(\\([0-9]+\\)): \\(SyntaxError:.+\\)$" error)
                    ("^\\(.+\\)(\\([0-9]+\\)): \\(lint \\)?\\(warning:.+\\)$" warning)
                    ("^\\(.+\\)\:\\([0-9]+\\)\: strict \\(warning: trailing comma.+\\)\:$" warning))
  :modes 'js2-mode)

(defun my-after-init-js ()
  "After js init hook."
  (require 'flycheck)
  (add-to-list 'flycheck-checkers 'flycheck-checker-jslint))
(add-hook 'after-init-hook 'my-after-init-js)


(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))

(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings"
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          (search-forward "warning" nil t))))
      (run-with-timer 0.01 nil
                      (lambda (buf)
                        (bury-buffer buf)
                        (delete-window (get-buffer-window buf))
                        (kill-buffer buf)
                        (shell-command "growlnotify -m 'Success' -t 'PHP Compilation' --appIcon 'Emacs' &> /dev/null")
                        )
                      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

(provide 'setup-js)
;;; setup-js.el ends here
