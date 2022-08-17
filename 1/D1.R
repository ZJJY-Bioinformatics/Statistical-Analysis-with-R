# ----------1.1 R数据类型-----------
4  #数值型
5
4+5
"Hello" #字符型
TRUE  #逻辑型
FALSE
4 > 5
4 <= 5

# ----------1.2 R常用运算符号-----------
4+5
4-5
4*5
4/5
4^5
(3+(4+2)*3)*5 #只能用小括号

3*3 == 3^2 #两个等号
3*2 == 3^2
3 != 5
"Hello" == "hello"
3*2 < 3^2
3*3 == 3^2 & 3*2 == 3^2
3*3 == 3^2 | 3*2 == 3^2
(3*3 == 3^2) & (3*2 == 3^2)

# --------1.3 赋值----------
a <- 3+5 #无输出，Environment会显示对象a
a
b <- 2
c <- a*2 
c
a <- a+1
a
c <- a*b+1
d <- a==b
d
e <- "Hello"
my.Value_1 <- 1+1 #对象命名规则，可用部分特殊字符，可以有数字
a <- "a"
b <- "1"

##小练习，交换x,y##
x <- 99
y <- 1
# y <- x
# x <- y
z <- y
y <- x
x <- z

## 函数：函数名(参数1=..., 参数2=..., 参数3=...)
seq(from=1,to=99,by=2)
seq(1,99,by=2) #参数按顺序时，参数名可以省略，没列出来的参数为默认值
seq(x,y,by=2)

# ------------ 1.4 向量--------------
# ------------ 1.4.1 创建向量-----------
# ------------1.4.1.1 c()函数创建向量-------------
numericVector <- c(2,6,8,4,2,9,4,0)
numericVector
numericVector + c(1,2,3,4,5,6,7,8)
c("Zhangsan","Lisi","Wangwu")
c(TRUE,FALSE,TRUE,TRUE)
c(T,F,T,T) #不建议简写TRUE和FALSE

X <- c(1,2,3,4,5,6,7,8,9,10)
X
c(X,X,X,X,X,1)
X <- c(X,X,X,X,X,1)
X

# ---------1.4.1.2使用:创建向量----------
X <- c(1,2,3,4,5,6,7,8,9,10)
X
X <- 1:10

1:5
5:1
-1:1
1.3:5.3
c(0:4,5,4:0)
2*1:10

# ---------1.4.1.3使用seq()函数创建向量-----
1:10
seq(1,10)
seq(1,10,by=0.5)
seq(2,20,by=2)
seq(5,-5,by=-2)
seq(1.3,8.4,length=10)

# --------1.4.1.4使用rep()函数创建向量------
rep("Hello",5)
X <- c(1,2,3,4,5,6,7,8,9,10)
rep(X,5)
X <- rep(1:10,5)
rep(c("GroupA","GroupB","Control"),c(50,20,30))

##遇到嵌套结构时，逐步执行
X <- c(seq(1,10,by=2),rep(3:5,2),c(3,6,9))
X
## 忘记函数的功能可以直接百度R+函数名，或?函数名 ###

##给向量元素命名
Height <- c(Zhangsan=165,Lisi=170,Wangwu=160)
Height

# -----------1.4.2选中向量元素：向量名[向量] -----------
# -----------1.4.2.1用坐标选---------------
X <- c(1,8,2,1,3)
X
X[c(1,3,5)]
index <- c(1,3,5)
X[index]
X[index] <- c(6,3,7) #修改
X
#反选
X[-3]
X[c(-2,-4)]
# -----------1.4.2.2用逻辑值选------------
X
X[c(TRUE,TRUE,FALSE,FALSE,TRUE)]

# 通过逻辑选出符合条件的数
X
X > 5
X[X>5]
X[X<=6]
X[X!=6]
X[X>=3 & X<=7] #遇到嵌套的代码，逐步执行

# ----------1.4.2.3用名字选-------------
Height <- c(Zhangsan=165,Lisi=170,Wangwu=160)
Height
Height[c("Zhangsan","Wangwu")]
# names()函数的两个作用
names(Height) #提取名字
names(Height) <- c("ZHANGSAN","LISI","WANGWU") #修改名字
Height

# 一些R中已定义的向量
LETTERS
letters

# ------------------1.5 因子---------------------
# factor(vector, level=, label=)
sex <- c(1,2,1,1,2,1,2)
sex
sex.f <- factor(sex,levels=c(1,2),labels=c("Male","Female"))
sex.f
# labels参数对程序不是必须的
sex <- c("Male","Female","Male","Male","Female","Male","Female")
sex.f <- factor(sex,levels=c("Male","Female"))
sex.f

status <- c(1,2,2,3,1,2,2)
status.f <- factor(status,
                   levels=c(1,2,3),
                   labels=c("Poor","Improved","Excellent"),
                   ordered = TRUE)
status.f

# ----------------1.6矩阵---------------
# --------------1.6.1创建矩阵--------------
# -----------1.6.1.1用cbind()函数创建矩阵-----------
cbind(1:3,3:1,c(2,4,6),rep(1,3))
# -----------1.6.1.2用rbind()函数创建矩阵-----------
rbind(1:3,3:1,c(2,4,6),rep(1,3))
# ----------1.6.1.3用matrix函数创建矩阵------------
matrix(1:12, nrow=3,ncol=4)
matrix(1:12, nrow=3)
matrix(1:12, nrow=3,byrow=TRUE)
matrix(1:12, nrow=3,byrow=FALSE)

aVector <- c(4,5,2,7,6,1,5,5,0,4,6,9)
X <- matrix(aVector, nrow=3)

X
# ---------1.6.2选中矩阵元素：矩阵名[向量1,向量2]------------------
# -----------1.6.2.1用坐标选---------------
X[1:2,c(1,3,4)]
X[,-2]
X[1:2,]
X[,1] #注意R会自动简化数据结构
X[,1,drop=FALSE]
X

X[c(2,3),c(1,4)] <- cbind(c(50,20),c(60,90))
X
X <- X[c(2,1,3),]
X
X <- rbind(X,c(0,0,0,0))
X

# -----------1.6.2.2 用逻辑值选------------
X
X[c(TRUE,FALSE,TRUE,TRUE),]
X[X[,1]!=50,]

# ---------------1.7 数组--------------
aVector <- rep(c(4,5,2,7,6,1,5,5,0,4,6,9),3)
X <- array(aVector,dim=c(3,4,3))
X
X[,,1]
X[-1,1:2,1:3]

# -------------1.8 数据框（重要）------------
# -------------1.8.1用data.frame()函数创建数据框
weather <- data.frame(
  Day=c("Saturday","Sunday","Monday","Tuesday","Wednesday"),
  Date=c("Jul 4","Jul 5","Jul 6","Jul 7","Jul 8"),
  TempF=c(75,86,83,83,87)
)
weather

# -----------1.8.2 选中数据框数据-------------
weather[3]
weather[[3]]
weather$TempF
weather$TempF[1:3]
weather$TempF[-(1:3)]
weather$TempF[c(FALSE,TRUE,FALSE,FALSE,TRUE)]
weather$TempF[weather$TempF > 85 ]
weather$Day[weather$TempF > 85]

weather[1:4,1:3]
weather[-1,-3]
weather[1:4,]
weather[weather$TempF>85,]
weather[weather$Day!="Sunday",]
weather[weather$TempF>85,c("Day","Date")]



#区分
weather[3]
weather[[3]]
weather[,3]
weather[,3,drop=FALSE]

#修改
weather
weather$TempC <- c(24,30,28,28,31)

#几个重要函数
nrow(weather)
ncol(weather)
colnames(weather)
rownames(weather)
rownames(weather) <- weather$Day
weather
weather$new_col <- rownames(weather)
weather

# ---------------1.9列表---------------
# ---------------1.9.1用list()函数创建列表
aVector <- c(5,7,8,2,4,3,9,0,1,2)
aVector
aMatrix <- matrix(c("A","B","C","D","E","F"),nrow=3)
aMatrix
unnamedList <- list(aVector,aMatrix)
unnamedList
namedList <- list(VEC=aVector, MAT=aMatrix)
namedList

# -----------1.9.2索引列表--------------
namedList[1]
namedList[-1]
namedList[c(TRUE,FALSE)]
namedList["MAT"]
namedList[[1]]
namedList[[2]]
namedList[[2]][3,2]
namedList$VEC

namedList
namedList[1] <- c(0,0,0,0) #不是想要的结果，左右数据结构不一致
namedList[[1]] <- c(0,0,0,0)
namedList
namedList[[3]] <- c("Hello","Hi")
namedList

# ----------1.9.3用列表给矩阵起名字-----------
my_Matrix <- rbind(c(1,2,3),c(4,5,6),c(7,8,9))
my_Matrix
dimnames(my_Matrix) <- list(c("A","B","C"),c("d","e","f"))
my_Matrix
## 关于取名的小结，向量用names()函数，矩阵用dimnames函数，数据框用colnames()和rownames()函数
my_Matrix[c("A","B"),c(2,3)]

