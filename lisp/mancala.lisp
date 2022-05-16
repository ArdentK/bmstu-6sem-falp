(defun add-between-helper (n lst start stop res i)
    (cond ((< i 0) res)
        ((or (< i start) (> i stop)) (add-between-helper n lst start stop (cons (nth i lst) res) (- i 1)))
        (t (add-between-helper n lst start stop (cons (+ (nth i lst) 1) res) (- i 1)))))

(defun add-between (n lst start stop)
    (add-between-helper n lst start stop nil (- n 1)))

(defun add-around-helper (n lst start stop res i)
    (cond ((< i 0) res)
        ((and (> i stop) (< i start)) (add-around-helper n lst start stop (cons (nth i lst) res) (- i 1)))
        (t (add-around-helper n lst start stop (cons (+ (nth i lst) 1) res) (- i 1)))))

(defun add-around (n lst start stop)
    (add-around-helper n lst start stop nil (- n 1)))

(defun add-extra (n start stop lst)
    (cond ((= start (round (mod (+ stop 1) n))) lst)
        ((<= start stop) (add-between n lst start stop))
        (t (add-around n lst start stop))))

(defun make-updated (n lst start hand)
    (add-extra n (round (mod (+ 1 start) n)) (round (mod (+ start (mod hand n)) n)) (mapcar #'(lambda (x) (+ x (truncate hand n))) lst)))

(defun make-zero-helper (lst x i res)
    (cond ((< i 0) res)
        ((= i x) (make-zero-helper lst x (- i 1) (cons 0 res)))
        (t (make-zero-helper lst x (- i 1) (cons (nth i lst) res)))))

(defun make-zero (n lst take)
    (make-zero-helper lst take (- n 1) nil))

(defun make-updated-list (n lst take hand)
    (make-updated n (make-zero n lst take) take hand))

(defun is-win (lst)
    (every #'(lambda (x) (= x 0)) (cdr lst)))

(defun mancala-loop (n lst hand take res stop)
    (cond ((and (print (list n lst hand take stop)) nil))
        ((= 0 stop)
            (if (is-win lst) 
                res
                (if (null (mancala-starter n lst 1))
                    nil
                    (append res (mancala-starter n lst 1)))))
        ((= 1 (nth stop lst)) (and (print `("NIL")) nil))
        (t (mancala-loop n 
                (make-updated-list n lst stop (nth stop lst)) 
                (nth stop lst) 
                stop
                (append res (cons stop nil))
                (round (mod (+ stop (mod (nth stop lst) n)) n))))))

(defun mancala-start (n lst start)
    (mancala-loop n (make-updated-list n lst start (nth start lst)) 
        (nth start lst) start (cons start nil) (round (mod (+ start (mod (nth start lst) n)) n))))

(defun mancala-starter (n lst i)
    (cond ((= i n) Nil)
        ((= 0 (nth i lst)) (mancala-starter n lst (+ i 1)))
        (t (or (mancala-start n lst i) (and (print (list lst i)) (mancala-starter n lst (+ i 1)))))))

(defun mancala (n lst)
    (mancala-starter (+ n 1) (cons 0 lst) 1))
