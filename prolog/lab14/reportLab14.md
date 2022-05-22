# Использование правил в программе на Prolog

## Задание

Создать базу знаний: «ПРЕДКИ», позволяющую наиболее эффективным способом (за меньшее количество шагов, что обеспечивается меньшим количеством предложений БЗ - правил), и используя разные варианты (примеры) одного вопроса, определить (указать: какой вопрос для какого варианта):

1. по имени субъекта определить всех его бабушек (предки 2-го колена),
2. по имени субъекта определить всех его дедушек (предки 2-го колена),
3. по имени субъекта определить всех его бабушек и дедушек (предки 2-го колена),
4. по имени субъекта определить его бабушку по материнской линии (предки 2-го колена),
5. по имени субъекта определить его бабушку и дедушку по материнской линии (предки 2-го колена).

Минимизировать количество правил и количество вариантов вопросов. Использовать конъюнктивные правила и простой вопрос.

Для одного из вариантов ВОПРОСА и конкретной БЗ составить таблицу, отражающую конкретный порядок работы системы, с объяснениями

## Код программы

```prolog
include "lab14.inc"

domains
    name, sex = symbol.

predicates

    parent(name, name, sex).
    grand(name, name, sex, sex).

clauses

    parent("Ololo", "Kek", "w").
    parent("Ololo", "Cheburek", "m").

    parent("Kek", "Anna", "w").
    parent("Kek", "Lol", "m").

    parent("Cheburek", "Beliash", "w").
    parent("Cheburek", "Pirodzok", "m").

    grand(Child, NameGrand, Line, Sex) :-
        parent(Child, NameParent, Line),
        parent(NameParent, NameGrand, Sex).

goal

    grand("Ololo", NameGrandmother, _, "w").
        %NameGrandmother=Anna
        %NameGrandmother=Beliash
        %2 Solutions

    %grand("Ololo", NameGrandfather, _, "m").
        %NameGrandfather=Lol
        %NameGrandfather=Pirodzok
        %2 Solutions

    %grand("Ololo", NameGrand, _, _).
        %NameGrand=Anna
        %NameGrand=Lol
        %NameGrand=Beliash
        %NameGrand=Pirodzok
        %4 Solutions

    %grand("Ololo", NameGrandmother, "w", "w").
        %NameGrandmother=Anna
        %1 Solution

    %grand("Ololo", NameGrand, "w", _).
        %NameGrand=Anna
        %NameGrand=Lol
        %2 Solutions
```

## Словесное описание порядка ответа на вопрос

|№ шага|Состояние резольвенты, и вывод: дальнейшие действия (почему?)|Для каких термов запускается алгоритм унификации: Т1=Т2 и каков результат (и подстановка)| Дальнейшие действия: прямой ход или откат (почему и к чему приводит?)|
|---|---|---|---|
|1|grand("Ololo", NameGrandmother, "w", "w")|Сравнение: grand("Ololo", NameGrandmother, "w", "w") = parent("Ololo", "Kek", "w"). Унификация неуспешна (несовпадение функторов)| Прямой ход, переход к следующему предложению |
|2-6|...|...|...|
|7|parent("Ololo", NameParent, "w") </br> parent(NameParent, NameGrandmother, "w")|Сравнение: grand("Ololo", NameGrandmother, "w", "w") = grand(Child, NameGrand, Line, Sex). Унификация успешна. Подстановка: {Child="Ololo", NameGrand=NameGrandmother, Line="w", Sex="w"}| Прямой ход, редукция резольвенты|
|8|parent(NameParent, NameGrandmother, "w")|Сравнение: parent("Ololo", NameParent, "w") = parent("Ololo", "Kek", "w").  Унификация успешна. Подстановка: {Child="Ololo", NameGrand=NameGrandmother, Line="w", Sex="w", NameParent="Kek"}| Прямой ход, редукция резольвенты|
|9|пуста|Сравнение: parent("Kek", NameGrandmother, "w") = parent("Ololo", "Kek", "w"). Унификация неуспешна (Несовпадение термов)| Прямой ход, переход к следующему предложению |
|10|...|...|...|
|11|parent("Kek", NameGrandmother, "w") </br>parent("Ololo", NameParent, "w")|Cравнение: parent("Kek", NameGrandmother, "w") = parent("Kek", "Anna", "w"). Унификация успешна. Подстановка: {Child="Ololo", NameGrandmother="Anna", Line="w", Sex="w", NameParent="Kek"}| **Вывод: NameGrandmother=Anna.** Откат, следующее предложение, подстановка: {Child="Ololo", NameGrand=NameGrandmother, Line="w", Sex="w", NameParent="Kek"}|
|12|parent("Ololo", NameParent, "w")|Cравнение: parent("Kek", NameGrandmother, "w") = parent("Kek", "Lol", "m"). Унификация неуспешна (Несовпадение термов)| Прямой ход, переход к следующему предложению |
|13-14|...|...|...|
|15|parent("Ololo", NameParent, "w")|Cравнение: parent("Kek", NameGrandmother, "w") = grand(Child, NameGrand, Line, Sex). Унификация неуспешна (несовпадение функторов)| Откат, достижение конца БЗ, переход к следующему предложению относительно шага 8. Новая подстановка: {Child="Ololo", NameGrand=NameGrandmother, Line="w", Sex="w"}|
|16| пустая |Сравнение: parent("Ololo", NameParent, "w") = parent("Ololo", "Cheburek", "m"). Унификация неуспешна (Несовпадение термов)| Прямой ход, переход к следующему предложению |
|17-20|...|...|...|
|21| пустая |Сравнение: parent("Ololo", NameParent, "w") = grand(Child, NameGrand, Line, Sex). Унификация неуспешна (несовпадение функторов)| Достижение конца БЗ, резольвента пуста, завершение работы. |


