;;; bcl-mode.el --- Major mode for BCL files. -*- lexical-binding: t -*-

;; Author: Nicolas Martyanoff <nicolas@n16f.net>
;; SPDX-License-Identifier: ISC
;; URL: https://github.com/galdor/bcl-mode
;; Version: 1.0.0
;; Package-Requires: ("emacs" "cl-lib")

;;; Commentary:

;; A major mode for BCL (Block-based Configuration Language) files. See
;; https://github.com/galdor/bcl-specification for the official specification.

;;; Code:

(defgroup bcl nil
  "Major mode for BCL files."
  :prefix "bcl-"
  :link '(url-link :tag "GitHub" "https://github.com/galdor/bcl-mode")
  :group 'external)

(provide 'bcl)

;;; bcl-mode.el ends here
