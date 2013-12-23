(cl:in-package :gauche-compat.mop.validator.internal)
;; (in-readtable :gauche-compat.mop.validator)

(def-suite gauche-compat.mop.validator)

(in-suite gauche-compat.mop.validator)


(defun checker (o v)
  (format t "~S:~S" (class-name (class-of o)) v)
  v)


(defclass acbd18db4cc2 ()
  ((x :initform 42 :observer (lambda (o v) (checker o v)))
   (y :initform 42 :observer #'(lambda (o v) (checker o v)))
   (z :initform 42 :observer #'checker)
   (a :initform 42 :observer 'checker))
  (:metaclass validator-meta))


(defclass 85cedef654fcc (acbd18db4cc2)
  ((x :initform 42 :validator (lambda (o v) (checker o v)))
   (y :initform 42 :validator #'(lambda (o v) (checker o v)))
   (z :initform 42 :validator #'checker)
   (a :initform 42 :validator 'checker))
  (:metaclass validator-meta))


(defclass ijef (acbd18db4cc2)
  ((x :initform 42
      :validator (lambda (o v) (checker o v))
      :observer (lambda (o v) (checker o v)))
   (y :initform 42
      :validator #'(lambda (o v) (checker o v)) 
      :observer  #'(lambda (o v) (checker o v)))
   (z :initform 42 :validator #'checker :observer #'checker)
   (a :initform 42 :validator 'checker :observer 'checker))
  (:metaclass validator-meta))


(test mop.validator
  (is (equal (with-output-to-string (*standard-output*)
               (make-instance 'acbd18db4cc2))
             "ACBD18DB4CC2:42ACBD18DB4CC2:42ACBD18DB4CC2:42ACBD18DB4CC2:42"))
  (is (equal (with-output-to-string (*standard-output*)
               (make-instance '85cedef654fcc))
             "85CEDEF654FCC:4285CEDEF654FCC:4285CEDEF654FCC:4285CEDEF654FCC:42"))
  (is (equal (with-output-to-string (*standard-output*)
               (make-instance 'ijef))
             "IJEF:42IJEF:42IJEF:42IJEF:42IJEF:42IJEF:42IJEF:42IJEF:42")))


;;; *EOF*
