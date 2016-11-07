### 5.1

autompg<-read.csv("auto-mpg.csv",header=TRUE,na.string=".")
tipping<-read.csv("tips.csv",header=TRUE)
abalone<-read.csv("abalone.csv",header=TRUE)
Pconsump<-read.csv("power_consumption.csv") 

### <R 5.1> 다이아몬드 자료 살펴보기
library(ggplot2)
head(diamonds)
dim(diamonds)

### <R 5.2> tabplot 그리기 – 그림 5.1

library(tabplot)
tableplot(diamonds)

### <R 5.3> tabplot 그리기 – 그림 5.2

tableplot(diamonds,select=c(carat,cut,color,clarity,price),sortCol=price)

### <R 5.4> ash1 함수를 이용하여 일변량 자료의 분포함수 그리기 - 그림 5.3

library(ash)
test1<-ash1(bin1(diamonds$price,nbin=50),5)
plot(test1,type='l')

### <R 5.5> hexbin을 이용한 분포그림 그리기  - 그림 5.4

library(hexbin)
library("grid")
x <- diamonds$carat
y <- diamonds$price
bin <- hexbin(x,y)
plot(bin,xlab="carat",ylab="price")

### <R 5.6> smooth.hexabin을 이용한 그림그리기 – 그림 5.5

smbin <- smooth.hexbin(bin)
plot(smbin,xlab="carat",ylab="price")

### <R 5.7> abalone 자료 살펴보기 – 그림 5.6
pairs(abalone[,-1])

### <R 5.8> abalone 자료의 scagnostics값 

library(scagnostics)
scag.abalone<-scagnostics(abalone[,-1])
round(scag.abalone,2)

### <R 5.9> abalone 자료의 scagnostics값 살펴보기 – 그림 5.7 

pairs(t(scag.abalone))

### <R 5.10> abalone 자료의 scagnostics값의 이상치 찾기 

Notnormal.plot<-scagnosticsOutliers(scag.abalone)
Notnormal.plot[Notnormal.plot]
round(scag.abalone[,Notnormal.plot],4)

### <R 5.11> gWidgets 라이브러리 이용을 위한 옵션 

library(gWidgets)
options("guiToolkit"="RGtk2")

### <R 5.12> checkbox 구성하기 - 그림 5.9

win.1 <- gwindow("Sample checkbox")
tmp<-gframe("Favorate color",cont=win.1)
checkbox.1<-gcheckbox("White",cont=tmp)
checkbox.2<-gcheckbox("Black",cont=tmp)
checkbox.3<-gcheckbox("Red",cont=tmp)
checkbox.4<-gcheckbox("Green",cont=tmp)
checkbox.5<-gcheckbox("Blue",cont=tmp)
checkbox.6<-gcheckbox("Pink",cont=tmp)
checkbox.7<-gcheckbox("Yellow",cont=tmp)

### <R 5.13> checkbox 값 구하기

svalue(checkbox.1);
svalue(checkbox.2);
svalue(checkbox.3);
svalue(checkbox.4);
svalue(checkbox.5);
svalue(checkbox.6);
svalue(checkbox.7);

### <R 5.14> edit 구성하기 – 그림 5.10

win.2 <- gwindow("Sample text input console")
tmp<-gframe("Enter text",cont=win.2)
edit.sample<-gedit("",cont=tmp)

###<R 5.15> edit 값 구하기

svalue(edit.sample)

### <R 5.16> menu 구성하기 – 그림 5.11

win.3 <- gwindow("Sample menu")
menu.list<-list()
menu.list$AA$handler = function(h,...) print("A")
menu.list$BB$handler = function(h,...) print("B")
menu.list$CC$C1$handler = function(h,...) print("C1")
menu.sample<-gmenu(menu.list,cont=win.3)

### <R 5.17> text입력창과 statusbar 구성하기 – 그림 5.12

win.4 <- gwindow("Sample gtext and gstatusbar")
#tmp<-gframe("Text Editor",cont=win.4)
text.sample<-gtext("Type here!",cont=win.4)
statusbar.sample<-gstatusbar("Typing here...",cont=win.4)

### <R 5.18> statusbar 문구 바꾸기

svalue(statusbar.sample)<-"Still typing..."

### <R 5.19> text입력값 구하기

svalue(text.sample)

### <R 5.20> 그림 5.13의 GUI 구성을 위한 함수 simpleXYplotGui

simpleXYplotGui<- function(sam.data) {
  availVars <- colnames(sam.data)
  
  updatePlot <- function(h,...) {
    x<-sam.data[,svalue(Xvar)]
    y<-sam.data[,svalue(Yvar)]
    plot(x,y,pch=16,col=svalue(colchoose))
    if(svalue(linechoose)=="lm")
    {  abline(lm(y~x),lwd=2)
    } else 
    {  lines(lowess(x,y,f=svalue(spanAdjust)),lwd=2)
    }
  }
  
  ##The widgets
  win <- gwindow("Scatter plot with lines")
  gp <- ggroup(horizontal=FALSE, cont=win)
  
  tmp <- gframe("X variable", container=gp, expand=TRUE)
  Xvar <- gcombobox(availVars, cont=tmp,
                    handler=updatePlot)
  
  tmp <- gframe("Y variable", container=gp, expand=TRUE)
  Yvar <- gcombobox(availVars, cont=tmp,
                    handler=updatePlot)
  
  tmp <- gframe("Color of points", container=gp, expand=TRUE)
  colchoose <- gradio(c("black","red","blue","green"), cont=tmp,
                      handler =updatePlot)
  tmp <- gframe("lines", container=gp, expand=TRUE)
  linechoose <- gradio(c("lm","lowess"), cont=tmp,
                       handler =updatePlot)
  tmp <- gframe("lowess span", container=gp, expand=TRUE)
  spanAdjust <- gslider(from=0,to=1,by=.01, value=0.5,
                        cont=tmp, expand=TRUE, handler =updatePlot)
  
  add(win, ggraphics())
}
simpleXYplotGui(autompg)

### shiny install
# install.packages("shiny")

### shiny runnning
# library(shiny)
# runExample("디렉토리이름")

### rggobi install
# install.packages("rggobi")

### <R 5.23> ggobi 시작하기

library(rggobi)
g<-ggobi(iris)

### <R 5.24> rggobi 함수를 이용하여 그림 5.16 점의 색과 모양 알아내기

glyph_type(g[1])
glyph_color(g[1])
iris[which(glyph_color(g[1])==2),]

### <R 5.25> rggobi 함수를 이용하여 ggobi 그림의 색과 모양 바꾸기

glyph_color(g[1]) <- c(rep(1:3,each=50))
glyph_type(g[1]) <- 6

### <R 5.26> 개발단계의 ggvis 설치하는 방법
# devtools::install_github("rstudio/ggvis", build_vignettes = FALSE)

### <R 5.27> ggvis를 이용하여 웹페이지 구성하기 – 그림 5.17

library(ggvis)
autompg %>% 
  ggvis(~weight, ~mpg, 
        size := input_slider(10, 100,label="size"),
        opacity := input_slider(0, 1,label="opacity")
  ) %>% 
  layer_points()
