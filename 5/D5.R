# ------------------D5-------------------
library(MASS)
data(birthwt)
?birthwt
# ---养成习惯先检查数据类型----
class(birthwt$smoke)
class(birthwt$race)
birthwt$smoke <- factor(birthwt$smoke)
birthwt$race <- factor(birthwt$race)
class(birthwt$smoke)
class(birthwt$race)
# ---------5.1 t检验------------
# 例1：观察吸烟与不吸烟个体的新生儿的体重差异
# -------shapiro.test()进行正态性检验-------
smoke0 <- birthwt$bwt[birthwt$smoke==0]
smoke1 <- birthwt$bwt[birthwt$smoke==1]
shapiro.test(smoke0)
shapiro.test(smoke1)
# ------var.test()进行方差齐次检验-------
var.test(x=smoke0,y=smoke1)
# -------t.test()进行两组t检验--------
t.test(x=smoke0,y=smoke1)
t.test(bwt~smoke,data=birthwt)  #与上一条代码一样
t.test(bwt~smoke,data=birthwt,var.equal=TRUE)
t.test(x=smoke0,y=smoke1,var.equal=TRUE,alt="greater") 
# alt参数选项："two.sided", "less", "greater"
result <- t.test(x=smoke0,y=smoke1,var.equal=TRUE,alt="greater")
result$p.value
# -------例2：联配样本的t检验---------
# 用方法A对10个样本的某个指标进行测量
m <- c(0.84,0.59,0.67,0.63,0.69,0.98,0.75,0.73,1.20,0.87)
# 用方法B对相同10个样本的同一个指标进行测量
n <- c(0.58,0.51,0.50,0.32,0.34,0.52,0.45,0.51,1.00,0.51)
t.test(x=m,y=n,paired=TRUE)
# -------例3：一组数据与某个值比较--------
t.test(x=m,mu=0.7)

# ------------5.2 单因素方差分析------------
# 例4：不同种族新生儿的体重差异
# ------正态性检验----------
race1 <- birthwt$bwt[birthwt$race==1] #race为1的个体对应的bwt
race2 <- birthwt$bwt[birthwt$race==2] #race为2的个体对应的bwt
race3 <- birthwt$bwt[birthwt$race==3] #race为2的个体对应的bwt
shapiro.test(race1)
shapiro.test(race2)
shapiro.test(race3)

# ------方差齐次检验-------
bartlett.test(bwt~race,data=birthwt)
bartlett.test(x=birthwt$bwt,g=birthwt$race)  #bartlett.test的另一种写法，与上面一句相同

# ---用aov进行单因素方差分析-----
race.aov <- aov(bwt~race,data=birthwt)
race.aov
race.summary <- summary(race.aov)
race.summary
race.summary[[1]]$`Pr(>F)`[1]

# --- 5.3 用Bonferroni法、Holm法对各组均值的差异进行成对t检验---
pairwise.t.test(birthwt$bwt,birthwt$race,p.adjust.method = "bonferroni")
pairwise.t.test(birthwt$bwt,birthwt$race,p.adjust.method = "holm")

# --------------- 5.4 两组数据秩和检验 ------------
wilcox.test(x=smoke0,y=smoke1)
wilcox.test(bwt~smoke,data=birthwt)  #与上一条代码一样
wilcox.test(x=smoke0,y=smoke1,alt="greater")
wilcox.test(x=m,y=n,paired=TRUE)

# --------------5.5 多组数据Kruskal-Wallis检验-----------
kruskal.test(bwt~race,data=birthwt)

# ---5.6 用Bonferroni法对各组均值的差异进行成对秩和检验-----
pairwise.wilcox.test(birthwt$bwt,birthwt$race,p.adjust.method = "bonferroni")

