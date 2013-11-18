;;; auto-indent-test.el --- Auto-indent tests
;; 
;; Filename: auto-indent-test.el
;; Description: 
;; Author: Matthew L. Fidler
;; Maintainer: 
;; Created: Sat Aug 24 23:05:03 2013 (-0500)
;; Version: 
;; Package-Requires: ()
;; Last-Updated: 
;;           By: 
;;     Update #: 0
;; URL: 
;; Doc URL: 
;; Keywords: 
;; Compatibility: 
;; 
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;; 
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Change Log:
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

(require 'ert)

(defun auto-indent-test ()
  "Test auto-indent-mode issues."
  (interactive)
  (ert "^auto-indent-test-"))

(defun auto-indent-emacs-exe ()
  "Get the Emacs executable for testing purposes."
  (let* ((emacs-exe (invocation-name))
        (emacs-dir (invocation-directory))
        (full-exe (expand-file-name emacs-exe emacs-dir)))
    (symbol-value 'full-exe)))

(ert-deftest auto-indent-test-kill-line ()
  "When in some mode, e.g. sh-mode, if point is on a blank line, like following: (| indicate cursor)
HISTSIZE=1000
|
HISTFILESIZE=2000

if press C-k once, invoke kill-line-or-kill-region, it will kill HISTFILESIZE=2000 too.
 it will look like this.
HISTFILESIZE=2000
|.

See Issue #21"
  (with-temp-buffer
    (insert "HISTSIZE=1000

HISTFILESIZE=2000")
    (sh-mode)
    (goto-char (point-min))
    (forward-line 1)
    (call-interactively 'kill-line)
    (message (buffer-string))
    (should (looking-at "HISTFILESIZE=2000"))))

(ert-deftest auto-indent-test-kill-line-extra-space ()
  "Test Issue #31.
When reach (point-min) or (point-max), invoke kill-line command, will add some whitespace before line beginning after indent.

reproduce:

Create a null file named 1.el.
add some text.

\(abcd\)|
press C-k. will result

 (abcd)I"
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "(abcd)")
    (call-interactively 'kill-line)
    (goto-char (point-min))
    (should (looking-at "(abcd)"))))

(provide 'auto-indent-test)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-indent-test.el ends here
