# --------------续D1------------------
# --------------1.8 数据框 ---------------
# --1.8.1用data.frame(列名1=向量1, 列名2=向量2, 列名3=向量3...)创建数据框--
weather <- data.frame(
  Day=c("Saturday","Sunday","Monday","Tuesday","Wednesday"),
  Date=c("Jul 4","Jul 5","Jul 6","Jul 7","Jul 8"),
  TempF=c(75,86,83,83,87)
) 
# R语言在没有歧义的情况下忽略空格和回车。
weather

# -----------1.8.2选中数据框------------
# --------1.8.2.1 用[,]，和矩阵类似---------
weather[1:4,1:3]
weather[-1,-3]
weather[1:4,]
weather[,c("Date","TempF")]
weather[,2] #R语言会自动简化数据结构，和矩阵类似
weather[,2,drop=FALSE]

# --------1.8.2.2 用[],中括号里没有逗号----------
weather[3]

# --------1.8.2.3 用[[]]-------------
weather[[3]]

# --------1.8.2.4 用$,较常用-----------
weather$TempF
weather$TempF[1:3]
weather$TempF[-(1:3)]
weather$TempF[c(FALSE,TRUE,FALSE,FALSE,FALSE)]
# 显示气温大于85的日期
weather$Date[weather$TempF>85]  #返回一个向量，向量里的元素为气温大于85的日期。
# 只显示数据框中除Sunday外的其他记录
weather
weather[weather$Day!="Sunday",] #返回一个数据框，数据框中不含Sunday行。

# --------1.8.3 修改数据框-----------
weather
weather$TempC <- c(24,30,28,28,31)
weather

# --------1.8.4 几个常用函数 -----------
nrow(weather)
ncol(weather)
colnames(weather) #返回一个向量，向量中每一个元素对应数据框的列名
rownames(weather)
rownames(weather) <- c("record_1","record_2","record_3","record_4","record_5")
weather
weather$record <- rownames(weather) #有时需要把行名变成某一列，或者把某一列变成行名。
weather
# colnames()和rowname()同样适用与矩阵

# ----------------1.9列表----------------
# -----------1.9.1 用list()函数创建列表----------
aVector <- c("A","C","G","T","T","C","G","A") #Seq为字符向量
aVector
aMatrix <- rbind(c(1,900),c(1001,1900),c(2001,2900)) #CDS为数值矩阵
aMatrix
unnamedList <- list(aVector,aMatrix)
unnamedList
namedList <- list(Seq=aVector,CDS=aMatrix)
namedList

# ----------1.9.2 用[]，[[]]和$选中列表元素---------
namedList[2]   #返回一个列表
namedList[c(TRUE,FALSE)]
namedList["CDS"]
namedList[[2]] #返回一个矩阵
namedList$CDS

# --------1.9.3修改列表元素------------
namedList[1] <- c("C","A","T","T","C","G","G","A") # <-左边是个列表，右边是个向量，赋值会有错误
namedList
namedList[[1]] <- c("C","A","T","T","C","G","G","A")
namedList

# ------------------D2----------------
# ------------2.1回顾函数的调用格式-------------
# 函数名(参数1=用户输入1, 参数2=用户输入2, 参数3=用户输入3...)
seq(from=1,to=5,length=10)
seq(1,5,length=10)

# ----------2.2自己写函数---------
# 创建一个函数，该函数让用户输入两个数x和y，然后返回2x+y的值
cal_2xPlusy <- function(x,y){
  x <- x*2
  result <- x+y
  result
}

cal_2xPlusy(x=1,y=2)

a <- 3
b <- 4
cal_2xPlusy(x=a,y=b)

x <- 5
y <- 6
cal_2xPlusy(x=x,y=y) #x=x中第一个x是函数的形式变量，第二个x是用户输入的，两个x互相独立。

#赋值
s <- cal_2xPlusy(x=1,y=2)

#创建函数时可设定默认值
cal_2xPlusy.v2 <- function(x,y=2){
  x <- x*2
  result <- x+y
  result
}

cal_2xPlusy.v2(3)

cal_2xPlusy.v2("a") #用别人的函数时首先要明确函数的输入和输出是什么

# 一个函数只能返回一个变量
# 创建一个函数，该函数让用户输入两个数x和y，然后返回两个数的和与差
PlusAndMinus <- function(x,y){
  PLUS <- x+y
  MINUS <- x-y
  list(plus=PLUS,minus=MINUS)
}

result <- PlusAndMinus(3,5)
result
result$plus
result$minus

# --------------2.3条件语句------------
# -------例1,最简单的if...else...结构
#            创建一个函数，该函数让用户输入一个分数，
#            如果该分数超过60，则返回字符"Pass"
#            否则返回字符"No Pass"
is.pass <- function(score){
  if (!score < 60){
    result <- "Pass"
  }
  else{
    result <- "No Pass"
  }
  result
}

is.pass(90)
is.pass(40)

# ------例2,多个if...else...嵌套形成多项选择------
#           创建一个函数，该函数让用户输入一个分数，
#           85分以上显示"very good"
#           60分以上85分以下显示"good"
#           60分以下显示"poor"
grade <- function(score){
  if (score>85){
    result <- "very good"
  }
  else{
    if (score>60){
      result <- "good"
    }
    else{
      result <- "poor"
    }
  }
  result
}

grade(75)
# ------例3,多个if...else if...else if...else创建多项选择
#           创建一个函数，该函数让用户输入一个分数，
#           85分以上返回"A"
#           70以上85分以下返回"B"
#           60以上70分以下返回"C"
#           60以下返回"D"

grade_4class <- function(score){
  if (score >= 85){
    result <- "A"
  }
  else if (score >= 70){
    result <- "B"
  }
  else if (score >= 60){
    result <- "C"
  }
  else{
    result <- "D"
  }
  result
}

grade_4class(65)

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

for (r in 1:nrow(value)){      #第一层循环，从第一行到最后一行
  for (c in 1:ncol(value)){    #第二层循环，每一行中从第一列到最后一列
    if (value[r,c]==0){        #若第r行第j列的数为0
      value[r,c] <- 0.001      #将第r行第j列改为0.001
    }
    else {}                    #否则不做处理（如果else后没有操作的话，这行代码可省略）
  }
}

value

