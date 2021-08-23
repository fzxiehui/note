#!/usr/bin/env python3

import sys
import socket
# 低层级的 I/O 多路复用模块
import selectors
# 异常捕捉
import traceback

import libclient

# 创建多路复用对象, DefaultSelector 相应平台最有效Selector
sel = selectors.DefaultSelector()


# 创建 报文
"""
    {
        "type":"text/json",
        "encoding": "utf-8",
        "content": {
            "action": "search",
            "value": "balbal"
        }
    }
"""
def create_request(action, value):
    if action == "search":
        return dict(
            type="text/json",
            encoding="utf-8",
            content=dict(action=action, value=value),
        )
    else:
        return dict(
            type="binary/custom-client-binary-type",
            encoding="binary",
            content=bytes(action + value, encoding="utf-8"),
        )

# 创建 socket 连接
def start_connection(host, port, request):
    addr = (host, port)
    print("starting connection to", addr)
    """
        创建 socket
        AF_INET: ipv4 地址族,
        SOCK_STREAM: 阻塞套接字 , SOCK_NONBLOCK 非阻塞
    """
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    """ 设置socket为非阻塞 false 非阻塞 true 为阻塞 """ 
    sock.setblocking(False)
    """ 
        类似 connect, connect 会一直尝试链接,
        connect_ex 成功返回 0, 失败返回 errnocode
    """
    sock.connect_ex(addr)
    """
        设置 select 多路复用 读写 权限
    """
    events = selectors.EVENT_READ | selectors.EVENT_WRITE
    """  
        ***********
    """
    message = libclient.Message(sel, sock, addr, request)
    """
        把socket 做为监视io, data 作为托管对象
    """
    sel.register(sock, events, data=message)


if len(sys.argv) != 5:
    print("usage:", sys.argv[0], "<host> <port> <action> <value>")
    sys.exit(1)

# 获取启动参数 addr, port
host, port = sys.argv[1], int(sys.argv[2])
# 获取启动参数 action, value
action, value = sys.argv[3], sys.argv[4]

# 创建 报文
request = create_request(action, value)


start_connection(host, port, request)

try:
    while True:
        events = sel.select(timeout=1)
        for key, mask in events:
            message = key.data
            try:
                message.process_events(mask)
            except Exception:
                print(
                    "main: error: exception for",
                    f"{message.addr}:\n{traceback.format_exc()}",
                )
                message.close()
        # Check for a socket being monitored to continue.
        if not sel.get_map():
            break
except KeyboardInterrupt:
    print("caught keyboard interrupt, exiting")
finally:
    sel.close()
