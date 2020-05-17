(require 'ox-html)
(require 'cl-lib)

(setq org-html-htmlize-output-type nil) ; disable emacs rendered syntax highlight

(org-export-define-derived-backend 'notefy-html 'html
                                   :translate-alist '((template . nil)
                                                      (src-block . codefy-src-block)))

(defun replace-pre-with-pre-and-code-block (pre-string)
  (let* ((codefied-opening-string (replace-regexp-in-string
                                   "^<pre class=\"src src-"
                                   "<pre><code class=\"src language-"
                                   pre-string))
         (codefied-opening-string (replace-regexp-in-string
                                   "</pre>"
                                   "</code></pre>"
                                   codefied-opening-string)))
    codefied-opening-string))

(defun codefy-src-block (src-block contents info)
  (let* ((pre-string (org-html-src-block src-block contents info)))
    (replace-pre-with-pre-and-code-block pre-string)))

(defun org-export-to-notefy-html
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to a notefy div."
  (let* ((extension (concat "." org-html-extension))
         (file (org-export-output-file-name extension subtreep)))
    (org-export-to-file
        'notefy-html file subtreep visible-only body-only ext-plist)))
