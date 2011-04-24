#!/usr/bin/env bash
for i in `/bin/ls */*sh `; do 
	grep -v '^#' $i \
	|tr - ' '\
	| awk '{print $7}'> $(dirname  $i)/$(basename $i .sh).pls; 
done
