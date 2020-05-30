目录
[toc]

### 背景

针对项目运行过程中的sql进行统计并梳理，基于sql的使用情况，有助于对sql方面进行优化

- 重复度高的查询，表方面是否要添加索引？
- 出现过多的表联查，是否可以从逻辑上简化？
- sql执行次数过多，是否可以增加缓存？
- or是否可以考虑使用union代替？



### 环境要求

项目使用mybatis框架，并且使用mybatis自带的日志打印
>这个前提只是在脚本不需要修改的情况下，原则上没有要求,只不过如果不符合上面的前提，脚本要做一下适配就可以了



### shell脚本的内容
主要用到了**sed**、**sort**、**uniq**几个命令，有兴趣的同学可以深入了解下
```shell
files=$1
echo "操作的文件包含："
echo ${files}

grep Preparing ${files} | sed -e 's/.*] /调用方法: /g' -e 's/: ==>  Preparing: //g' > t.sql
echo "sql执行总次数 "`cat t.sql | wc -l`

sort t.sql | uniq -c | sort -rn > result.sql
echo "sql去重后的总数 "`cat result.sql | wc -l`

rm t.sql
```



### 执行方式

```shell
# 下载文件
wget https://github.com/cjustsing/examine-sql/releases/download/1.0/examineSql.sh

# 参数支持“*”通配，参数记得要带双引号，否则只会统计到匹配的第一个文件
# 如果examineSql.sh在日志文件目录下
sh examineSql.sh "*log"
# 也支持指定绝对路径
sh examineSql.sh "/.../logs/*log"
 
# 执行完成之后的结果会存储在当前目录下的“result.sql”文件中
```



### 文件结构

```sql
 465 c.i.o.p.d.m.PermissionMapper.select      SELECT id,content,type,remark FROM t_permission WHERE content = ? AND type = ? 
 456 c.i.o.p.dal.mapper.UserMapper.selectOne  SELECT create_by,create_time,update_by,update_time,id,uid,is_delete FROM t_user WHERE uid = ? AND is_delete = ? 
```

| 出现的重复次数 | 调用的方法    | 具体的sql内容 |
| -------------- | ------------- | ------------- |
| 465            | xxx.select    | SELECT ...    |
| 456            | xxx.selectOne | SELECT ...    |
