# Рекурсия на Prolog

## Задание

Используя хвостовую рекурсию, разработать программу, позволяющую найти

1. n!,
2. n-е число Фибоначчи.

Убедиться в правильности результатов. Для одного из вариантов ВОПРОСА и каждого задания составить таблицу, отражающую конкретный порядок работы системы.

## Код программы

```prolog
include "lab16.inc"
include "lab16.inc"

domains
  n = integer

predicates
  fact(n, n)
  recursion_fact(n, n, n)

  fib(n, n)
  recursion_fib(n, n, n, n)

clauses
  recursion_fact(N, Res, Acc) :- 
        N > 1, !, NewN = N - 1, 
        NewAcc = Acc * N, 
        recursion_fact(NewN, Res, NewAcc).
  recursion_fact(_, Res, Acc) :- Res = Acc.
  fact(N, Res) :- recursion_fact(N, Res, 1).

  recursion_fib(N, F1, F2, Res) :- 
        N > 2, 
        !, 
        NewF1 = F2, 
        NewF2 = F1 + F2, 
        NewN = N - 1, 
        recursion_fib(NewN, NewF1, NewF2, Res).
  recursion_fib(_, _, B, Res) :- Res = B.
  fib(N, Res) :- recursion_fib(N, 1, 1, Res).

goal
  fact(4, Res).
    %Res=24
    %1 Solution
  %fib(4, Res).
    %Res=3
    %1 Solution
```

## Словесное описание порядка поиска ответа на вопрос №1

|№ шага|Состояние резольвенты, и вывод: дальнейшие действия (почему?)|Для каких термов запускается алгоритм унификации: Т1=Т2 и каков результат (и подстановка)| Дальнейшие действия: прямой ход или откат (почему и к чему приводит?)|
|:---|:---|:---|:---|
|1|fact(4, Res)| Сравнение: fact(4, Res) = recursion_fact(N, Res, Acc). </br> Унификация неуспешна (несовпадение функторов)| Прямой ход, переход к следующему предложению |
|2|...|...|...|
|3|recursion_fact(4, Res, 1)|Сравнение: fact(4, Res) = fact(N, Res). Унификация успешна. </br> Подстановка: {N=4, Res=Res}| Прямой ход, редукция резольвенты|
|4|4 > 1 </br> !</br> NewN = 4 - 1</br>NewAcc = 1 * 4</br>recursion_fact(NewN, Res, NewAcc)|Сравнение: recursion_fact(4, Res, 1) = recursion_fact(N, Res, Acc). Унификация успешна. </br> Подстановка: {N=4, Res=Res, Acc=1}| Прямой ход, редукция резольвенты|
|5|!</br> NewN = 4 - 1</br>NewAcc = 1 * 4</br>recursion_fact(NewN, Res, NewAcc)| 4 > 1. Правда| Прямой ход, редукция резольвенты|
|6|NewN = 4 - 1</br>NewAcc = 1 * 4</br>recursion_fact(NewN, Res, NewAcc)|!. Отсечение 4,5|Прямой ход, редукция резольвенты|
|7|NewAcc = 1 * 4</br>recursion_fact(3, Res, NewAcc)|NewN = 4 - 1. Подстановка: {N=4, Res=Res, Acc=1, NewN=3} |Прямой ход, редукция резольвенты|
|8|recursion_fact(3, Res, 4)|NewAcc = 1 * 4. Подстановка: {N=4, Res=Res, Acc=1, NewN=3, NewAcc=4} |Прямой ход, редукция резольвенты|
|9|3 > 1 </br> !</br> NewN = 3 - 1</br>NewAcc = 4 * 3</br>recursion_fact(NewN, Res, NewAcc)|Сравнение: recursion_fact(3, Res, 4) = recursion_fact(N, Res, Acc). Унификация успешна. Подстановка: {N=3, Res=Res, Acc=4} |Прямой ход, редукция резольвенты|
|10|!</br> NewN = 3 - 1</br>NewAcc = 4 * 3</br>recursion_fact(NewN, Res, NewAcc)|3 > 1. Правда. |Прямой ход, редукция резольвенты|
|11|NewN = 3 - 1</br>NewAcc = 4 * 3</br>recursion_fact(NewN, Res, NewAcc)|!. Отсечение 9, 10|Прямой ход, редукция резольвенты|
|12|NewAcc = 4 * 3</br>recursion_fact(2, Res, NewAcc)|NewN = 3 - 1. Подстановка: {N=3, Res=Res, Acc=4, NewN=2}|Прямой ход, редукция резольвенты|
|13|recursion_fact(2, Res, 12)|NewAcc = 4 * 3. Подстановка: {N=3, Res=Res, Acc=4, NewN=2, NewAcc=12}|Прямой ход, редукция резольвенты|
|14|2 > 1</br>!</br>NewN = 2 - 1</br>NewAcc = 12 * 2</br>recursion_fact(NewN, Res, NewAcc)|Сравнение: recursion_fact(2, Res, 12) = recursion_fact(N, Res, Acc). Унификация успешна. </br> Подстановка: {N=2, Res=Res, Acc=12}| Прямой ход, редукция резольвенты|
|15|!</br>NewN = 2 - 1</br>NewAcc = 12 * 2</br>recursion_fact(NewN, Res, NewAcc)| 2 > 1. Правда|Прямой ход, редукция резольвенты|
|16|NewN = 2 - 1</br>NewAcc = 12 * 2</br>recursion_fact(NewN, Res, NewAcc)| !. Отсечение 14, 15|Прямой ход, редукция резольвенты|
|17|NewAcc = 12 * 2</br>recursion_fact(1, Res, NewAcc)|NewN = 2 - 1. Подстановка: {N=2, Res=Res, Acc=12, NewN=1}||Прямой ход, редукция резольвенты|
|18|recursion_fact(1, Res, 24)|NewAcc = 12 * 2. Подстановка: {N=2, Res=Res, Acc=12, NewN=1, NewAcc=24}|Прямой ход, редукция резольвенты|
|19|1 > 1 </br> !</br> NewN = 1 - 1</br>NewAcc = 42 * 1|Сравнение: recursion_fact(1, Res, 24) = recursion_fact(N, Res, Acc). Унификация успешна. Подстановка: {N=1, Res=Res, Acc=24} |Прямой ход, редукция резольвенты|
|20|!</br> NewN = 1 - 1</br>NewAcc = 42 * 1|1 > 1. Ложь| Откат относительно шага 18|
|21|Res = 24|Сравнение: recursion_fact(1, Res, 24) = recursion_fact(_, Res, Acc). Унификация успешна. Подстановка: {Res=Res, Acc=24} |Прямой ход, редукция резольвенты|
|22||Res = 24. Подстановка: {Res=24, Acc=24} |**Вывод: Res=24** Резольвента пуста, завершение работы|

## Словесное описание порядка поиска ответа на вопрос №2

|№ шага|Состояние резольвенты, и вывод: дальнейшие действия (почему?)|Для каких термов запускается алгоритм унификации: Т1=Т2 и каков результат (и подстановка)| Дальнейшие действия: прямой ход или откат (почему и к чему приводит?)|
|:---|:---|:---|:---|
|1|fib(4, Res)|Сравнение: fib(4, Res) = recursion_fact(N, Res, Acc). Унификация неуспешна (несовпадение функторов)| Прямой ход, переход к следующему предложению |
|2-5|...|...|...|
|6|recursion_fib(4, 1, 1, Res)|Сравнение: fib(4, Res) = fib(N, Res). Унификация успешна. Подстановка: {N=2, Res=Res}.|Прямой ход, редукция резольвенты|
|7||Сравнение: recursion_fib(2, 1, 1, Res) = recursion_fact(N, Res, Acc)|Унификация неуспешна (несовпадение функторов)| Прямой ход, переход к следующему предложению |
|8-9|...|...|...|
|10|4 > 2 </br>!</br>NewF1 = 1</br>NewF2 = 1 + 1</br>NewN = 4 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)|Сравнение: recursion_fib(2, 1, 1, Res) = recursion_fib(N, F1, F2, Res). Унификация успешна. Подстановка: {N=2, Res=Res, F1=1, F2=1}.|Прямой ход, редукция резольвенты|
|11|!</br>NewF1 = 1</br>NewF2 = 1 + 1</br>NewN = 4 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)|4 > 2. Правда|Прямой ход, редукция резольвенты|
|12|NewF1 = 1</br>NewF2 = 1 + 1</br>NewN = 4 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)|!. Отсечение 10, 11|Прямой ход, редукция резольвенты|
|13|NewF2 = 1 + 1</br>NewN = 4 - 1</br>recursion_fib(NewN, 1, NewF2, Res)|NewF1 = 1. Подстановка: {N=2, Res=Res, F1=1, F2=1, NewF1=1}.|Прямой ход, редукция резольвенты|
|14|NewN = 4 - 1</br>recursion_fib(NewN, 1, 2, Res)|NewF2 = 1 + 1. Подстановка: {N=2, Res=Res, F1=1, F2=1, NewF1=1, NewF2=2}.|Прямой ход, редукция резольвенты|
|15|recursion_fib(3, 1, 2, Res)|NewN = 4 - 1. Подстановка: {N=2, Res=Res, F1=1, F2=1, NewF1=1, NewF2=2, NewN=3}.|Прямой ход, редукция резольвенты|
|16||Сравнение: recursion_fib(3, 1, 2, Res) = recursion_fact(N, Res, Acc). Унификация неуспешна (несовпадение функторов)| Прямой ход, переход к следующему предложению |
|17-18|...|...|...|
|19|3 > 2 </br>!</br>NewF1 = 1</br>NewF2 = 1 + 2</br>NewN = 3 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)|Сравнение: recursion_fib(3, 1, 2, Res) = recursion_fib(N, F1, F2, Res). Унификация успешна. Подстановка: {N=3, Res=Res, F1=1, F2=2}.|Прямой ход, редукция резольвенты|
|20|!</br>NewF1 = 2</br>NewF2 = 1 + 2</br>NewN = 3 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)|3 > 2. Правда.|Прямой ход, редукция резольвенты|
|21|NewF1 = 2</br>NewF2 = 1 + 2</br>NewN = 3 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)| !. Отсечение 19, 20|Прямой ход, редукция резольвенты|
|22|NewF2 = 1 + 2</br>NewN = 3 - 1</br>recursion_fib(NewN, 2, NewF2, Res)|NewF1 = 2. Подстановка: {N=3, Res=Res, F1=1, F2=2, NewF1=2}.|Прямой ход, редукция резольвенты|
|23|NewN = 3 - 1</br>recursion_fib(NewN, 2, 3, Res)|NewF2 = 1 + 2. Подстановка: {N=3, Res=Res, F1=1, F2=2, NewF1=2, NewF2=3}.|Прямой ход, редукция резольвенты|
|24|recursion_fib(2, 2, 3, Res)|NewN = 3 - 1. Подстановка: {N=3, Res=Res, F1=1, F2=2, NewF1=2, NewF2=3, NewN=2.|Прямой ход, редукция резольвенты|
|25||Сравнение: recursion_fib(2, 2, 3, Res) = recursion_fact(N, Res, Acc). Унификация неуспешна (несовпадение функторов)| Прямой ход, переход к следующему предложению |
|26-27|...|...|...|
|28|2 > 2 </br>!</br>NewF1 = 2</br>NewF2 = 2 + 3</br>NewN = 2 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)|Сравнение: recursion_fib(2, 2, 3, Res) = recursion_fib(N, F1, F2, Res). Унификация успешна. Подстановка: {N=2, Res=Res, F1=2, F2=3}.|Прямой ход, редукция резольвенты|
|29|!</br>NewF1 = 2</br>NewF2 = 2 + 3</br>NewN = 2 - 1</br>recursion_fib(NewN, NewF1, NewF2, Res)| 2 > 2. Ложь| Откат относительно шага 28|
|30|Res = B|Сравнение: recursion_fib(2, 2, 3, Res) = recursion_fib(\_, \_, B, Res). Унификация успешна. Подстановка: {B=3, Res=Res}|Прямой ход, редукция резольвенты|
|31||Res = B. Подстановка: {B=3, Res=3}|**Вывод: Res=3**. Резольвента пуста, завершение работы|
