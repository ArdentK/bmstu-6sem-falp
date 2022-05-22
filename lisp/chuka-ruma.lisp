(defun tchuka-ruma-starter (n lst i)
    (cond 
        ((= i n) Nil)
        ((= 0 (nth i lst)) (tchuka-ruma-starter n lst (+ i 1)))
        (t (or (tchuka-ruma-start n lst i) (and (print (list lst i)) (tchuka-ruma-starter n lst (+ i 1)))))))

(defun tchuka-ruma-start (n lst start)
    (tchuka-ruma-loop n 
                  (update-list n lst start (nth start lst))
                  (nth start lst)
                  start
                  (cons start nil)
                  (round (mod (+ start (mod (nth start lst) n)) n))))

(defun add-between (n lst start stop res i)
    (cond 
        ((< i 0) res)
        ((or (< i start) (> i stop)) (add-between n lst start stop (cons (nth i lst) res) (- i 1)))
        (t (add-between n lst start stop (cons (+ (nth i lst) 1) res) (- i 1)))))

(defun add-around (n lst start stop res i)
    (cond ((< i 0) res)
        ((and (> i stop) (< i start)) (add-around n lst start stop (cons (nth i lst) res) (- i 1)))
        (t (add-around n lst start stop (cons (+ (nth i lst) 1) res) (- i 1)))))

(defun add-extra (n start stop lst)
    (cond 
        ((= start (round (mod (+ stop 1) n))) lst)
        ((<= start stop) (add-between n lst start stop nil (- n 1)))
        (t (add-around n lst start stop nil (- n 1)))))

(defun update (n lst start hand)
    (add-extra n (round (mod (+ 1 start) n)) (round (mod (+ start (mod hand n)) n)) (mapcar #'(lambda (x) (+ x (truncate hand n))) lst)))

(defun zeroes (lst x i res)
    (cond ((< i 0) res)
        ((= i x) (zeroes lst x (- i 1) (cons 0 res)))
        (t (zeroes lst x (- i 1) (cons (nth i lst) res)))))

(defun update-list (n lst take hand)
    (update n (zeroes lst take (- n 1) nil) take hand))

(defun tchuka-ruma-loop (n lst hand take res stop)
    (cond ((and (print (list n lst hand take stop)) nil))
        ((= 0 stop)
            (if (every #'(lambda (x) (= x 0)) (cdr lst)) 
                res
                (if (null (tchuka-ruma-starter n lst 1))
                    nil
                    (append res (tchuka-ruma-starter n lst 1)))))
        ((= 1 (nth stop lst)) (and (print '("NOOOOOOOOOO")) nil))
        (t (tchuka-ruma-loop n 
                (update-list n lst stop (nth stop lst)) 
                (nth stop lst) 
                stop
                (append res (cons stop nil))
                (round (mod (+ stop (mod (nth stop lst) n)) n))))))

(defun tchuka-ruma (n lst)
    (tchuka-ruma-starter (+ n 1) (cons 0 lst) 1))

(print (tchuka-ruma 4 '(2 2 2 2)))
;; (print (tchuka-ruma 1 '(2)))
;; (print (tchuka-ruma 7 '(1 2 3 4 5 6 7)))

