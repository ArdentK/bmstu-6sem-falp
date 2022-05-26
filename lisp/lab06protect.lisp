(defpackage #:generic-monoid 
	(:use "COMMON-LISP")
		(:shadow "+"))

(in-package #:generic-monoid)

(defgeneric binary+ (addend1 addend2))

(defclass monoid ()
	((operation :initarg :operation
				:accessor operation)
	(neitral_element :initarg :e
				:accessor e)))

(defclass monoid_object ()
	((mnd :initarg :mnd
			:accessor mnd)
	(val :initarg :val
			:accessor val)))

(defun create_monoid (operation e)
	(make-instance 'monoid :operation operation :e e))

(defun create_monoid_object (mnd &optional (val (e mnd)))
	(make-instance 'monoid_object :mnd mnd :val val))

(defmethod binary+ ((x monoid_object) (y monoid_object))
	(make-instance 'monoid_object :mnd (mnd x) :val (funcall (operation (mnd x)) (val x) (val y))))

(defun + (&rest addends)
	(cond
	(addends
		(reduce 'binary+ addends :initial-value (create_monoid_object (mnd (car addends)))))
	(t
		nil)))

;Создание каких-то моноидов
(defvar mnd1 (create_monoid 'append nil))
(defvar mnd2 (create_monoid 'cl+ 0))
(defvar mnd3 (create_monoid '* 1))
(defvar mnd4 (create_monoid '+ 1));"грязный моноид"
