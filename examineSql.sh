files=$1
echo "操作的文件包含："
echo ${files}

echo "开始执行..."
grep Preparing ${files} | sed -e 's/.*] /调用方法: /g' -e 's/: ==>  Preparing: //g' > t.sql
echo "sql执行总次数 "`cat t.sql | wc -l`

sort t.sql | uniq -c | sort -rn > result.sql
echo "sql去重后的总数 "`cat result.sql | wc -l`

rm t.sql
echo "结果请查看“result.sql”文件"
