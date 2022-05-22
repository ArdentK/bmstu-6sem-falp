(setf *random-state* (make-random-state t))

(defun dices-roll (edgen)
    (let* (
            (fdice (+ (random edgen) 1))
            (sdice (+ (random edgen) 1))
            (sum (+ fdice sdice)))
    (if (or (and (eq fdice 1) (eq sdice 1)) (and (eq fdice 6) (eq sdice 6)))
        (progn (format t "~%~a ~a - Перебрасывание! игрок бросает кости снова... " fdice sdice) (setq sum (dices-roll edgen)))
        (progn (format t "~a ~a~%" fdice sdice) sum))))

(defun early-winp(score)
        (or (eq score 7) (eq score 11)))

(defun final-score (fp sp)
    (cond ((early-winp sp) (format t "игрок 2 выбросил ~a и выиграл!~%" sp))
            ((> fp sp) (format t "игрок 1 выиграл!~%"))
            ((> sp fp) (format t "игрок 2 выиграл!~%"))
            (t (write-line "НИЧЬЯ!"))))

(defun play() 
    (let (
        (pl (progn (format t "игрок 1 бросает кости...") (dices-roll 6))))
        (if (early-winp pl)
            (format t "игрок 1 выбросил ~a и выиграл!~%" pl)
            (final-score pl (progn (format t "игрок 2 бросает кости... ") (dices-roll 6))))))

(play)