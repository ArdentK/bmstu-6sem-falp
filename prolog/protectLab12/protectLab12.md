# Защита ЛР 12

|Комментарий| SQL|Visual Prolog|Swi-prolog|
|----|----|----|----|
|Создание таблицы|`create table athlet (`</br>`IDFFR integer,`</br>`Name text,`</br>`Lastname text);`|`DOMAINS`</br>`  name, lastname = symbol.`</br>`    id = integer.`</br></br>`PREDICATES`</br>`  athlet(id, name, lastname).`|-|
|Добавление данных в таблицу|`insert into athlet values`</br>`  (1167, Ololo, Kekovich));`|`CLAUSES`</br>`  athlet(1167, "Ololo", "Kekovich).`|`athlet(1167, "Ololo", "Kekovich).`|
