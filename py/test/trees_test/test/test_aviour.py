import multiprocessing
import py_trees
import random
import time
import atexit

"""
    Emulates an external process which might accept long running planning jobs.
    模拟可能接受长时间运行的计划作业的外部进程。
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


class TestAviour(py_trees.behaviour.Behaviour):
    def __init__(self, name):
        """
            最小的初始化。
            一个很好的经验法则是只包含与能够相关的
            初始化将此行为插入到树中以进行脱机呈现点图。
        """
        super(TestAviour, self).__init__(name)
    def setup(self):
        """
            程序应主动调用，避免初始化时间过长。主要用于行为驱动初始化
        """
        self.logger.debug("  %s [Foo::setup()]" % self.name)
        # 声明管道 parent 、 child
        self.parent_connection, self.child_connection = multiprocessing.Pipe()
        # 创建子进程 并传入 child
        self.planning = multiprocessing.Process(target=planning, args=(self.child_connection,))
        # 设置回调,不必等待未完成任务
        atexit.register(self.planning.terminate)
        # 启动子进程
        self.planning.start()

    def initialise(self):
        """
            在你的行为开始工作之前你需要的任何初始化。
        """
        self.logger.debug("  %s [Foo::initialise()]" % self.name)

        self.parent_connection.send(['begin'])
        
    def update(self):
        """
            每一次, tick 都会执行
            - 触发、检查、监控。任何东西……但不要塞
            - Set a feedback message设置反馈信息
            - return a py_trees.common.Status.[RUNNING, SUCCESS, FAILURE]
        """
        new_status = py_trees.common.Status.RUNNING
        self.logger.debug("  %s [Foo::update()]" % self.name)
        # 查看是否有数据
        if self.parent_connection.poll():
            # 头取法
            self.percentage_completion = self.parent_connection.recv().pop()
            if self.percentage_completion == 'success':
                new_status = py_trees.common.Status.SUCCESS

        return new_status

    
    def terminate(self, new_status):
        """
            触发时机: 当行为切换到非运行状态时。
            - SUCCESS || FAILURE: 行为周期结束
            - INVALID: 
        """
        self.logger.debug("  %s [Foo::terminate().terminate()][%s->%s]" % (self.name, self.status, new_status))
