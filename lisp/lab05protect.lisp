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

;; (det #2A((-26 -33 -25) (31 42 23) (-11 -15 -4)))
;; (inv #2A((-26 -33 -25) (31 42 23) (-11 -15 -4)))
;; (mtp #2A((-26 -33 -25) (31 42 23) (-11 -15 -4)))

;; #2A((-26 -33 -25) (31 42 23) (-11 -15 -4))
;; #2A((-1 3 -1) (-3 5 -1) (-3 3 1))