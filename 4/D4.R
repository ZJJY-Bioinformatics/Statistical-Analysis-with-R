# ------------D4 R作图-------------
# -----------4.1 R自带的一些作图函数---------
# ----------4.1.1 plot(x,y)函数----------
dose <- c(20,30,40,45,60)
drugA <- c(16,20,27,40,60)
drugB <- c(15,18,25,31,40)

dev.new(noRStudioGD = TRUE) #新建作图面板
F1 <- dev.cur()             #获取面板编号
F1
plot(dose,drugA)            
dev.new(noRStudioGD = TRUE) #新建作图面板
F2 <- dev.cur()             #获取面板编号
F2
plot(dose,drugB,type="b")   #type参数指定图形样式
dev.set(which=F1)           #转到F1为当前面板
dev.copy2pdf(file="C:/Users/20842/Desktop/D4/F1.pdf") #保存为pdf
dev.off()                   #关闭F1面板
dev.set(which = F2)         #转到F2为当前面板
dev.copy2pdf(file="C:/Users/20842/Desktop/D4/F2.pdf") #保存为pdf
dev.off()                   #关闭F2面板
# 稍微复杂一些的例子
plot(dose,drugA,
     main="Dose vs Weight",   #图的标题
     xlab="Dose",             #x轴坐标
     ylab="Weight",           #y轴坐标
     xlim=c(0,100),           #x轴范围
     pch=24,                  #绘图符号
     col="navyblue",          #颜色
     bg="yellow",             #填充颜色
     cex=2)                   #符号大小
abline(h=mean(drugA),v=mean(dose),lty=3)
text(dose,drugA,drugA,pos=2,offset=0.5)
# 网上搜“R plot”获取plot函数的参数
# 其他功能，例如加图例（https://blog.csdn.net/weixin_40628687/article/details/118500284）等，
# 可自行网上查找

# -------4.1.2其他函数----------
dev.off()
myData <- data.frame(
  value=c(30,28,28,31,28,29,30,28,30,29,21,19,21,19,20),
  Group=factor(c("A","A","A","A","A","A","A","A","A","A","B","B","B","B","B"))
)
hist(myData$value)                  #频数图
boxplot(myData$value)               #箱线图   
boxplot(myData$value~myData$Group)  #分组箱线图
boxplot(value~Group,data=myData)    #更常见的写法
aNum <- sum(myData$Group=="A")      #逻辑变量在做数值运算时，TRUE为1，FALSE为0。
bNum <- sum(myData$Group=="B")
pie(c(aNum,bNum),label=c("GroupA","GroupB"))  #饼图
#图片布局
dev.off()
mat <- rbind(c(1,1,1),c(2,3,4))
mat
layout(mat)
hist(myData$value)
pie(c(aNum,bNum),label=c("GroupA","GroupB"))
boxplot(myData$value)
boxplot(value~Group,data=myData)
# 热图练习：https://zhuanlan.zhihu.com/p/467174641

# -------------4.2 ggplot2包--------------
install.packages("ggplot2")
library(ggplot2)
# ggplot2中包含一系列执行各种作图动作的函数，不同动作可以用+运算符连接。
#例：
data(mtcars)       #mtcars是R自带的一个数据框，数据来源1974年美国《汽车杂志》，用data()函数导入
ggplot(data=mtcars,mapping=aes(x=wt,y=mpg))  #用ggplot对图的各个元素进行声明，但无具体作图函数
# 画F5
ggplot(data=mtcars,mapping=aes(x=wt,y=mpg)) + geom_point()
# 画F6
ggplot(data=mtcars,mapping=aes(x=wt,y=mpg)) + geom_smooth()
# 画F7
f <- ggplot(data=mtcars,mapping=aes(x=wt,y=mpg)) + geom_point()
f+geom_smooth()
# 作图动作的函数的函数名格式为geom_xxx
# grep("^geom",objects("package:ggplot2"),value=TRUE)

#画F8
ggplot(data=mtcars,aes(x=wt,y=mpg,color=am))+geom_point() #不是想要的结果
mtcars$am <- factor(mtcars$am,levels=c(1,0),labels= c("B","A"),ordered = TRUE)
ggplot(data=mtcars,aes(x=wt,y=mpg,color=am))+geom_point()       
ggplot(data=mtcars,aes(x=wt,y=mpg,shape=am))+geom_point()       
ggplot(data=mtcars,aes(x=wt,y=mpg,color=am))+geom_point()+geom_smooth() #不是想要的结果
ggplot(data=mtcars,aes(x=wt,y=mpg))+geom_point(mapping=aes(color=am))+geom_smooth()

ggplot(data=mtcars,aes(x=wt,y=mpg))+
  geom_point(mapping=aes(color=am))+
  scale_color_manual(values=c("deepskyblue","red"))+         #用color()查看可用的颜色,https://blog.csdn.net/qq_36608036/article/details/124102728
  geom_smooth()

# scale_xxx用来设置图形标度
# grep("^scale",objects("package:ggplot2"),value=TRUE)

ggplot(data=mtcars,aes(x=wt,y=mpg))+
  geom_point(mapping=aes(color=am))+
  scale_color_manual(values=c("deepskyblue","red"))+         
  geom_smooth() +
  theme_bw()                               #设置主题背景

#画F9
## facet函数分面
ggplot(data=mtcars,aes(x=wt,y=mpg)) +
  geom_point() +
  geom_smooth() +
  facet_grid(.~am)

ggplot(data=mtcars,aes(x=wt,y=mpg)) +
  geom_point() +
  geom_smooth() +
  facet_grid(am~.)


## 参考网站：http://www.r-graph-gallery.com
# http://r-graph-gallery.com/89-box-and-scatter-plot-with-ggplot2.html
# www.sthda.com/english/

#小练习（火山图）：https://mp.weixin.qq.com/s?__biz=Mzg2OTcxMzUwNQ==&mid=2247483891&idx=1&sn=c1b1b55b04272dcd57190b5d8fe17dfc&chksm=ce9992fdf9ee1bebb35db1a84cfbb94218964e92cbceb1c88c7f7147cd80777989e558dc8584&mpshare=1&scene=1&srcid=0904tjj3tgxSsofVy5ZcQEoV&sharer_sharetime=1662277755376&sharer_shareid=a21bc68461a00a088b357021b5f54298&exportkey=A1VuTm55P51UAKv4%2FnK0on4%3D&acctmode=0&pass_ticket=7%2FhEu3ihsNBiYqUmSqbDo0%2F%2BZFwiz%2BLtSZeEQB%2F0Het7d2dVtNXcgClS%2B9wXda7o&wx_header=0#rd