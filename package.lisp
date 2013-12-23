;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :gauche-compat.mop.validator
  (:use)
  (:export :validator-meta))

(defpackage :gauche-compat.mop.validator.internal
  (:use :gauche-compat.mop.validator :cl :named-readtables :fiveam))

