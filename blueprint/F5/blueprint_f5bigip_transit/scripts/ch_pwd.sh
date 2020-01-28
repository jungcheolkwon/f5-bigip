#!/usr/bin/expect

#edited by JC
#j.kwon@f5.com

log_user 1

set HOME "$env(HOME)"
set name [exec cat $HOME/.ssh/.user]
set password [exec cat $HOME/.ssh/.password]
set host [lindex $argv 0]

spawn ssh -o StrictHostKeyChecking=no $name@$host

expect ".*#"
send "modify auth password $name\n"
expect ".*"
send "$password\r"
expect ".*"
send "$password\r"
expect ".*#"
send "modify sys global-settings hostname bigip1.f5.com\n"
expect ".*#"
send "modify cm device bigip1 configsync-ip 172.16.1.10\n"
expect ".*#"
send "create net self self-floating address 172.16.1.9/24 allow-service all traffic-group traffic-group-1 vlan internal\n"
expect ".*#"
send "save sys config\n"
expect ".*#"
send "quit\n"
