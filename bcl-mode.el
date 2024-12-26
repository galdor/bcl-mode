;;; bcl-mode.el --- Major mode for BCL files. -*- lexical-binding: t -*-

;; Author: Nicolas Martyanoff <nicolas@n16f.net>
;; SPDX-License-Identifier: ISC
;; URL: https://github.com/galdor/bcl-mode
;; Version: 1.0.0
;; Package-Requires: ("emacs")

;;; Commentary:

;; A major mode for BCL (Block-based Configuration Language) files. See
;; https://github.com/galdor/bcl-specification for the official specification.
;;
;; Limitation: indentation will only work as expected if blocks follow the BCL
;; canonical representation, meaning that curly brackets are always at the end
;; of the line. So no inline blocks.

;;; Code:

(require 'cl-lib)
(require 'electric)

(defgroup bcl nil
  "Major mode for BCL files."
  :prefix "bcl-"
  :link '(url-link :tag "GitHub" "https://github.com/galdor/bcl-mode")
  :group 'external)

(defcustom bcl-indent-width 2
  "The number of space characters per indentation level."
  :type 'natnum
  :group 'bcl)

(defvar bcl-mode--syntax-table
  (let ((table (make-syntax-table)))
    ;; Name and symbol constituents
    (modify-syntax-entry ?_ "_" table)
    ;; Comments
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    ;; Blocks
    (modify-syntax-entry ?\{ "(}" table)
    (modify-syntax-entry ?\} "){" table)
    ;; Strings
    (modify-syntax-entry ?\" "\"" table)
    ;; Numbers
    (modify-syntax-entry ?. "_" table)
    table)
  "Syntax table for `bcl-mode'.")

(defvar bcl-mode--font-lock-keywords
  '(bcl-mode--font-lock-keywords-0
    bcl-mode--font-lock-keywords-1
    bcl-mode--font-lock-keywords-2)
  "Font Lock keywords.")

(defvar bcl-mode--font-lock-keywords-0
  nil
  "Level 0 Font Lock keywords. Does not fontify anything beyond the
default provided by Font Lock (comments and strings).")

(defvar bcl-mode--font-lock-keywords-1
  (append '(("\\_<true\\|false\\|null\\_>" . font-lock-constant-face)))
  "Level 1 Font Lock keywords. Fontifies pre-defined
symbols (booleans and null).")

(defvar bcl-mode--font-lock-keywords-2
  (append bcl-mode--font-lock-keywords-1
          '(("^[[:space:]]*\\([a-z][a-z0-9_]*\\)" 1 font-lock-keyword-face)))
  "Level 2 Font Lock keywords. Fontifies block types and entry names.")

(defun bcl-mode--indent-line ()
  "Indent the current line."
  (interactive)
  (save-excursion
    (indent-line-to
     (beginning-of-line)
     (let ((block-indent (bcl-mode--block-indent)))
       (if (null block-indent)
           0
         (let ((start (point)))
           (end-of-line)
           ;; The line containing the closing curly bracket is indented the same
           ;; way as the line containing the opening curly bracket.
           (if (looking-back "}[[:space:]]*" start)
               block-indent
             (+ block-indent bcl-indent-width))))))))

(defun bcl-mode--block-indent ()
  "Return the indentation of the current block or NIL if the current
line is not in a block (i.e. if it is top-level)."
  (save-excursion
    (save-match-data
      (beginning-of-line)
      (cl-do ((last-opening-bracket nil)
              (n -1)
              (done nil))
          ()
        (let ((bracket (search-backward-regexp "[{}][[:space:]]*$" nil t)))
          (cond
           ((null bracket)
            (cl-return nil))
           ((bcl-mode--comment-line-p)
            ;; Move to the end of the previous line to continue looking up at
            ;; the next iteration.
            (end-of-line 0))
           ((eq (char-after) ?{)
            (when (zerop (cl-incf n))
              (cl-return (bcl-mode--line-indent))))
           ((eq (char-after) ?})
            (cl-decf n))))))))

(defun bcl-mode--line-indent ()
  "Return the indentation of the current line."
  (save-excursion
    (beginning-of-line)
    (save-match-data
      (skip-chars-forward "[:space:]"))
    ;; If the current position is also the end of the line, it means the line is
    ;; made only of whitespace characters, in which case indentation is actually
    ;; zero.
    (let ((point (point))
          (column (current-column)))
      (end-of-line)
      (if (eql (point) point)
          0
        column))))

(defun bcl-mode--comment-line-p ()
  "Return a non-nil value if the current line is a comment line."
  (save-excursion
    (beginning-of-line)
    (looking-at "[[:space:]]*#" t)))

;;;###autoload
(define-derived-mode bcl-mode prog-mode "BCL"
  "Major mode for editing BCL configuration files."
  :group 'bcl
  :syntax-table bcl-mode--syntax-table

  ;; Comments
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local comment-auto-fill-only-comments t)

  ;; Highlighting
  (setq-local font-lock-defaults (list bcl-mode--font-lock-keywords nil t))

  ;; Indentation
  (setq-local tab-width bcl-indent-width)

  (setq-local indent-line-function 'bcl-mode--indent-line)

  (setq-local electric-indent-chars (append "{}" electric-indent-chars))

  ;; Misc
  (setq-local require-final-newline t))

(add-to-list 'auto-mode-alist '("\\.bcl\\'" . bcl-mode))

(provide 'bcl-mode)

;;; bcl-mode.el ends here
