# ------------D7-------------
# ---------7.1 变量的相关性--------
# ---------7.1.1 cor()函数计算相关系数---------
library(MASS)
data(birthwt)
vars <- birthwt[,c("age","lwt","bwt")]
cor.pearson <- cor(vars,method="pearson")
cor.pearson
cor.spearman <- cor(vars,method="spearman")
cor.spearman
cor.kendall <- cor(vars,method="kendall")
cor.kendall
# --------7.1.2 corr.test()函数进行相关显著性检验------
install.packages("psych")
library(psych)
pearson.test <- corr.test(vars,method="pearson")
pearson.test
pearson.test$r
pearson.test$p
spearman.test <- corr.test(vars,method="spearman")
spearman.test
kendall.test <- corr.test(vars,method="kendall")
kendall.test
# ---------7.1.3 pcor()函数计算偏相关系数---------
install.packages("ggm")
library(ggm)
r <- pcor(c(2,3,1),cov(vars)) #c(2,3,1)的含义：控制第1个变量，计算第2、3个变量的相关系数
r
# ---------7.1.4 pcor.test()函数进行偏相关显著性检验-----
pcor.test(r,q=1,n=nrow(vars))
# 第一个参数r为函数pcor()的输出结果，第二个参数q为条件变量个数，第三个参数n为样本量

# --------7.1.5 assocstats()函数和kap()计算分类变量相关性------
install.packages("vcd")
library(vcd)
birthwt$smoke <- factor(birthwt$smoke,level=c(0,1),label=c("no_smoke","smoke"))
birthwt$race <- factor(birthwt$race,level=c(1,2,3),label=c("white","black","other"))
mytable <- table(birthwt$race,birthwt$smoke)
mytable
chisq.test(mytable)
assocstats(mytable)

install.packages("epiDisplay")
library(epiDisplay)
my.matrix <- matrix(c(11,2,12,33),nrow=2)
kap(my.matrix)

# -----------7.2线性回归------------
UCR <- read.table(file="C:/2022R/D7/UCR.tsv",sep = "\t",header = TRUE)
class(UCR$group)
UCR$group <- factor(UCR$group,levels = c("Normal","Patient"))
class(UCR$group)
plot(UCR$age,UCR$ucr,
     xlab="Age in years",
     ylab="Urine creatinine (mmol)")
mod <- lm(ucr~age, data=UCR)
mod                 #ucr=1.4352+0.1509*age
mod$fitted.values   #拟合值
mod$residuals       #残差
mod$fitted.values+mod$residuals == UCR$ucr
summary(mod)

abline(mod)
points(UCR$age,mod$fitted.values,pch=18,col="blue")
segments(UCR$age,UCR$ucr,UCR$age,mod$fitted.values,col="green")

#----线性回归解决非线性问题----------
mod1 <- lm(ucr~age+group,data=UCR)
mod1        # ucr=1.4241+0.1642*age-0.2176*group
summary(mod1)
mod2 <- lm(ucr~age+group+age:group,data=UCR)
mod2         # ucr=1.66167+0.13917*age-0.58696*group+0.03655*age*group
#当group=0时， ucr=1.66167+0.13917*age
#当group=1时， ucr=1.07471+0.17572*age
summary(mod2)

# -----特征筛选----
install.packages("ISwR")
library(ISwR)
data(cystfibr)
class(cystfibr$sex)
cystfibr$sex <- factor(cystfibr$sex, levels = c(0,1),labels = c("male","female"))
fit1 <- lm(fev1~age+sex+height+weight+bmp,data=cystfibr)
summary(fit1) #fev1=19.28794-0.16431*age-10.04122*sex-0.07645*height+0.20274*weight+0.33373*bmp


drop1(fit1,test="F")
fit2 <- step(fit1)
summary(fit2) #fev1=4.0231-10.2100*sex+0.4495*bmp

# -------预测----------
predata=data.frame(
  sex=factor(0,levels = c(0,1),labels = c("male","female")),
  bmp=70
)
Pre <- predict.lm(fit2,newdata=predata)
Pre

# ---回归诊断-----
install.packages("gvlma")
library(gvlma)
gvlma(fit2)  #判断模型是否符合最小二乘法假设
library(epiDisplay)
regress.display(fit2) #汇总输出

# ---------7.3逻辑回归--------
library(MASS)
data(birthwt)

birthwt$race <- factor(birthwt$race,levels=c(1,2,3), labels=c("white","black","other")) 
birthwt$smoke <- factor(birthwt$smoke,levels=c(0,1),labels=c("no","yes"))
birthwt$ptl <- factor(birthwt$ptl>0,levels=c(FALSE,TRUE),labels=c("0","1+"))
birthwt$ht <- factor(birthwt$ht,levels=c(0,1),labels=c("no","yes"))
birthwt$ui <- factor(birthwt$ui,levels=c(0,1),labels=c("no","yes"))
for (i in 1:nrow(birthwt)){
  birthwt$ftv[i] <- min(birthwt$ftv[i],2)
}
birthwt$ftv <- factor(birthwt$ftv,levels=c(0,1,2),labels=c("0","1","2+"))
birthwt$low <- factor(birthwt$low,levels = c(0,1),labels = c("no","yes"))
glm1 <- glm(low~age+lwt+race+smoke+ptl+ht+ui+ftv,data=birthwt,family = binomial)
summary(glm1)

# ----逐步回归特征选择------
drop1(glm1)
glm2 <- step(glm1)
glm2
glm2$coefficients #回归系数，变量对优势比对数的影响
exp(glm2$coefficients)  #回归系数指数，变量对优势比的影响
#解释：lwt（母亲怀孕期体重）每增加1lb，新生儿患病（低体重）事件发生的优势乘以0.98
confint(glm2) #回归系数置信区间
exp(confint(glm2)) #回归系数置信区间指数
logistic.display(glm2)

# -----测试----
newdata <- data.frame(lwt=120,race="black",
                      smoke="yes",ptl="0",
                      ht="yes",ui="no")
p1 <- predict(glm2,newdata = newdata)
p1 #输出优势对数比
p2 <- predict(glm2,newdata = newdata,type="response")
p2 #输出概率

# -----多分类逻辑回归------
data(Ectopic)
class(Ectopic$outc)
class(Ectopic$hia)
class(Ectopic$gravi)
library(nnet)
Ectopic_1 <- Ectopic[1:720,]
Ectopic_2 <- Ectopic[721:723,]
multi <- multinom(outc~hia+gravi, data=Ectopic_1)
coef(multi)    #回归系数
exp(coef(multi))
mlogit.display(multi)
predict(multi,newdata=Ectopic_2)
predict(multi,newdata=Ectopic_2,type="prob")

install.packages("caret", dependencies = TRUE)
install.packages("randomForest")
library(caret)
library(randomForest)
train <- read.table("C:/2022R/D7/titanic/train.csv", sep=",", header= TRUE)
test <- read.table("C:/2022R/D7/titanic/test.csv", sep = ",", header = TRUE)
#删除缺失值
train<-na.omit(train)

class(train$Survived)
train$Survived <- factor(train$Survived)
class(train$Pclass)
class(train$Sex)
train$Sex <- factor(train$Sex)
test$Sex <- factor(test$Sex)
class(train$SibSp)
class(train$Parch)
class(train$Fare)
set.seed(222) # 设置随机数种子，保证结果的可重复性
rf <- randomForest(Survived~Pclass+Sex+SibSp+Parch+Fare, # Survived作为目标变量
                   data=train, # 使用训练集构建随机森林
                   ntree = 500, # 决策树的数量，默认的是500
                   importance = TRUE, # 是否评估预测变量的重要性
                   proximity = TRUE) # 是否计算行之间的接近度
#导出重要性
imp= as.data.frame(rf$importance) 
imp = imp[order(imp[,1],decreasing = T),]
imp
varImpPlot(rf)
pred <- predict(rf, newdata = test)
pred
pred <- predict(rf, newdata = test,type = "prob")
pred
