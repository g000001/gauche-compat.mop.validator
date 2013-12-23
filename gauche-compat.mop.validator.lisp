;;;; gauche-compat.mop.validator.lisp

(cl:in-package :gauche-compat.mop.validator.internal)


(defclass validator-meta (standard-class) ())


(defmethod c2mop:validate-superclass ((class validator-meta) (sc standard-class))
  T)


(defclass validator-meta-direct-slot-definition
          (c2mop:standard-direct-slot-definition)
  ((validator :initform nil :initarg :validator)
   (observer  :initform nil :initarg :observer)))


(defclass validator-meta-effective-slot-definition
          (c2mop:standard-effective-slot-definition)
  ((validator :initform nil :initarg :validator)
   (observer  :initform nil :initarg :observer)))


(defmethod c2mop:direct-slot-definition-class
           ((class validator-meta) &key &allow-other-keys)
  (find-class 'validator-meta-direct-slot-definition))


(defmethod c2mop:effective-slot-definition-class
           ((class validator-meta) &key &allow-other-keys)
  (find-class 'validator-meta-effective-slot-definition))


(defun function-expr-to-quote-expr (fun)
  (etypecase fun
    ((CONS (EQL QUOTE) *) fun)
    ((CONS (EQL FUNCTION) (cons (cons (eql lambda) *))) fun)
    ((CONS (EQL FUNCTION) *) `(quote ,(second fun)))
    ((CONS (EQL LAMBDA) *) fun)))


(defmethod c2mop:compute-effective-slot-definition
           ((class validator-meta) slot-name direct-slot-definitions)
  (declare (ignore slot-name))
  (let ((effective-slotd (call-next-method)))
    (dolist (checker '(validator observer))
      (setf (slot-value effective-slotd checker)
            (let ((slotv (slot-value (first direct-slot-definitions) checker)))
              (and slotv 
                   ;; null-lexenv
                   (let ((expr (eval (function-expr-to-quote-expr slotv))))
                     (lambda (s v) (funcall expr s v))))))) 
    effective-slotd))


(defmethod (setf c2mop:slot-value-using-class)
           (val (class validator-meta) object slotd)
  (when (slot-value slotd 'validator)
    (funcall (slot-value slotd 'validator) object val))
  (let ((slotv (call-next-method)))
    (when (slot-value slotd 'observer)
      (funcall (slot-value slotd 'observer) object val))
    slotv))


;;; *EOF*
