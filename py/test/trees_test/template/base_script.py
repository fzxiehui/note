import time
"""
    具体实现
"""
def planning(pipe_connection):

    idle = True
    try:
        while(True):
            # 查看连接对像是否有可以读取的数据
            ppoll = pipe_connection.poll()
            # print("ppoll", ppoll)
            if ppoll:
                # recv 获取命令 命令由 parent send
                rec = pipe_connection.recv()
                # 开始任务
                idle = False
            # 记数标记
            if not idle:
                print("TestAviour Sleep 10  ... ")
                time.sleep(10)
                pipe_connection.send(['success'])
                idle = True

            time.sleep(0.5)
    except KeyboardInterrupt:
        pass

