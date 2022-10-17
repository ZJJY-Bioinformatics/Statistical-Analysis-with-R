# ----------------------------D8--------------------------
# ---------------------8.1 PCA----------------
#https://zhuanlan.zhihu.com/p/497474588
data(iris)
com1 <- prcomp(iris[,1:4], center = TRUE,scale. = TRUE) #建议都做标准化
com1$x  #数据在各PC的坐标
com1$rotation  #载荷矩阵（旋转矩阵）
summ<-summary(com1)
summ$importance

#根据坐标数据作图
xlab<-paste0("PC1(",round(summ$importance[2,1]*100,2),"%)")
ylab<-paste0("PC2(",round(summ$importance[2,2]*100,2),"%)")
df1<-com1$x 
df1<-data.frame(df1,iris$Species) 
library(ggplot2)
p1<-ggplot(data = df1,aes(x=PC1,y=PC2,color=iris.Species))+
  stat_ellipse(aes(fill=iris.Species), type = "norm", geom ="polygon",alpha=0.2,color=NA)+ 
  geom_point()+
  labs(x=xlab,y=ylab,color="")+
  guides(fill="none")
p1


# -----------8.2 OPLA-DA----------
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ropls")
library(ropls)
data("sacurine")
View(sacurine$dataMatrix)
View(sacurine$sampleMetadata)

dataMatrix <- sacurine$dataMatrix
genderFc <- sacurine$sampleMetadata[,"gender"]

set.seed(123)
oplsda <- opls(dataMatrix,genderFc, predI=1, orthoI = NA)
#若执行PLS-DA，则orthoI设为0，predI可设为NA
#左上图的数据来自oplsda@modelDF$`R2Y(cum)`和oplsda@modelDF$`Q2(cum)`
# 由下图横坐标的百分数在oplsda@modelDF$R2X[1]中
oplsda@summaryDF$`R2X(cum)`   #R2X指标
oplsda@summaryDF$`R2Y(cum)`   #R2Y指标
oplsda@summaryDF$`Q2(cum)`    #Q2Y指标
oplsda@summaryDF$pR2Y         
oplsda@summaryDF$pQ2


p1 <- oplsda@scoreMN            #预测成分（横轴）坐标
o1 <- oplsda@orthoScoreMN[,1]   #正交成分（纵轴）坐标
sample.score <- data.frame(p1,o1,genderFc)

p <- ggplot(sample.score, aes(p1,o1,color=genderFc))+
  geom_point()+
  geom_hline(yintercept = 0,linetype="dashed",size=0.5)+
  geom_vline(xintercept=0, linetype="dashed",size=0.5)+
  labs(x="P1(5.0%)",y="to1")+
  stat_ellipse(level=0.95,linetype="solid",size=1,show.legend=FALSE)+
  scale_color_manual(values=c("#008000","#FFA74F"))+
  theme_bw()+
  theme(legend.position=c(0.1,0.85),
        legend.title=element_blank(),
        legend.text=element_text(color="black",size=15,family="Arial",face="plain"),
        axis.title=element_text(color="black",size=15,family="Arial",face="plain"))
p

vip <- getVipVn(oplsda)
vip_select <- vip[vip>1]
vip_select

# --------------8.3 因子分析----------------
cormat<- matrix(c(1,0.439,0.410,0.288,0.329,0.248,
                  0.439,1,0.354,0.354,0.320,0.329,
                  0.410,0.354,1,0.164,0.190,0.181,
                  0.288,0.354,0.164,1,0.595,0.470,
                  0.329,0.320,0.190,0.595,1,0.464,
                  0.248,0.329,0.181,0.470,0.464,1),
                nrow=6)
rownames(cormat) <- c("盖尔语","英语","历史","算术","代数","几何")
colnames(cormat) <- c("盖尔语","英语","历史","算术","代数","几何")
cormat
library(psych)
fa.parallel(cormat,n.obs=220,fm="ml") 
#n.obs:样本数
#因子个数选择依据：《R语言实践（第二版》第299页与307页
FA1 <- fa(cormat,nfactors = 2,n.obs = 200,rotate = "none",fm="ml")
FA1

FA2 <- fa(cormat,nfactors = 2,n.obs = 200,rotate = "varimax",fm="ml")
#因子旋转的方法：正交旋转（方差最大旋转、四次方最大旋转、均方最大旋转）和斜交旋转
FA2

fa.diagram(FA2,digits=2)

# ---------8.4 生存分析----------
library(survival)
ovarian <- survival::ovarian
ovarian$resid.ds <- factor(ovarian$resid.ds,
                           levels=c(1,2),
                           labels=c("no","yes"))
ovarian$rx <- factor(ovarian$rx,
                     levels=c(1,2),
                     labels=c("A","B"))
ovarian$ecog.ps <- factor(ovarian$ecog.ps,
                          levels=c("1","2"),
                          labels=c("good","bad"))
ovarian$agegr <- cut(ovarian$age,
                     breaks=c(0,50,75),
                     labels=c("<=50",">50"))
surv.obj <- Surv(time=ovarian$futime,even=ovarian$fustat) #数据整理
surv.obj
surv.all <- survfit(surv.obj ~ 1) #生存率估计
summary(surv.all,censored=TRUE)
plot(surv.all,mark.time=TRUE)  #生存曲线（Kaplan-Meier图）
install.packages("survminer")
library(survminer)
ggsurvplot(surv.all,data=ovarian) #绘制生存曲线的另一种方法
surv.treat <- survfit(surv.obj ~ rx, data=ovarian) #生存率比较
summary(surv.treat)
ggsurvplot(surv.treat,data=ovarian,pval=TRUE) #两组生存曲线
survdiff(surv.obj~rx,data=ovarian)  #生存率比较
cox1 <- coxph(surv.obj~rx+resid.ds+agegr+ecog.ps,data=ovarian) #构建Cox回归
summary(cox1)
drop1(cox1)
cox2 <- step(cox1) #逐步回归
cox.zph(cox2)  #比例风险假定的检验
summary(cox2)
pred <- data.frame(rx=factor(c(1,2),levels = c(1,2),labels = c("A","B")),
                   resid.ds=factor(c(1,1),levels=c(1,2),labels=c("no","yes")),
                   agegr=factor(c(">50",">50"),levels=c("<=50",">50")))
hr <- predict(cox2,newdata=pred,type="risk") 
hr
hr[1]/hr[2]
#死亡风险比是3.599421
#年龄大于50岁且没有疾病残留的患者，采用治疗方法“A”的死亡风险
#是采用治疗方法“B”的死亡风险的3.599421倍
cox.fit <- survfit(cox2,newdata=pred,type="kaplan-meier")
plot(cox.fit,lty=c(1,2),col=c(2,4))
title(main="Cox survival curves by treatment
      for age > 50, no residual disease patients",
      xlab="Duration in days",
      ylab="Survival probability",
      las=1)
legend(5,0.3,c("Treatment A","Treatment B"),
       lty=c(1,2),col=c(2,4))
