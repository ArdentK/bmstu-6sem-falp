(defun make-matrix (n m contents)
  (make-array (list n m) :initial-contents contents))

(defun make-constant-matrix (n m &optional (v 0))
  (make-array (list n m) :initial-element v))

(defun get-minor (matrix del-row del-col)
  (let* ((rows   (array-dimension matrix 0))
         (cols   (array-dimension matrix 1))
         (nrows  (if del-row (1- rows) rows))
         (ncols  (if del-col (1- cols) cols))
         (newmat (make-constant-matrix nrows ncols)))
    (if (or (< nrows 1) (< ncols 1))
     (make-constant-matrix 1 1)
     (dotimes (row nrows newmat)
      (dotimes (col ncols)
        (setf (aref newmat row col)
              (aref matrix
                    (if (and del-row (>= row del-row)) (1+ row) row)
                    (if (and del-col (>= col del-col)) (1+ col) col))))))))

(defun det (matrix &optional (rows (array-dimension matrix 0)) &aux (acc 0))
  (cond
    ((eq rows 1)
     (aref matrix 0 0))

    ((eq rows 2)
     (let ((main-diag-prod (* (aref matrix 0 0)
                              (aref matrix 1 1)))
           (sec-diag-prod (* (aref matrix 1 0)
                             (aref matrix 0 1))))
       (- main-diag-prod sec-diag-prod)))

    (T
     (dotimes (row rows acc)
       (let ((minor (get-minor matrix 0 row))
             (sign (if (zerop (mod row 2)) 1 -1)))
         (setq acc (+ acc (* sign
                             (aref matrix 0 row)
                             (det minor)))))))))

(defun adj (matrix)
  (let* ((rows (array-dimension matrix 0))
         (adjoint (make-constant-matrix rows rows 1)))
    (if (= rows 1)
      adjoint
      (dotimes (row rows adjoint)
        (dotimes (col rows)
          (let* ((minor (get-minor matrix row col))
                 (sign (if (zerop (mod (+ row col) 2)) 1 -1))
                 (determinant (det minor)))
              (setf (aref adjoint col row)
                    (* sign determinant))))))))

(defun inv (matrix)
  (let* ((rows (array-dimension matrix 0))
         (inverse (make-constant-matrix rows rows))
         (adjoint (adj matrix))
         (determinant (det matrix)))
    (dotimes (row rows inverse)
      (dotimes (col rows)
        (setf (aref inverse row col)
              (/ (aref adjoint row col) determinant))))))

(declaim (inline row-dimension column-dimension))

(defun row-dimension (a)
  (array-dimension a 0))

(defun column-dimension (a)
  (array-dimension a 1))

(defun mtp (A)
  (let* ((m (array-dimension A 0))
         (n (array-dimension A 1))
         (B (make-array `(,n ,m) :initial-element 0)))
    (loop for i from 0 below m do
      (loop for j from 0 below n do
        (setf (aref B j i)
              (aref A i j))))
    B))

(defun mtp2 (A) (apply `mapcar `list A))

(defun det-helper2 (A lst level last_level)
	(cdr (reduce #'(lambda (ind_sum col)
		  (cond
        ((find (caar ind_sum) lst)
			    (cons (cons (+ (caar ind_sum) 1) (cdar ind_sum)) (cdr ind_sum)))
		((eql (- last_level level) 1)
			(cond 
			((consp (cdr ind_sum))
				(cons (cons (+ (caar ind_sum) 1) (cdar ind_sum)) (- (* (cadr ind_sum) (nth (+ level 1) col)) (* (cddr ind_sum) (nth level col)))))
			(t
				(cons (cons (+ (caar ind_sum) 1) (cdar ind_sum)) (cons (nth level col) (nth (+ level 1) col))))))
		(t
			(cons (cons (+ (caar ind_sum) 1) (- (cdar ind_sum))) (+ (cdr ind_sum) (* (cdar ind_sum) (nth level col) (det-helper2 A (cons (caar ind_sum) lst) (+ level 1) last_level)))))))
	A
	:initial-value (cons (cons 0 1) 0))))

(defun det-helper (A n)
	(cond ((eql n 1) (caar A))
        (t (det-helper2 A nil 0 (- n 1)))))

(defun det2 (A)
	(det-helper A (length (car A))))

;Создать матрицу алгебраических дополнений соотв элементов матрицы A
;1)Для каждого элемента матрицы A найти минор (создаем матрицу миноров)
;1.1)Для подсчета отдельного минора создаем матрицу и высчитываем её определитель
(defun delete_on_position (lst ind)
	(cond
	((zerop ind)
		(cdr lst))
	(t
		(cons (car lst) (delete_on_position (cdr lst) (- ind 1))))))

(defun create_minor_matr (matr ind jnd)
	(mapcar 
	#'(lambda (element)
		(delete_on_position element ind))
	(delete_on_position matr jnd)))

(defun create_minors_matr2 (column jnd ind matr_begin)
	(cond
	(column
		(cons (det2 (create_minor_matr matr_begin ind jnd)) (create_minors_matr2 (cdr column) jnd (+ ind 1) matr_begin)))
	(t
		nil)))

(defun create_minors_matr1 (matr jnd matr_begin)
	(cond
	(matr 
		(cons (create_minors_matr2 (car matr) jnd 0 matr_begin) (create_minors_matr1 (cdr matr) (+ jnd 1) matr_begin)))
	(t
		nil)))

(defun create_minors_matr (matr)
	(create_minors_matr1 matr 0 matr))

;2)Для каждого 2-го элемента матрицы изменить знак РАБОАЕТ!
(defun change_signs_matr1 (matr n)
	(maplist 
	#'(lambda (element1)
		(cond
		((eql (+ (mod (- n (length element1)) 2)) 0)
			(maplist
			#'(lambda (element2)
				(cond
				((eql (+ (mod (- n (length element2)) 2)) 0)
					(car element2))
				(t
					(- (car element2)))))
			(car element1)))
		(t
			(maplist
			#'(lambda (element2)
				(cond
				((eql (+ (mod (- n (length element2)) 2)) 0)
					(- (car element2)))
				(t
					(car element2))))
			(car element1)))))
	matr))

(defun change_signs_matr (matr)
	(change_signs_matr1 matr (length matr)))

;; ;3)Транспонировать эту матрицу

;4)Разделить эту матрицу на число (определитель оригинальной матрицы)
(defun divide_matrix_on (matr num)
	(mapcar 
	#'(lambda (col)
		(mapcar #'(lambda (element) (/ element num)) col))
	matr))

;Итоговое выражение нахождения обратной матрицы OUEEEEEEEEEEEEEEEEEEEEEEEE
(defun inv2-helper (matr determ n)
	(cond
	((zerop determ)
		nil)
	((eql n 1)
		(cons (cons (/ 1 determ) nil) nil))
	(t
		(divide_matrix_on (mtp2 (change_signs_matr (create_minors_matr matr))) determ))))

(defun inv2 (matr)
	(inv2-helper matr (det2 matr) (length matr)))

(defvar kek '((1 2 3) (4 5 6) (7 8 9)))
(defvar lol '((-26 -33 -25) (31 42 23) (-11 -15 -4)))

;; (det #2A((-26 -33 -25) (31 42 23) (-11 -15 -4)))
;; (inv #2A((-26 -33 -25) (31 42 23) (-11 -15 -4)))
;; (mtp #2A((-26 -33 -25) (31 42 23) (-11 -15 -4)))

;; #2A((-26 -33 -25) (31 42 23) (-11 -15 -4))
;; #2A((-1 3 -1) (-3 5 -1) (-3 3 1))



;Умножение квадратных матриц (проверка)
(defun multiply_squad_matrices1 (matr1 matr2 level last_level)
	(cond
	((zerop (- last_level level))
		nil)
	(t
		(cons
		(mapcar 
		#'(lambda (col2)
			(reduce #'+
			(mapcar 
			#'(lambda (element col1)
				(* element (nth level col1)))
			col2 matr1)))
		matr2)
		(multiply_squad_matrices1 matr1 matr2 (+ level 1) last_level)))))

(defun multiply_squad_matrices (matr1 matr2)
	(mtp2 (multiply_squad_matrices1 matr1 matr2 0 (length matr1))))

(defun experiment (matr)
	(multiply_squad_matrices matr (inv2 matr)))