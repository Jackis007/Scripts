#!/usr/bin/python
#coding=utf-8
#__Author__='Shaon.Kwei' 


import requests 
import os
url = "http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"
root = "D://web_image//"
path = root + url.split('/')[-1]
try:
	if not os.path.exists(root):
		os.mkdir(root)
	if not os.path.exists(path):
		h = requests.get(url)
		with open(path, 'wb') as f:
			f.write(h.content)
			f.close()
			print("SAVE OK")
	else:
		print("exists")
except:
	print("no ok")
