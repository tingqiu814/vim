#!/usr/bin/env python
# -*- coding: utf-8 -*-

import  pexpect,os

class frstphp:

  def __init__(self):
    self.config = {
      '0':{'host':'myvm', 'user':'root', 'password':'123456', 'port':22},
      '1':{'host':'127.0.0.1', 'user':'root', 'password':'123456', 'port':5623},
      '2':{'host':'127.0.0.1', 'user':'root', 'password':'123456', 'port':22}
    }

  def send_command(self, child, cmd):
    child.sendline(cmd)
    child.expect('#')
    print child.before
    child.sendline('ls -lh /')
    child.interact()

  def connect(self):
    print(
    '''
    [0] 测试服务器1
    [1] 测试服务器2
    [2] 测试服务器3
    '''
    )
    idKey = raw_input(" 请选择服务器:")

    user = self.config[idKey]['user']
    host = self.config[idKey]['host']
    password = self.config[idKey]['password']
    port = self.config[idKey]['port']

    print "hello " +user + "@" + host + ":" + str(port)

    connStr = 'ssh ' + user + '@' + host + ' -p ' + str(port)
    child = pexpect.spawn(connStr)
    res = child.expect([pexpect.TIMEOUT, '[P|p]assword:'])
    if res ==  0:
      print "[-] Error 2"
      return
    elif res ==  1:
      child.sendline(password)

    child.expect('#')

    return child

if __name__ == '__main__':
    try:
      fp = frstphp()
      child = fp.connect()
      fp.send_command(child, 'w')

    except KeyboardInterrupt:
      print('stopped by cqg')
