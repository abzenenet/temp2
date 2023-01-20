#!/usr/bin/env python3

import sys, base64, json, re, requests, time
#import logging
#import http.client as http_client
from datetime import datetime

#http_client.HTTPConnection.debuglevel = 1
#logging.basicConfig()
#logging.getLogger().setLevel(logging.DEBUG)
#requests_log = logging.getLogger("requests.packages.urllib3")
#requests_log.setLevel(logging.DEBUG)
#requests_log.propagate = True

now = datetime.now()
ts = 'last modified: % ' + now.strftime("%Y-%m-%d %H:%M:%S") + ' %'

user = 'wp'
password = 'WordPress123.'
base_url = 'https://wordpress.apps.openshift.testos.cokp.origoss.com/'
login_url = base_url + 'wp-login.php'

login_data = { 'log': user, 'pwd': password, 'wp-submit': 'Log In', 'redirect_to': base_url }

session = requests.session()
session.get(login_url)
login = session.post(login_url, login_data)
if login.status_code != 200:
  print("login failed: %s" % (login.status_code))
  sys.exit(1)
#print("login: %s ok" % (login.status_code))
#print("cookies: %s" % (session.cookies))

base = session.get(base_url)
if base.status_code != 200:
  print("base failed: %s" % (base.status_code))
  sys.exit(1)
#print("base: %s ok" % (base.status_code))
wp_endpoint = re.sub('^\<', '', base.headers['Link'])
wp_endpoint = re.sub('\>.*$', '', wp_endpoint)[:-1]
rest_url = wp_endpoint + '/wp/v2'
#print("rest_url: %s" % (rest_url))

#  Download the current Newsletter page
page = session.get(rest_url + '/pages/2')
if page.status_code != 200:
  print("get failed: %s" % (page.status_code))
  sys.exit(1)
#print("get: %s ok" % (page.status_code))

#  Extract the actual page content from all the rest of the API data
data = page.json()
content = data['content']['rendered']

#  Find the URL for the download in 'content', and replace it with the new URL
regex = r'last modified.*%'
new_content = re.sub(regex, ts, content)
if content == new_content:
  new_content = '<p>' + ts + '</p>' + "\n" + content
#print(new_content)

post = session.get(base_url + 'wp-admin/nonce.php')
if post.status_code != 200:
  print("get nonce failed: %s" % (post.status_code))
  sys.exit(1)
#print("get nonce: %s ok" % (post.status_code))

nonce = re.findall(r'<input[^>]*"_wpnonce"[^>]*/>', post.text)
if len(nonce) < 1:
  print("could not find nonce in page")
  print(post.text)
  sys.exit(1)
noncestr = nonce[0]
nonce = re.sub('^.*value="', '', noncestr)
nonce = re.sub('".*$', '', nonce)
#print("nonce: %s  original: %s" % (nonce, noncestr))

# Let's use that nonce in X-WP-Nonce headder
headers = { 'X-WP-Nonce': nonce }

#  Create a new data payload using the updated 'content'
new_data = { 'content': new_content }

#  Upload it back to the site
r = session.post(rest_url + '/pages/2', json=new_data, headers=headers)
if r.status_code != 200:
  print("update failed: %s" % (r.status_code))
  sys.exit(1)
#print("update: %s ok" % (r.status_code))

sys.exit(0)
