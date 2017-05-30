# **Модел за измами при финансови транзакции**
### Проект на Стефан Велинов и Станислав Узунов по "Приложна Статистика"

## Основни причини за избор на синтезирани данни и модел
 * липса на общодостъпни (публични) данни свързани с финансови транзакции и услуги
 * международни бизнес клиенти с голямо количество данни нямат причина да ги представят публично
 * с развитието на интернет и мобилните услуги се увеличават и транзакциите по електронен път
 * модели (по-точни и по-сложни) за предсказване на измами при финансови транзакции могат да помогнат за засилване на сигурността и предотвратяването им

## Задача и избор на модел 
Задачата ни е да предскажем (възможно най-точно), чрез данните с които разполагаме, дали следващата финансова транзакция  ще се окаже измама. В такъв случай отклика може да приеме две стойности, да или не, и следователно е най-уместно да се използва логистична регресия. 

## Променливи
```
step - стъпка, единица време за което се измерва наблюдението; 1 стъпка = 1 час; максимум от 30 дни (744 стъпки);
type - вид на транзакцията, 5 типа;
amount - сума на транзакцията в съответната валута;
nameOrig - име на клиента, започнал транзакцията;
oldbalanceOrg - налична сума преди транзакцията;
newbalanceOrig - нова налична сума след транзакцията;
nameDest - име на клиент, получател на транзакцията;
oldbalanceDest - 
newbalanceDest -
isFraud - отклик, има/няма измама в съответната извадка от наблюдавани транзакции;
isFlaggedFraud - променлива, маркираща нелегални опити; нелегален опит се интерпретира като транзакция на сума на стойност над 200 000 ед. за една транзакция, т.е. има стойност 1 за транзакции над 200 000 ед. и 0 за транзакции под 200 000 ед.
```

## Обработка на данните
Зареждаме данните чрез read.csv.
>paysim <- read.csv("paysim_ds.csv")

      A tibble: 100,000 x 11
        step     type    amount    nameOrig oldbalanceOrg newbalanceOrig    nameDest oldbalanceDest newbalanceDest
        <int>    <chr>     <dbl>       <chr>         <dbl>          <dbl>       <chr>          <dbl>          <dbl>> 
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

Отклика ни е променливата isFraud.
Понеже имаме много данни, взимаме част от тях за улеснение (100 000 наблюдения на 11 променливи), като използваме функцията samplе.

>paysim_s <- paysim_ds[sample(s_rows,s_size),] #paysim_ds e целия файл, 6362620 obs. of 11 variables

Две от категорните променливи са проблемни (nameOrig, nameDest), понеже всяко тяхно наблюдение се чете като отделна променлива.


Използваме summary(paysim_s):

    step          type               amount           nameOrig         oldbalanceOrg      newbalanceOrig    
    Min.   : 1.0   Length:100000      Min.   :       0   Length:100000      Min.   :       0   Min.   :       0  
    1st Qu.: 8.0   Class :character   1st Qu.:    9964   Class :character   1st Qu.:       0   1st Qu.:       0  
    Median : 9.0   Mode  :character   Median :   52746   Mode  :character   Median :   20062   Median :       0  
    Mean   : 8.5                      Mean   :  173602                      Mean   :  877758   Mean   :  894062  
    3rd Qu.:10.0                      3rd Qu.:  211763                      3rd Qu.:  190192   3rd Qu.:  214813  
    Max.   :10.0                      Max.   :10000000                      Max.   :33797392   Max.   :34008737  
      nameDest         oldbalanceDest     newbalanceDest        isFraud        isFlaggedFraud
    Length:100000      Min.   :       0   Min.   :       0   Min.   :0.00000   Min.   :0     
    Class :character   1st Qu.:       0   1st Qu.:       0   1st Qu.:0.00000   1st Qu.:0     
    Mode  :character   Median :   20839   Median :   49909   Median :0.00000   Median :0     
                    Mean   :  880505   Mean   : 1184041   Mean   :0.00116   Mean   :0     
                    3rd Qu.:  588272   3rd Qu.: 1058186   3rd Qu.:0.00000   3rd Qu.:0     
                    Max.   :34008737   Max.   :38946233   Max.   :1.00000   Max.   :0
                     
Проверка за липсващи данни (стандартно):

    >sum(is.na(paysim_ds))
    [1] 0
    
## Разпределяне на train и test set (70% - 30%)

    drows = nrow(paysim_s)  #get number of rows

    smple_size = floor(0.7 * (drows - 2))

    # set the seed to make partition reproductible
    set.seed(1) #return the same random value

    train.ind = sample(seq_len(drows),size = smple_size) #seq_len generates sequence
    paysim_s$nameOrig = NULL
    paysim_s$nameDest = NULL
    train = paysim_s[train.ind,]
    test = paysim_s[-train.ind,]

Тук премахваме променливите nameOrig и nameDest.
```
test: 30002 obs. of 9 variables
train: 69998 obs. of 9 variables
```

## Проверка за корелация

Проверяваме за корелация с цел премахване на променливите със сравнително високо ниво на зависимост в модела (по-голяма точност). 

>corr <- cor(paysim_s[,unlist(lapply(paysim_s, is.numeric))])

За корелацията сме махнали променливата isFlaggedFraud, понеже е с нулева вариация и като цяло е ненужна.

![Корелация circles](http://i.imgur.com/CMHdMG6.png)
![Корелация numbers](http://i.imgur.com/vwtH9lv.png)

От изображението се вижда, че променливите oldbalanceOrig и newbalanceOrig, както и oldbalanceDest и newbalanceDest са с висок коефициент на корелация, следователно може да премахнем oldbalanceOrig и oldbalanceDest.

## Логистична регресия
Правим модела, използвайки train set:

     >lg_fit = glm(isFraud ~ amount + newbalanceOrig + newbalanceDest, family = binomial)

Тестваме модела върху test set, използвайки функцията predict:
>lg_reg_probTest = predict(lg_fit,test,type = "response")
Получаваме резултатите:

                   isFraud
    lg_reg_predTest     0     1
                  0 29968    31
                  1     1     2
които показват, че модела правилно предсказва, че 2 от 33 случая са измами и 29 968 от 29 969 не са. 

Получава точност на модела, използвайки (съотношението от сумите на предсказаните стойности за отклика и реалните стойности):

     >sum(lg_reg_predTest)/sum(isFraud)

Среден брой познати измами:

     > mean(lg_reg_predTest == isFraud)
     [1] 0.9989334
     
Можем да получим повече информация, използвайки summary(lg_fit)

      Deviance Residuals:  
          Min       1Q   Median       3Q      Max  
      -1.0035  -0.0555  -0.0508  -0.0294   4.9697  

      Coefficients:
                      Estimate Std. Error z value Pr(>|z|)    
      (Intercept)    -6.486e+00  1.282e-01 -50.606  < 2e-16 ***
      amount          1.419e-06  1.715e-07   8.270  < 2e-16 ***
      newbalanceOrig -2.942e-06  7.680e-07  -3.831 0.000128 ***
      newbalanceDest -4.551e-07  1.240e-07  -3.672 0.000241 ***
      ---
      Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Вижда се, че променливите са достатъчно значими за модела.
Проблема на модела е, че не познава достатъчно добре кога има измама, но може да предскаже сравнително добре кога няма.
Затова ще използваме втори модел, дърво на решенията.

## Дърво на решенията

Първо факторизираме данните за да получим крайна стойност 0 или 1 (да/не).
      
    train$isFraud <- as.factor(train$isFraud)
    test$isFraud <- as.factor(test$isFraud)

Построяваме дървото на решенията върху train set.

     >decisionTreeModel <- train(isFraud~.,method="rpart",data=train)
     
Както при логистичната регресия тестваме модела върху test set.

     test$pred <- predict(decisionTreeModel,test) 
     test = test %>% mutate(accurate = 1*(isFraud == pred))
     table(test$pred,test$isFraud) 

Получаваме следните резултатите
   
           0     1
     0 29969    23
     1     0    10

т.е. познава 10 от 33 измами и всички случаи, в които няма измами. Следователно получаваме по-добри резултати чрез дървото на решенията.

Точността на модела е 0.9992334, получена чрез

     >sum(test$accurate)/nrow(test)

Получаваме plot:

     >fancyRpartPlot(decisionTreeModel$finalModel)
     
![tree](http://i.imgur.com/5l2pbFY.png)

## Заключение

Дървото на решенията предсказва по-точно дали транзакцията ще е измама и е по-удачен избор при повече данни.

Данните (paysim data set) са свалени от [Kaggle](https://www.kaggle.com/ntnu-testimon/paysim1). 
