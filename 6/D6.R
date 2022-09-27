# ---------------D6---------------

## 协方差分析 ##
install.packages("multcomp")
library(multcomp)
data(litter)
class(litter$dose)
fit <- aov(weight~gesttime+dose,data=litter) #注意顺序，协变量需要在前面
summary(fit)
fit <- aov(weight~dose+gesttime,data=litter)
summary(fit)
################

## 双因素方差分析 ##
data(ToothGrowth)
class(ToothGrowth$supp)
class(ToothGrowth$dose)
ToothGrowth$dose<-factor(ToothGrowth$dose) #这句可选，是否执行对结果有轻微影响
fit<-aov(len ~ supp+dose+supp:dose, data=ToothGrowth)
summary(fit)
fit<-aov(len ~ supp*dose, data=ToothGrowth) #简写
summary(fit)

#注意aov对自变量顺序的处理
install.packages("car")
library(car)
Anova(fit,type=3)  #调用类型Ⅲ方法
########################

##重复测量分析###
data(CO2)
subCO2 <- CO2[CO2$Treatment=="chilled",]
class(subCO2$conc)
subCO2$conc <- factor(subCO2$conc) #可选
fit <- aov(uptake ~ conc*Type+Error(Plant/conc),data=subCO2)
summary(fit)
#################

##多元方差分析##
#研究美国谷物中的卡路里、脂肪和糖含量
#是否会因为储存架位置的不同而发生变化
library(MASS)
data(UScereal)
y <- cbind(UScereal$calories,UScereal$fat,UScereal$sugars)
y
colnames(y) <- c("calories","fat","sugars")
y
fit <- manova(y~shelf,data=UScereal)
summary(fit)
summary.aov(fit) #输出单变量结果

#若不满足多元正态性
install.packages("rrcov")
library(rrcov)
Wilks.test(y,UScereal$shelf,method="mcd")

##更多的非正态检验，如菌群数据常用的adonis，可自行查阅相关资料。


##卡方检验
library(MASS)
data(birthwt)
?birthwt
class(birthwt$low)
class(birthwt$smoke)
class(birthwt$race)
birthwt$low <- factor(birthwt$low,level=c(0,1),label=c("no_low","low"))
birthwt$smoke <- factor(birthwt$smoke,level=c(0,1),label=c("no_smoke","smoke"))
birthwt$race <- factor(birthwt$race,level=c(1,2,3),label=c("white","black","other"))
class(birthwt$low)
class(birthwt$smoke)

num <- rbind(c(86,29),c(44,30))
num
chisq.test(num)
myTable <- table(birthwt$smoke,birthwt$low)
myTable
result <- chisq.test(myTable)
result
result$expected
chisq.test(myTable,correct = FALSE) #理论频数大于5时可以将correct设为FALSE
fisher.test(myTable) #总记录数小于40，或某个期望频数小于1，要用Fisher精确检验

##多重比较调整p阈值##

#对某个变量进行矫正后的卡方检验
mytable <- table(birthwt$low,birthwt$smoke,birthwt$race)
mytable
mantelhaen.test(mytable)

#配对列表的卡方检验
my.matrix <- matrix(c(11,2,12,33),nrow=2)
my.matrix
mcnemar.test(my.matrix)