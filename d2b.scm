#!/usr/bin/csi -ss
;; vim: sw=2 foldmethod=indent
(use srfi-13
     extras
     crossref)

;; Mapping of Crossref publication types to Bib(La)TeX types
(define *types*
  (alist->hash-table
    '(("journal-article" . "article")
      ("book-chapter" . "incollection")
      ("proceedings-article" . "inproceedings"))))

;; Helper functions
(define (to-stderr msg)
  (format (current-error-port)
          (format "~A~%" msg)))

(define (unvec v)
  (car (vector->list v)))

(define (string-ends-with? str char)
  (string=? (string-take-right str (string-length char)) char))

(define (upcase-first str)
  (assert (string? str))
  (let ((lst (map string (string->list str))))
    (if (zero? (length lst)) ""
      (conc
        (string-upcase (car lst))
        (string-intersperse (cdr lst) "")))))

(define (bibtex-line key value)
  (if (string=? value "") 
    ""
    (format "    ~A = {~A},\n" key value)))

(define (find-split-char str)
  (cond
    ((and (string-contains str "?") (not (string-ends-with? str "?"))) "?")
    ((and (string-contains str ".") (not (string-ends-with? str "."))) ".")
    (else ":")))

;; Formatting functions
(define (format-title title)
  (let* ((split-char (find-split-char title))
         (append-char (if (string=? split-char "?") "?" ""))
         (split-title (map upcase-first (map string-trim-both (string-split title split-char)))))
    (cond
      ((= (length split-title) 2) (list (conc (car split-title) append-char) (cadr split-title)))
      ((= (length split-title) 1) (list title ""))
      (else (list (conc (car split-title) append-char)
                  (string-intersperse (cadr split-title) (conc split-char " ")))))))

(define (format-authors a)
  (let ((author-list (vector->list a))
        (given+family (lambda (name)
                        (conc
                          (hash-table-ref name 'given) " "
                          (hash-table-ref name 'family)))))
    (string-intersperse
      (map given+family
          (map alist->hash-table author-list)) " and ")))

(define (format-date date-parts)
  (string-intersperse
    (map
      (lambda (number)
        (let ((numstr (number->string number)))
          (if (= (string-length numstr) 1)
            (conc "0" numstr)
            numstr)))
      (vector->list (unvec (cdar date-parts))))
    "-"))

(define (format-pages page-range)
  (string-intersperse
    (string-split page-range "-")
    "--"))

;; Main procedure
(define (process-bib doi)
  (let* ((bib-table (doi-lookup doi))
         (empty-bib (not (hash-table-exists? bib-table 'DOI)))
         (get-value (lambda (key)
                      (if (hash-table-exists? bib-table key)
                        (hash-table-ref bib-table key)
                        ""))))
    (if empty-bib
      (to-stderr (conc "DOI could not be resolved: " doi))
      (let ((title (unvec (hash-table-ref bib-table 'title)))
            (type (get-value 'type))
            (journal (unvec (get-value 'container-title)))
            (author (get-value 'author))
            (volume (get-value 'volume))
            (number (get-value 'issue))
            (pages (get-value 'page))
            (date (get-value 'created)))
        (print
          (format "@~A{TODO,\n" (hash-table-ref *types* type))
          (bibtex-line "author" (format-authors author))
          (bibtex-line "title" (car (format-title title)))
          (bibtex-line "subtitle" (cadr (format-title title)))
          (bibtex-line "journaltitle" (car (format-title journal)))
          (bibtex-line "journalsubtitle" (cadr (format-title journal)))
          (bibtex-line "volume" volume)
          (bibtex-line "number" number)
          (bibtex-line "date" (format-date date))
          (bibtex-line "pages" (format-pages pages))
          (bibtex-line "doi" (string-trim-both doi))
          "}")))))

;; Entry point
(define (main dois)
  (for-each
    process-bib
    dois))

;; Run main with input from stdin
(cond-expand
  ((or chicken-script (and chicken compiling))
    (main (read-lines)))
  (else))
