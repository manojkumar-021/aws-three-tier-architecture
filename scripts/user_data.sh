#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "<h1>Three Tier Architecture - Web Server</h1>" > /var/www/html/index.html
