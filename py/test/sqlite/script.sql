DROP TABLE IF EXISTS t_user;
DROP TABLE IF EXISTS t_device;
DROP TABLE IF EXISTS t_action_type;
DROP TABLE IF EXISTS t_action_list;
DROP TABLE IF EXISTS t_key_list;
DROP TABLE IF EXISTS t_script_list;

CREATE TABLE t_user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    status INTEGER NOT NULL
);

-- CREATE TABLE post (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     author_id INTEGER NOT NULL,
--     created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     title TEXT NOT NULL,
--     body TEXT NOT NULL,
--     FOREIGN KEY ( author_id ) REFERENCES user (id)
-- );

-- 设备列表
CREATE TABLE t_device (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT,			-- 设备名称
		mac TEXT,				-- 网口mac地址
		type INTEGER,		-- 1 windows 2 android
		active INTEGER,	-- 活跃状态: 1 正常 2 关机 
		heartTimeStamp TEXT, -- 活跃时间戳
		heartRate TEXT, -- 心跳频率
		debug INTEGER		-- 调试状态 1 进入调试
);

-- 动作类型列表
CREATE TABLE t_action_type (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
		type TEXT,			-- 类型名称: base customize
		typeId INTEGER,	-- 类型id: base = 1, customize = 2
		name TEXT				-- 动作名称
);

-- 动作表
CREATE TABLE t_action_list (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
		action_id INTEGER NOT NULL,
		name TEXT,
		info TEXT,
    FOREIGN KEY ( action_id ) REFERENCES t_action (id)
);
-- 脚本
CREATE TABLE t_script (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
	  action_id INTEGER NOT NULL, -- 用于绑定动作表
		step_id INTEGER, -- 步骤id web index
		beginWait INTEGER, -- 动作开始前等待时间
		endWait INTEGER, -- 动作结束后等待时间
		button TEXT, -- 鼠标按键
		cbutton TEXT, -- 控制键 []
		clean TEXT, -- 是否点击  0 , 0 位置
		clickType TEXT, -- 模板匹配中的鼠标事件
		frequency INTEGER, -- 模板匹配中 匹配频率
		height INTEGER, -- 用于截图 高度
		info TEXT, -- 脚本描述
		kbutton TEXT, -- 普通按键
		similarity REAL, -- 模板匹配 相似度
		string TEXT, -- 字符串输入
		template TEXT, -- 模板匹配 模板
		timeout INTEGER, -- 模板匹配 超时时间
		upspring TEXT, -- 按键自动弹起设置
		value TEXT, -- 脚本名称
		width INTEGER, -- 用于截图 宽度
		x INTEGER, -- 截图 鼠标 x
		y INTEGER, -- 截图 鼠标 y
		success INTEGER, -- 成功
		fail INTEGER, -- 失败
    FOREIGN KEY ( action_id ) REFERENCES t_action_list (id)
);
-- 键位表
CREATE TABLE t_key_list (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT,
		type TEXT,
		info TEXT
);
-- TEST user
INSERT INTO t_user VALUES (1, "xiehui", "5186ac306fcc54dbe9e836e05f9197af", 1);

-- TEST device
INSERT INTO t_device VALUES (1, "测试1", "FC-34-97-68-57-62", 1, 1, "1111111", "30", 0);
INSERT INTO t_device VALUES (2, "测试2", "FC-34-97-68-57-61", 1, 1, "2222222", "30", 0);
INSERT INTO t_device VALUES (3, "测试3", "FC-34-97-68-57-60", 1, 1, "3333333", "30", 1);
INSERT INTO t_device VALUES (4, "测试4", "FC-34-97-68-57-59", 1, 1, "4444444", "30", 1);
INSERT INTO t_device VALUES (5, "测试5", "FC-34-97-68-57-58", 1, 1, "5555555", "30", 1);

-- TEST action
INSERT INTO t_action_type VALUES (1, "base", 1,"鼠标");
INSERT INTO t_action_type VALUES (2, "base", 1,"键盘");
INSERT INTO t_action_type VALUES (3, "base", 1,"计算机视觉");
INSERT INTO t_action_type VALUES (4, "customize", 2, "test1");
INSERT INTO t_action_type VALUES (5, "customize", 2, "test2");

-- TEST action_list
INSERT INTO t_action_list VALUES (1, 1, "绝对:鼠标事件", "鼠标移动或点击指定位置(精度高)");
INSERT INTO t_action_list VALUES (2, 1, "相对:鼠标事件", "主要用于点击, 位置偏移(偏移精度低)");
INSERT INTO t_action_list VALUES (3, 2, "组合键", "组合键");
INSERT INTO t_action_list VALUES (4, 2, "字符串", "字符串");
INSERT INTO t_action_list VALUES (5, 3, "等待模板匹配", "设置模板自动截屏匹配");
INSERT INTO t_action_list VALUES (6, 3, "模板点击", "找到模板图并配合鼠标");
INSERT INTO t_action_list VALUES (7, 4, "测试1", "测试1测试1测试1测试1测试1");
INSERT INTO t_action_list VALUES (8, 5, "测试2", "测试2测试2测试2测试2测试2");

-- add key list control
INSERT INTO t_key_list (name,type,info) VALUES ("noKey", "control", "没有按键");
INSERT INTO t_key_list (name,type,info) VALUES ("rwin", "control", "右win");
INSERT INTO t_key_list (name,type,info) VALUES ("ralt", "control", "右alt");
INSERT INTO t_key_list (name,type,info) VALUES ("rshift", "control", "右shift");
INSERT INTO t_key_list (name,type,info) VALUES ("rctrl", "control", "右ctrl");
INSERT INTO t_key_list (name,type,info) VALUES ("lwin", "control", "左win");
INSERT INTO t_key_list (name,type,info) VALUES ("lalt", "control", "左alt");
INSERT INTO t_key_list (name,type,info) VALUES ("lshift", "control", "左shift");
INSERT INTO t_key_list (name,type,info) VALUES ("lctrl", "control", "左ctrl");

-- mouseKeyTab
INSERT INTO t_key_list (name,type,info) VALUES ("no", "mouse", "无");
INSERT INTO t_key_list (name,type,info) VALUES ("left", "mouse", "左");
INSERT INTO t_key_list (name,type,info) VALUES ("right", "mouse", "右");
INSERT INTO t_key_list (name,type,info) VALUES ("contre", "mouse", "中");

-- add key list key 
INSERT INTO t_key_list (name,type,info) VALUES ("noKey", "key", "没有按键");
INSERT INTO t_key_list (name,type,info) VALUES ("spot", "key", "左上角点");
INSERT INTO t_key_list (name,type,info) VALUES ("1", "key", "1");
INSERT INTO t_key_list (name,type,info) VALUES ("2", "key", "2");
INSERT INTO t_key_list (name,type,info) VALUES ("3", "key", "3");
INSERT INTO t_key_list (name,type,info) VALUES ("4", "key", "4");
INSERT INTO t_key_list (name,type,info) VALUES ("5", "key", "5");
INSERT INTO t_key_list (name,type,info) VALUES ("6", "key", "6");
INSERT INTO t_key_list (name,type,info) VALUES ("7", "key", "7");
INSERT INTO t_key_list (name,type,info) VALUES ("8", "key", "8");
INSERT INTO t_key_list (name,type,info) VALUES ("9", "key", "9");
INSERT INTO t_key_list (name,type,info) VALUES ("0", "key", "0");
INSERT INTO t_key_list (name,type,info) VALUES ("cut", "key", "-");
INSERT INTO t_key_list (name,type,info) VALUES ("add", "key", "+");
INSERT INTO t_key_list (name,type,info) VALUES ("backspace", "key", "删除键");

-- 第一排
INSERT INTO t_key_list (name,type,info) VALUES ("tab", "key", "缩进");
INSERT INTO t_key_list (name,type,info) VALUES ("q", "key", "q");
INSERT INTO t_key_list (name,type,info) VALUES ("w", "key", "w");
INSERT INTO t_key_list (name,type,info) VALUES ("e", "key", "e");
INSERT INTO t_key_list (name,type,info) VALUES ("r", "key", "r");
INSERT INTO t_key_list (name,type,info) VALUES ("t", "key", "t");
INSERT INTO t_key_list (name,type,info) VALUES ("y", "key", "y");
INSERT INTO t_key_list (name,type,info) VALUES ("u", "key", "u");
INSERT INTO t_key_list (name,type,info) VALUES ("i", "key", "i");
INSERT INTO t_key_list (name,type,info) VALUES ("o", "key", "o");
INSERT INTO t_key_list (name,type,info) VALUES ("p", "key", "p");
INSERT INTO t_key_list (name,type,info) VALUES ("lse", "key", "{");
INSERT INTO t_key_list (name,type,info) VALUES ("rse", "key", "}");
INSERT INTO t_key_list (name,type,info) VALUES ("rs", "key", "反斜");

-- 第二排
INSERT INTO t_key_list (name,type,info) VALUES ("capslock", "key", "大小写切换");
INSERT INTO t_key_list (name,type,info) VALUES ("a", "key", "a");
INSERT INTO t_key_list (name,type,info) VALUES ("s", "key", "s");
INSERT INTO t_key_list (name,type,info) VALUES ("d", "key", "d");
INSERT INTO t_key_list (name,type,info) VALUES ("f", "key", "f");
INSERT INTO t_key_list (name,type,info) VALUES ("g", "key", "g");
INSERT INTO t_key_list (name,type,info) VALUES ("h", "key", "h");
INSERT INTO t_key_list (name,type,info) VALUES ("j", "key", "j");
INSERT INTO t_key_list (name,type,info) VALUES ("k", "key", "k");
INSERT INTO t_key_list (name,type,info) VALUES ("l", "key", "l");
INSERT INTO t_key_list (name,type,info) VALUES ("colon", "key", "冒号");
INSERT INTO t_key_list (name,type,info) VALUES ("qm", "key", "引号");
INSERT INTO t_key_list (name,type,info) VALUES ("enter", "key", "回车");

-- 第三排

INSERT INTO t_key_list (name,type,info) VALUES ("shift", "key", "shift");
INSERT INTO t_key_list (name,type,info) VALUES ("z", "key", "z");
INSERT INTO t_key_list (name,type,info) VALUES ("x", "key", "x");
INSERT INTO t_key_list (name,type,info) VALUES ("c", "key", "c");
INSERT INTO t_key_list (name,type,info) VALUES ("v", "key", "v");
INSERT INTO t_key_list (name,type,info) VALUES ("b", "key", "b");
INSERT INTO t_key_list (name,type,info) VALUES ("n", "key", "n");
INSERT INTO t_key_list (name,type,info) VALUES ("m", "key", "m");
INSERT INTO t_key_list (name,type,info) VALUES ("co", "key", "小于");
INSERT INTO t_key_list (name,type,info) VALUES ("fs", "key", "大于");
INSERT INTO t_key_list (name,type,info) VALUES ("slant", "key", "slant");
INSERT INTO t_key_list (name,type,info) VALUES ("sapce", "key", "空格");
INSERT INTO t_key_list (name,type,info) VALUES ("doc", "key", "文档");

-- 功能区
INSERT INTO t_key_list (name,type,info) VALUES ("insert", "key", "功能区");
INSERT INTO t_key_list (name,type,info) VALUES ("delete", "key", "功能区");
INSERT INTO t_key_list (name,type,info) VALUES ("home", "key", "功能区");
INSERT INTO t_key_list (name,type,info) VALUES ("end", "key", "功能区");
INSERT INTO t_key_list (name,type,info) VALUES ("pgup", "key", "功能区");
INSERT INTO t_key_list (name,type,info) VALUES ("pgdn", "key", "功能区");

INSERT INTO t_key_list (name,type,info) VALUES ("up", "key", "上");
INSERT INTO t_key_list (name,type,info) VALUES ("down", "key", "下");
INSERT INTO t_key_list (name,type,info) VALUES ("left", "key", "左");
INSERT INTO t_key_list (name,type,info) VALUES ("right", "key", "右");

-- 小键盘
INSERT INTO t_key_list (name,type,info) VALUES ("numlock", "key", "小键盘锁");

INSERT INTO t_key_list (name,type,info) VALUES ("nadd", "key", "+");
INSERT INTO t_key_list (name,type,info) VALUES ("ncut", "key", "-");
INSERT INTO t_key_list (name,type,info) VALUES ("nride", "key", "*");
INSERT INTO t_key_list (name,type,info) VALUES ("nexc", "key", "除");

INSERT INTO t_key_list (name,type,info) VALUES ("n1", "key", "1");
INSERT INTO t_key_list (name,type,info) VALUES ("n2", "key", "2");
INSERT INTO t_key_list (name,type,info) VALUES ("n3", "key", "3");
INSERT INTO t_key_list (name,type,info) VALUES ("n4", "key", "4");
INSERT INTO t_key_list (name,type,info) VALUES ("n5", "key", "5");
INSERT INTO t_key_list (name,type,info) VALUES ("n6", "key", "6");
INSERT INTO t_key_list (name,type,info) VALUES ("n7", "key", "7");
INSERT INTO t_key_list (name,type,info) VALUES ("n8", "key", "8");
INSERT INTO t_key_list (name,type,info) VALUES ("n9", "key", "9");
INSERT INTO t_key_list (name,type,info) VALUES ("n0", "key", "0");

INSERT INTO t_key_list (name,type,info) VALUES ("ndel", "key", "ndel");

-- 控制区
INSERT INTO t_key_list (name,type,info) VALUES ("ESC", "key", "ESC");
INSERT INTO t_key_list (name,type,info) VALUES ("F1", "key", "F1");
INSERT INTO t_key_list (name,type,info) VALUES ("F2", "key", "F2");
INSERT INTO t_key_list (name,type,info) VALUES ("F3", "key", "F3");
INSERT INTO t_key_list (name,type,info) VALUES ("F4", "key", "F4");
INSERT INTO t_key_list (name,type,info) VALUES ("F5", "key", "F5");
INSERT INTO t_key_list (name,type,info) VALUES ("F6", "key", "F6");
INSERT INTO t_key_list (name,type,info) VALUES ("F7", "key", "F7");
INSERT INTO t_key_list (name,type,info) VALUES ("F8", "key", "F8");
INSERT INTO t_key_list (name,type,info) VALUES ("F9", "key", "F9");
INSERT INTO t_key_list (name,type,info) VALUES ("F10", "key", "F10");
INSERT INTO t_key_list (name,type,info) VALUES ("F11", "key", "F11");
INSERT INTO t_key_list (name,type,info) VALUES ("F12", "key", "F12");

INSERT INTO t_key_list (name,type,info) VALUES ("printscreen", "key", "printscreen");
INSERT INTO t_key_list (name,type,info) VALUES ("scrolllock", "key", "scrolllock");
INSERT INTO t_key_list (name,type,info) VALUES ("pause", "key", "pause");
