;;;; gauche-compat.mop.validator.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :gauche-compat.mop.validator
  :serial t
  :depends-on (:fiveam
               :named-readtables
               :closer-mop)
  :components ((:file "package")
               (:file "gauche-compat.mop.validator")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :gauche-compat.mop.validator))))
  (load-system :gauche-compat.mop.validator)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :gauche-compat.mop.validator.internal :gauche-compat.mop.validator))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

