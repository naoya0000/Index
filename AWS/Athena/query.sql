
■コメント(/* と*/で囲まれた部分はコメントとして扱われAthenaがクエリを評価する際に無視される)
/*
aaaa
*/


■構造
SELECT
              カラム１
              カラム２
              *
FROM
              テーブル名
WHERE
              条件１
              AND 条件２
ORDER BY
              カラム1 ASC(昇順：値の小さい順に並べる)/DESC(昇順：値の大きい順に並べる)
              カラム2 ASC/DESC
LIMIT
              count
 
 
 
■VPCフローログの確認
SELECT *,
  DATE_FORMAT(FROM_UNIXTIME(starttime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as starttimeJST,
  DATE_FORMAT(FROM_UNIXTIME(endtime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as endtimeJST,
  date, sourceaddress, destinationaddress, sourceport, destinationport, protocol, interfaceid, numpackets, numbytes, action,
  logstatus
FROM vpc_flow_logs
WHERE
  date = '2024/05/29'
  AND (sourceaddress in('10.10.0.101') or destinationaddress in('10.10.0.101')
  AND (sourceaddress in('10.10.1.101','10.10.2.101') or destinationaddress in('10.10.1.101','10.10.2.101')
  AND (sourceport in(20,21) or destinationport in(20,21))
  AND DATE_FORMAT(FROM_UNIXTIME(starttime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') BETWEEN '2024-05-29 09:00:00' AND '2024-05-29 23:59:59'

/*
action = 'REJECT'
ORDER BY starttimeJST
*/


■解説
DATE_FORMAT(FROM_UNIXTIME(starttime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as starttimeJST
*DATE_FORMAT(date,format)
DATE_FORMAT(now(),'%a') → その日の曜日
DATE_FORMAT('2018-01-01','%a') →
*as(AS)
カラムを区切って表示する
DATE_FORMAT(FROM_UNIXTIME(starttime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as starttimeJST
DATE_FORMAT(FROM_UNIXTIME(endtime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as endtimeJST
starttimeJST,endtimeJSTという二つのカラムで区切られる
*date = '2024/05/29'
カラムの値を指定。WHERE句の中で日付指定するときに使用
 
 
テンプレート
SELECT *,
  DATE_FORMAT(FROM_UNIXTIME(starttime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as starttimeJST
  DATE_FORMAT(FROM_UNIXTIME(endtime, 'Asia/Tokyo') ,'%Y-%m-%d %H:%i:%s') as endtimeJST
FROM
  "awsdatacatalog"."default"."vpc_flow_logs"
WHERE day = '2024/02/06'
  AND sourceaddress = '10.xx.xx.xx'
  AND sourceport = 22
  AND destinationaddress BETWEEN '10.xx.xx.xx' AND '10.xx.xx.xx'
  AND destinationport = 80
ORDER BY
  timestamp DESC