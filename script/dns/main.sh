#!/bin/bash
cd script/dns/src
#cd ./src
# Start Download
curl -o i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
curl -o i6.txt https://someonewhocares.org/hosts/zero/hosts
curl -o i7.txt https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
curl -o i8.txt https://gitlab.com/badmojr/1hosts/-/raw/main/Lite/adblock.txt
curl -o i9.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
curl -o i10.txt https://hblock.molinero.dev/hosts
curl -o i11.txt https://adaway.org/hosts.txt
curl -o i12.txt https://abp.oisd.nl/basic
curl -o i13.txt https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt
curl -o i14.txt https://curben.gitlab.io/malware-filter/urlhaus-filter-agh-online.txt
curl -o i19.txt https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&startdate%5Bday%5D=23&startdate%5Bmonth%5D=2&startdate%5Byear%5D=2002&useip=0.0.0.0
wget https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep '^||' | grep -v './' | grep -Ev "([0-9]{1,3}.){3}[0-9]{1,3}" | grep -v '.\$' | sed '/^$/d' > adblock0.txt 
cat mergd.txt | grep '^@@||' | grep -v './' | grep -v '.\$' > adblock1.txt
cat adblock*.txt > adblock.txt #abp规则处理合并
cat mergd.txt | grep '^[0-9]' | grep -v '^#' | grep -v 'local'> host.txt #hosts规则处理
cat host.txt | sed 's/127.0.0.1 /||/' | sed 's/0.0.0.0 /||/' | sed "s/$/&^/g" | sed '/^$/d' > hosts.txt #hosts转abp规则
cat jiekouAD.txt | grep -Ev '#|\$|@|!|/|\\|\*'| sed "s/^/||&/g" |sed "s/$/&^/g" >> damian.txt #大萌主规则处理
cat adblock.txt hosts.txt brules.dd damian.txt > new.txt
cat new.txt | grep '|\|@' | grep -v '.#' | grep -v '.?' | grep -v '.=' | grep -v '.]'| grep -v '^!' | grep -v 'local' | grep -v '/' | grep -v '\^|' | grep -v '\^\*'| sed '/^$/d' > tmpp.txt
sort -n tmpp.txt | uniq > tmmp.txt

# Remove Error Rules
cat tmmp.txt errdamian.dd > ttmp.txt 
sort -n ttmp.txt | uniq -u > tmp.txt

# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: $(TZ=Asia/Taipei date +'%Y-%m-%d %H:%M:%S')（台北時間） " >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../dns.txt
rm *.txt
cd ../../
exit
