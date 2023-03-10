;;; add-node-modules-path.el --- Add node_modules to your exec-path -*- lexical-binding: t; -*-

;; Copyright (C) 2016 Neri Marschik
;; This package uses the MIT License.
;; See the LICENSE file.

;; Author: Neri Marschik <marschik_neri@cyberagent.co.jp>
;; Version: 1.0
;; Package-Requires: ((emacs "24.1"))
;; Keywords: languages
;; URL: https://github.com/codesuki/add-node-modules-path

;;; Commentary:
;;
;; This file provides `add-node-modules-path', which runs `npm bin` and
;; and adds the path to the buffer local `exec-path'.
;; This allows Emacs to find project based installs of e.g. eslint.
;;
;; Usage:
;;     M-x add-node-modules-path
;;
;;     To automatically run it when opening a new buffer:
;;     (Choose depending on your favorite mode.)
;;
;;     (eval-after-load 'js-mode
;;       '(add-hook 'js-mode-hook #'add-node-modules-path))
;;
;;     (eval-after-load 'js2-mode
;;       '(add-hook 'js2-mode-hook #'add-node-modules-path))

;;; Code:

(defgroup add-node-modules-path nil
  "Put node_modules binaries into the variable `exec-path'."
  :prefix "add-node-modules-path-"
  :group 'environment)

;;;###autoload
(defcustom add-node-modules-path-debug nil
  "Enable verbose output when non nil."
  :type 'boolean
  :group 'add-node-modules-path)


(defun add-node-modules-path-debug-message (&rest args)
  "Show message with ARGS if `add-node-modules-path-debug' is non nil.
Return nil."
  (when add-node-modules-path-debug
    (apply #'message args)
    nil))

(defun add-node-modules-path-find-node-modules ()
  "Return absolute path to node_modules/.bin in directory hierarchy or nil."
  (let* ((project-dir (or (locate-dominating-file default-directory
                                                  "node_modules")))
         (directory (when project-dir
                      (concat project-dir "node_modules/.bin"))))
    (when (and directory
               (file-exists-p directory))
      (expand-file-name directory))))

;;;###autoload
(defun add-node-modules-path ()
  "Run `npm bin` command and add the path to the `exec-path`.
If `npm` command fails, it does nothing."
  (interactive)
  (let ((res (add-node-modules-path-find-node-modules)))
    (if (not res)
        (add-node-modules-path-debug-message
         "add-node-modules-path: node_modules/.bin not found in %s"
         default-directory)
      (make-local-variable 'exec-path)
      (add-to-list 'exec-path res)
      (add-node-modules-path-debug-message
       "add-node-modules-path: added `%s' to the variable `exec-path'" res))))


(provide 'add-node-modules-path)
;;; add-node-modules-path.el ends here