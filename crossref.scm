(module crossref
        (doi-lookup)
(import scheme
        chicken
        data-structures
        srfi-69)
(use http-client
     medea
     rest-bind)

(define *crossref-api-url*
  "https://api.crossref.org/works")

(define-method (query-crossref doi)
  ;; Queries the Crossref endpoint and parses the returned JSON.
               *crossref-api-url*
               #f
               read-json)

(define (doi-lookup doi)
  ;; Given a DOI, this function returns a hash-table with bibliographic data if
  ;; the DOI can be resolved, or an empty hash-table if it cannot.
  (handle-exceptions exn
                     (make-hash-table)
                     (alist->hash-table
                       (alist-ref 'message
                                  (query-crossref doi)))))
)
