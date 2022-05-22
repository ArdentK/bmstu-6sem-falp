;; reverse
;; ~3 строки
(defun my-reverse (lst &optional (buf-lst Nil))
    (cond 
        ((null lst) buf-lst)
        (t (my-reverse (cdr lst) (cons (car lst) buf-lst)))))

;; (print(my-reverse '(1 2 3 4)))

(defun form-stop (x n) (round ))

(defun add-between (n lst start stop res i)
    (cond 
        ((< i 0) res)
        ((or (< i start) (> i stop)) (add-between n lst start stop (cons (nth i lst) res) (- i 1)))
        (t (add-between n lst start stop (cons (+ (nth i lst) 1) res) (- i 1)))))

(defun add-around (n lst start stop res i)
    (cond 
        ((< i 0) res)
        ((and (> i stop) (< i start)) (add-around n lst start stop (cons (nth i lst) res) (- i 1)))
        (t (add-around n lst start stop (cons (+ (nth i lst) 1) res) (- i 1)))))

(defun add-extra (n start stop lst)
    (cond 
        ((= start (round (mod (+ stop 1) n))) lst)
        ((<= start stop) (add-between n lst start stop nil (- n 1)))
        (t (add-around n lst start stop nil (- n 1)))))

(defun update (n lst start hand)
    (add-extra n (round (mod (+ 1 start) n)) (round (mod (+ start (mod hand n)) n)) (mapcar #'(lambda (x) (+ x (truncate hand n))) lst)))

(defun zeros (lst x i res)
    (cond 
        ((< i 0) res)
        ((= i x) (zeros lst x (- i 1) (cons 0 res)))
        (t (zeros lst x (- i 1) (cons (nth i lst) res)))))

(defun update-list (n lst take hand)
    (update n (zeros lst take (- n 1) nil) take hand))

(defun is-win (lst)
    (every #'(lambda (x) (= x 0)) (cdr lst)))

(defun tchuka-ruma-loop (n lst hand take res stop)
    (cond 
        ((and (print (list lst hand take stop)) nil))
        ((= 0 stop)
            (if (is-min lst) 
                res
                (if (null (tchuka-ruma-start n lst 1))
                    nil
                    (append res (tchuka-ruma-start n lst 1)))))
        ((= 1 (nth stop lst)) (and (print '("NOOOO!")) nil))
        (t (tchuka-ruma-loop 
                n 
                (update-list n lst stop (nth stop lst)) 
                (nth stop lst) 
                stop
                (append res (cons stop nil))
                (round (mod (+ stop (mod (nth stop lst) n)) n))))))

(defun tchuka-ruma-start-loop(n lst start)
    (tchuka-ruma-loop 
            n 
            (update-list n lst start (nth start lst)) 
            (nth start lst) 
            start 
            (cons start nil) 
            (round (mod (+ start (mod (nth start lst) n)) n))))

(defun tchuka-ruma-start (n lst i)
    (cond 
        ((= i n) Nil)
        ((= 0 (nth i lst)) (tchuka-ruma-start n lst (+ i 1)))
        (t (or (tchuka-ruma-start-loop n lst i) 
               (and (print (list lst i)) 
                    (tchuka-ruma-start n lst (+ i 1)))))))

(defun tchuka-ruma (n lst)
    (tchuka-ruma-start (+ n 1) (cons 0 lst) 1) nil)

(print (tchuka-ruma 4 '(2 2 2 2)))
