# -----------续D2---------------
# --------------2.4 循环语句----------
# -------------2.4.1 for循环--------------
# 例4，求每个人的平均分
scores <- data.frame(names=c("Zhangsan","Lisi","Wangwu"),
                     Yuwen=c(68,70,59),
                     Shuxue=c(98,80,88),
                     Yingyu=c(60,88,91),
                     average=c(0,0,0))
for (i in 1:nrow(scores)){
  scores$average[i] <- (scores$Yuwen[i]+scores$Shuxue[i]+scores$Yingyu[i])/3
}
# 第一轮，i取1，执行scores$average[1] <- (scores$Yuwen[1]+scores$Shuxue[1]+scores$Yingyu[1])/3
# 第二轮，i取2，执行scores$average[2] <- (scores$Yuwen[2]+scores$Shuxue[2]+scores$Yingyu[2])/3
# 第三轮，i取3，执行scores$average[3] <- (scores$Yuwen[3]+scores$Shuxue[3]+scores$Yingyu[3])/3

# ----------2.4.2 while循环------------
# --------例5. 计算1+2+3+...+100
s <- 0
i <- 1
while (i<=100){
  s <- s+i
  i <- i+1
}
s
# 第1轮，s取0，i取1, i<=100为TRUE，执行s <- 0+1, i <- 1+1。
# 第2轮，s取1，i取2，i<=100为TRUE，执行s <- 1+2, i <- 2+1。
# 第3轮，s取3，i取3, i<=100为TRUE, 执行s <- 3+3, i <- 3+1。
# 如此类推
# 第100轮，s取4950，i取100，i<=100为TRUE，执行s <- 4950+100, i <- 100+1
# 第101轮，s取5050，i取101，i<=100为FALSE，结束循环。

# -----小练习，循环、条件语句多层嵌套---------
value <- rbind(c(3,0,0,2),c(0,4,9,0),c(1,0,3,1))
value
# 把矩阵value中所有为0的值变为0.001（这种操作在很多数据分析中会用到，特别是需要进行对数变换时）

for (r in 1:nrow(value))
{                              #第一层循环，从第一行到最后一行
  for (c in 1:ncol(value))
    {                          #第二层循环，每一行中从第一列到最后一列
      if (value[r,c]==0)
        {                      #若第r行第j列的数为0
         value[r,c] <- 0.001   #将第r行第j列改为0.001
        }
    else {}                       #否则不做处理（如果else后没有操作的话，这行代码可省略）
  }
}

value

# -----------D3--------------
# ---------3.1 读写表格-----------
# 文件路劲中把\改成/
demoData <- read.table("C:/Users/Meeting/Desktop/R/D3/demoData.csv",header=TRUE,sep=",") 
demoData2 <- read.table("C:/Users/Meeting/Desktop/R/D3/demoData.csv",header=FALSE,sep=",")

weather <- data.frame(
  Day=c("Saturday","Sunday","Monday","Tuesday","Wednesday"),
  Date=c("4-Jul","5-Jul","6-Jul","7-Jul","8-Jul"),
  TempF=c(75,86,83,83,87)
)
write.table(weather,file="C:/Users/Meeting/Desktop/R/D3/weather.csv",sep=",",row.name=FALSE,col.name=TRUE,quote=FALSE)

# 以Tab键分割列
write.table(weather,file="C:/Users/Meeting/Desktop/R/D3/weather.tsv",sep="\t",row.name=FALSE,col.name=TRUE,quote=FALSE)

#工作目录
getwd()
setwd("C:/Users/Meeting/Desktop/R/D3/")

# ------- 3.2 表格排序----------
order(weather$TempF) #从小到大
weather[order(weather$TempF),]
weather[order(-weather$TempF),] #从大到小

# ------- 3.3 表格长宽转化---------
#安装reshape2包
install.packages("reshape2")  #从https://cran.r-project.org/下载安装
#加载R包
library(reshape2)
r <- read.table("C:/Users/Meeting/Desktop/R/D3/record.tsv",header=TRUE,sep="\t")
r_long <- reshape2::melt(r,id.vars=c("Subject","Group"),measure.vars=c("T0","T1","T2","T3"))
r_long <- melt(r,id.vars=c("Subject","Group"),measure.vars=c("T0","T1","T2","T3"),
               variable.name = "Time",value.name = "weight")
# -------3.4 dplyr包-----------
install.packages("dplyr")
library(dplyr)
birthwt <- read.table("C:/Users/Meeting/Desktop/R/D3/birthwt.tsv",header=TRUE,sep="\t")
# -------3.4.1filter函数选择------
filter(birthwt,birthwt$age>35)
filter(birthwt,age>35)
filter(birthwt,bwt<2500 | bwt >4000)
filter(birthwt,age>35, bwt<2500 | bwt>4000 )

# -----------3.4.2合并表格--------
Data1 <- data.frame(
  Subject=c("A","B","C"),
  value1=c(75,64,92)
)
Data2 <- data.frame(
  Subject=c("A","C","D"),
  value2=c(51,68,32)
)
full_join(Data1,Data2,by="Subject")   #并集。注意：NA不是0，代表有有值但不知道是什么
inner_join(Data1,Data2,by="Subject")  #交集

# ------3.5统计量计算--------
age <- c(38,20,44,41,46,49,43,23,28,32)
mean(age) #均值
median(age) #中位数
var(age) #方差
sd(age) #标准差
max(age) #最大值
min(age) #最小值
sum(age) #求和

#对NA的处理
age[3] <- NA
age
mean(age)
mean(age,na.rm=TRUE)
#NA的任何运算都是NA
1+NA
age==NA
is.na(NA)
# ------3.6操作文件--------
file.copy(from="C:/Users/Meeting/Desktop/R/D3/weather.csv",to="C:/Users/Meeting/Desktop/weather2.csv")

#https://blog.csdn.net/weixin_39548968/article/details/112582863
#遇到看不懂的函数：搜索“R+函数名”
#不知用什么函数：搜索“R+想完成的内容”