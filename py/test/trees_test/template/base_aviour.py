import multiprocessing
import py_trees
import random
import time
import atexit

"""
    动作节点，通过管道实现脚本调用
        name = 动作节点本身名字
        func = 脚本函数(实例化时输入脚本函数)

    setup() 在实例化后调用，可以写耗时较长的初始化，比如硬件驱动加载。
    initialise() 在第一次tick时会被调用， 可以做数据初始化
    update() 每一次 tick 必要会被调用, 不能阻塞
    terminate() 在返回 SUCCESS FAILURE 时会被调用
"""
class BaseAviour(py_trees.behaviour.Behaviour):
    def __init__(self, name, func):
        """
            最小的初始化。
            一个很好的经验法则是只包含与能够相关的
            初始化将此行为插入到树中以进行脱机呈现点图。
        """
        super(BaseAviour, self).__init__(name)
        self._planning = func

    def setup(self):
        """
            程序应主动调用，避免初始化时间过长。主要用于行为驱动初始化
        """
        self.logger.debug("  %s [Foo::setup()]" % self.name)
        # 声明管道 parent 、 child
        self.parent_connection, self.child_connection = multiprocessing.Pipe()
        # 创建子进程 并传入 child
        self.planning = multiprocessing.Process(target=self._planning, args=(self.child_connection,))
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
            if self.percentage_completion == 'Success':
                new_status = py_trees.common.Status.SUCCESS
            elif self.percentage_completion == 'Failure':
                new_status = py_trees.common.Status.FAILURE

        return new_status

    
    def terminate(self, new_status):
        """
            触发时机: 当行为切换到非运行状态时。
            - SUCCESS || FAILURE: 行为周期结束
            - INVALID: 
        """
        self.logger.debug("  %s [Foo::terminate().terminate()][%s->%s]" % (self.name, self.status, new_status))
