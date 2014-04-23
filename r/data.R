#table <- read.table('data.csv',header=TRUE,sep=',')
df<- read.csv('data1000.csv')
names(df) = c('user','brand','type','time')


summary head tail names

# 包括点击、购买、加入购物车、收藏4种行为 
# (点击：0 购买：1 收藏：2 购物车：3）
# 0 click,1 buy,2 add2chart, 3 storeup

save(list=ls(all=TRUE),file='1.RData')
load(file = ‘1.Rdata’)

