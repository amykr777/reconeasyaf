#!/bin/bash

echo "   


   ___                    ____              ___   ____
  / _ \___ _______  ___  / __/__ ____ __ __/ _ | / __/
 / , _/ -_) __/ _ \/ _ \/ _// _ (_-< / // / __ |/ _/  
/_/|_|\__/\__/\___/_//_/___/\_,_/___/\_, /_/ |_/_/    
                                    /___/             


                                        by Aman Kumar
                                                      	  "
domain=$1
if [[ -z $domain ]]; then
	echo -e "Usage: ./reconeasyaf.sh <domain.com>"
	exit 1
fi
echo "[-] ReconEasyAF will gather the following information for you
      [+] All existing domains of $domain
      [+] All Live domains of $domain
      [+] All URLs/Links of $domain
      [+] All JS files of $domain
                                               "
echo "	"
echo " This will take some time."
echo "	"
echo "	"

mkdir $domain

echo "Enumerating subdomains with SubFinder..."
subfinder -d $domain -silent > $domain/all-domains.txt

echo $domain >> $domain/all-domains.txt
echo "[DONE] All domains of $domain are saved in all-domains.txt"

sleep 1 # wait for 1 second
echo "	"
echo "Checking for LIVE domains..."

cat $domain/all-domains.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" > $domain/live-domains.txt

echo "[DONE] Results are saved in live-domains.txt"

echo "	"
echo " Fetching all URLs/links of $domain..."
cat $domain/live-domains.txt | waybackurls > $domain/urls.txt
echo "[DONE] All urls/links of $domain are saved in urls.txt"

echo "	"
echo "Enumerating all JS files from $domain..."
cat $domain/urls.txt | grep "\.js" | uniq | sort > $domain/js-files.txt
echo "[DONE] Js files of $domain are saved in js-files.txt"

echo "	"
echo "~ All files are saved in $domain directory"

