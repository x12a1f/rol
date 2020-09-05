#!/bin/sh

for i in rol/*scad 
do
	j=`basename $i .scad`
	sed '/^\/\*\*/,/\*\*\//!d;//d' < $i > doc/$j.md
done
