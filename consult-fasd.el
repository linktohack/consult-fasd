;;; consult-fasd.el --- Fasd integration for consult  -*- lexical-binding: t -*-

;; Copyright (C) 2022 Quang-Linh LE

;; Author: Quang-Linh LE <linktohack@gmail.com>
;; Keywords: fasd consult helm
;; Version: 0.0.2

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary

;; Fasd integration for consult. Basically helm-fasd alternative for
;; helm-less configuration with some improvement.
;;
;; The query can be filter first by fasd then a second time by consult the same ways as
;; consult-grep
;; For example: #Dow#cons may find the consult.el file in Downloads directory.

;;; Code

(require 'consult)

(defcustom consult-fasd-args
  "fasd -Rl"
  "Command line arguments for fasd, see `consult-fasd'.
The dynamically computed arguments are appended."
  :type 'string)

(defun consult--fasd-builder ()
  "Build command line given CONFIG and INPUT."
  (let* ((cmd (consult--build-args consult-fasd-args))
         (type 'basic))
    (lambda (input)
      (pcase-let* ((`(,arg . ,opts) (consult--command-split input))
                     (`(,re . ,hl) (funcall consult--regexp-compiler arg type t)))
          (when re
            (cons (append cmd re opts)
                  hl))))))

;;;###autoload 
(defun consult-fasd (&optional initial)
  "Search with `fasd' for files which match input given INITIAL input.

The input is treated literally such that fasd can take advantage of
the fasd database index. Regular expressions would often force a slow
linear search through the entire database. The fasd process is started
asynchronously, similar to `consult-grep'. See `consult-grep' for more
details regarding the asynchronous search."
  (interactive)
  (find-file (consult--find "Fasd: " (consult--fasd-builder) initial)))

(provide 'consult-fasd)
;;; consult-fasd.el ends here
