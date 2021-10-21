;;; liquid-mode.el --- Emacs major mode for Liquid

;; Author: shigemk2
;; URL: https://github.com/shigemk2/liquid-mode
;; Package-Requires:
;; Keywords: liquid
;; Version: 0.1
;; MIT License
;;
;; Copyright (c) 2019 Michihito Shigemura
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Summary:

;; This program is Emacs major mode for Liquid
;;; Usage:
;;; NOTES:
;;;   - two syntax matching types:
;;;     1) "regex" . font-lock-name
;;;     2) "regex" (capture-group-id font-lock-name)
;;;   - variable name regex: \\(?:\\w\\|\\.\\|_\\)+
;;;
;;; TODO:
;;;   - strings can be in single quotes
;;;   - detect string vs. object value types
;;;   - detect boolean operators (and|or)
;;;   - add groups for cycle tags
;;;   - for:
;;;     - add limit:n, offset:n
;;;     - add reversed
;;;     - add support for ranges

(setq liquidKeywords
      '(
	;;; core stuff
	("{%\\|%}\\|{{\\|}}" . font-lock-comment-face) ;;; liquid tag delimiters
	("{%\s*\\(assign\\|capture\\|endcapture\\|for\\|endfor\\|if\\|endif\\|comment\\|endcomment\\|else\\|elsif\\|unless\\|endunless\\|case\\|when\\|endcase\\|cycle\\)" (1 font-lock-keyword-face)) ;;; liquid construct tags
	("forloop" . font-lock-keyword-face)
	("forloop.\\(length\\|index0\\|index\\|rindex0\\|rindex\\|first\\|last\\)" (1 font-lock-variable-name-face))
	("{%\s*\\(?:assign\\|capture\\|for\\|if\\|unless\\|case\\|when\\)\s+\\(\\(?:\\w\\|\\.\\|_\\)+\\)" (1 font-lock-variable-name-face)) ;;; variable after assign|capture|for|if

	("{{\s*\\(\\(?:\\w\\|\\.\\)+\\)" (1 font-lock-variable-name-face)) ;;; variable/object being outputted

	;;; filter stuff (hack, only supports 2 chained filters)
	("\s+|\s+" . font-lock-comment-face) ;;; liquid tag delimiters
	("{{\s*\\(?:\\w\\|\\.\\)+\s+|\s+\\(\\w+\\)" (1 font-lock-type-face)) ;;; variable after assign|capture|for|if
	("{{\s*\\(?:\\w\\|\\.\\)+\s+|\s+\\w+\s+|\s+\\(\\w+\\)" (1 font-lock-type-face)) ;;; variable after assign|capture|for|if

	;;; if/else stuff
	("{%\s*\\(?:if\\|unless\\)\s+\\(?:\\w\\|\\.\\)+\s+\\(contains\\|>\\|<\\|==\\|!=\\)" (1 font-lock-keyword-face)) ;;; liquid operators

	;;; for loop stuff
	("{%\s*for\s+\\w+\s+\\(in\\)" (1 font-lock-keyword-face)) ;;; the 'in' in "for temp in collection"
	("{%\s*for\s+\\w+\s+in\s+\\(\\(?:\\w\\|\\.\\|_\\)+\\)" (1 font-lock-variable-name-face)) ;;; the 'collection' in "for temp in collection"
	)
      )
(define-derived-mode liquid-mode web-mode
  (setq font-lock-defaults '(liquidKeywords))
  (setq mode-name "liquid mode")
  )
(add-to-list 'auto-mode-alist '("\\.liquid$" . liquid-mode))
(provide 'liquid-mode)
