# **Модел за измами при финансови транзакции**
### Проект на Стефан Велинов и Станислав Узунов по "Приложна Статистика"

## Основни причини за избор на синтезирани данни и модел
 * липса на общодостъпни (публични) данни свързани с финансови транзакции и услуги
 * международни бизнес клиенти с голямо количество данни нямат причина да ги представят публично
 * с развитието на интернет и мобилните услуги се увеличават и транзакциите по електронен път
 * модели (по-точни и по-сложни) за предсказване на измами при финансови транзакции могат да помогнат за засилване на сигурността и предотвъртяването им

### Обработка на данните
Зареждаме данните чрез read.csv функцията или като ги import, (което е едно и също).

>A tibble: 100,000 x 11
    step     type    amount    nameOrig oldbalanceOrg newbalanceOrig    nameDest oldbalanceDest newbalanceDest
   <int>    <chr>     <dbl>       <chr>         <dbl>          <dbl>       <chr>          <dbl>          <dbl>
1      8  PAYMENT    220.34  C286053652         690.0         469.66  M827873651           0.00           0.00
2      9  CASH_IN  34750.38 C1966910784      781841.2      816591.58  C681835572       42910.72        8160.34
3      9 CASH_OUT 125967.07  C240512339           0.0           0.00 C1785642500     1633198.94     2611537.27
4     10 CASH_OUT  97750.62 C1425300990           0.0           0.00  C560859791      244101.01      341851.63
5      8  PAYMENT   8565.79 C2022319508     2033432.1     2024866.32 M2050451949           0.00           0.00
6     10 CASH_OUT 245947.38  C991416036           0.0           0.00 C1554282047      593738.07      839685.45
7     10 CASH_OUT  74182.47  C952300737           0.0           0.00 C2099288093       78751.00      230188.45
8      9 CASH_OUT 126861.68  C688927277        1349.0           0.00  C372374036      192395.14     9026847.12
9      9 CASH_OUT 387926.52 C1516972151       20329.0           0.00  C872991067       38806.48      397146.28
10     6    DEBIT   3525.54 C1254589807       24708.0       21182.46 C1330106945        8617.02       12142.56
 ... with 99,990 more rows, and 2 more variables: isFraud <int>, isFlaggedFraud <int>

Понеже имаме много данни, взимаме част от тях за улеснение (100 000 наблюдения на 11 променливи), като използваме функцията samplе.

>s_size = 100000
>s_rows = 1:s_size

>set.seed(1)

>paysim_s <- paysim_ds[sample(s_rows,s_size),]


Две от категорните променливи са проблемни (nameOrig, nameDest), понеже всяко тяхно наблюдение се чете като отделна променлива.
