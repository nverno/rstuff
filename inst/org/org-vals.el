;;; org-vals.el --- 
;; Filename: org-vals.el
;; Description: Org publish options
;; Author: Noah Peart
;; Created: Mon Oct 26 21:13:26 2015 (-0400)
;; Last-Updated: Mon Feb  1 15:54:56 2016 (-0500)
;;           By: Noah Peart
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ox-publish)

(setq appname "moosedata")
(setq projdir (file-name-directory load-file-name))
(setq htmldir (concat projdir "html/"))
(setq theme-file "theme-bigblow.setup")
(setq preamble (prep-org (get-string-from-file theme-file)))

(setq org-publish-project-alist
      `(
	("orgfiles"
	 :auto-sitemap t
	 :html-head ,preamble
	 :sitemap-title "Sitemap"
	 :base-directory ,projdir
	 :base-extenstion "org"
	 :publishing-directory ,htmldir
	 :publishing-function org-html-publish-to-html
	 :recursive t
	 :html-link-home "sitemap.html"
	 :auto-preamble t)

	(,appname :components ("orgfiles"))))



