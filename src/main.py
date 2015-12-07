#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tornado.ioloop
import tornado.web
# import tornado.autoreload
import tornado.httpserver
import json
import datetime
import os
import pymysql

def strToDate(tempStr):
    temp = tempStr.split('/')
    return datetime.datetime(int(temp[2]),int(temp[0]),int(temp[1]))

class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('Main.html')

class LoginHandler(tornado.web.RequestHandler):
    def get(self):
        password = self.get_argument('pw')
        username = self.get_argument('un')
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        data = cur.fetchmany(cur.execute("select * from user where un='%s'" % (username)))
        print(data)
        if data == () or password != data[0][2]:
            self.write(json.dumps({'role':'None'},ensure_ascii=False))
        else:
            role = data[0][3]
            realName = data[0][4]
            print(realName," has login")
            backdata = {"role" : role, "realName":realName}
            self.write(json.dumps(backdata,ensure_ascii=False))
        cur.close()
        conn.close()
class ChangeStageInfo(tornado.web.RequestHandler):
    def get(self, *args, **kwargs):
        stageID = self.get_argument("stageID")
        print("stageID+++++",stageID)
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = "UPDATE stage SET status='COMPLETED' WHERE stageID='%s'" % (stageID)
        print("sql:",sqlStr)
        cur.execute(sqlStr)
        conn.commit()
        sqlStr = """
            SELECT stageSequence
            FROM stage
            WHERE stageID='%s'
         """ % (stageID)
        data = cur.fetchmany(cur.execute(sqlStr))
        conn.commit()
        tempSequence = data[0][0]

        if int(tempSequence) < 9:
            sqlStr = """
                SELECT stageID
                FROM stage
                WHERE stageSequence='%s'
            """ % (str(int(tempSequence) + 1))
        data = cur.fetchmany(cur.execute(sqlStr))
        conn.commit()
        print(data)
        sqlStr = """
                UPDATE stage
                SET status='RUNNING'
                WHERE stageID='%s'
            """ % data[0][0]
        data = cur.fetchmany(cur.execute(sqlStr))
        conn.commit()
        cur.close()
        conn.close()
        self.write('hi')
class GetStageInfo(tornado.web.RequestHandler):
    def get(self):
        stageID = self.get_argument('stageID')
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = """
            SELECT starttime,endtime,stageDutyman,status,datediff(endtime,starttime)
            FROM stage
            WHERE stageID='%s'
        """ % (stageID)
        data = cur.fetchmany(cur.execute(sqlStr))
        for stageInfo in data:
            tempObj = {}
            tempObj['starttime'] = stageInfo[0].strftime('%Y-%m-%d')
            tempObj['endtime'] = stageInfo[1].strftime('%Y-%m-%d')
            tempObj['stageDutyman'] = stageInfo[2]
            tempObj['status'] = stageInfo[3]
            tempObj['dueDays'] = stageInfo[4] if stageInfo[4] > 0 else 1
        if tempObj['status'] == "RUNNING":
            sqlStr = """
                SELECT CONVERT(TRUNCATE((datediff(now(),starttime) / CASE WHEN datediff(endtime,starttime)=0 THEN 1 ELSE datediff(endtime,starttime) END)*100,1), char)
                FROM stage
                WHERE stageID='%s'
            """ % (stageID)
            data = cur.fetchmany(cur.execute(sqlStr))
            tempObj['progress'] = data[0]
        elif tempObj['status'] == "COMPLETED":
            sqlStr = """
                SELECT CONVERT(TRUNCATE((datediff(completedTime,starttime) / CASE WHEN datediff(endtime,starttime)=0 THEN 1 ELSE datediff(endtime,starttime) END)*100,1), char)
                FROM stage
                WHERE stageID='%s'
            """ % (stageID)
            tempObj['progress'] = data[0] if data[0] > 0 else 1
        else:
            tempObj['progress'] = 0
        self.write(json.dumps(tempObj,ensure_ascii=False))
        print(tempObj)
        cur.close()
        conn.close()

class GetProjectDelayInfo(tornado.web.RequestHandler):
    def get(self, *args, **kwargs):
        username = self.get_argument('un')
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = "select role from user where un='%s'" % (username,)
        data = cur.fetchmany(cur.execute(sqlStr))
        if data[0][0] == 'manager':
            # sqlStr = "SELECT p.projectName, GROUP_CONCAT(st.stationName,'|', sg.stageName,'|', datediff(now(),sg.endtime),'|', CONVERT(TRUNCATE((datediff(now(),sg.starttime) / CASE WHEN datediff(sg.endtime,sg.starttime)=0 THEN 1 ELSE datediff(sg.endtime,sg.starttime) END)*100,1), char),'|', sg.stageDutyman) FROM project p,station st,stage sg WHERE datediff(sg.endtime,now()) < 0 and sg.stationBelong=st.stationName and sg.projectBelong=p.projectName and st.projectBelong=p.projectName AND sg.status='RUNNING' GROUP BY p.projectName"
            sqlStr = "SELECT p.projectName, st.stationName, sg.stageName, datediff(now(),sg.endtime), CONVERT(TRUNCATE((datediff(now(),sg.starttime) / CASE WHEN datediff(sg.endtime,sg.starttime)=0 THEN 1 ELSE datediff(sg.endtime,sg.starttime) END)*100,1), char), sg.stageDutyman FROM project p,station st,stage sg WHERE datediff(sg.endtime,now()) < 0 and sg.stationBelong=st.stationName and sg.projectBelong=p.projectName and st.projectBelong=p.projectName AND sg.status='RUNNING' ORDER BY datediff(now(),sg.endtime) DESC "
            data = cur.fetchmany(cur.execute(sqlStr))
            backdata=[]
            for stage in data:
                print("see",stage)
                backdata.append(stage)
        else:
            sqlStr = "SELECT name from user WHERE un='%s'" % (username)
            realname = cur.fetchmany(cur.execute(sqlStr))[0][0]
            sqlStr = "SELECT p.projectName, GROUP_CONCAT(st.stationName,'|', sg.stageName,'|', datediff(now(),sg.endtime),'|', CONVERT(TRUNCATE((datediff(now(),sg.starttime) / CASE WHEN datediff(sg.endtime,sg.starttime)=0 THEN 1 ELSE datediff(sg.endtime,sg.starttime) END)*100,1), char),'|', sg.stageDutyman) FROM project p,station st,stage sg WHERE datediff(sg.endtime,now()) < 0 and p.projectDutyMan='%s' and sg.stationBelong=st.stationName and sg.projectBelong=p.projectName and st.projectBelong=p.projectName AND sg.status='RUNNING' GROUP BY p.projectName" % (realname)
            data = cur.fetchmany(cur.execute(sqlStr))
            tempProjectName = ''
            backdata=[]
            for project in data:
                tempObj = {}
                tempObj['projectName'] = project[0]
                tempObj['list'] = []
                for stage in project[1].split(','):
                    tempObj['list'].append(stage)
                backdata.append(tempObj)
        self.write(json.dumps(backdata,ensure_ascii=False))

        cur.close()
        conn.close()
class GetProjectInfo(tornado.web.RequestHandler):
    def get(self, *args, **kwargs):
        projectName = self.get_argument('pn')
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = """
            SELECT distinct st.stationNo,st.stationName,st.blueprintQuantity,sg.stageDutyman,st.starttime,sg.stageID
            FROM project p,station st,stage sg
            WHERE p.projectName='%s' and st.projectBelong='%s' and sg.projectBelong='%s' and sg.stationBelong=st.stationName
        """ % (projectName,projectName,projectName)

        dataI = cur.fetchmany(cur.execute(sqlStr))
        # backdata=[]
        # for project in data:
        #     tempObj = {}
        #     tempObj['projectName'] = project[0]
        #     tempObj['list'] = []
        #     for stage in project[1].split(','):
        #         tempObj['list'].append(stage)
        #     backdata.append(tempObj)
        # self.write(json.dumps(backdata,ensure_ascii=False))
        tempArr = []
        for tempII in dataI:
            tempObj = {}
            sqlStr = """
                SELECT CASE WHEN status="RUNNING" THEN datediff(endtime,now()) ELSE date(starttime) END,stageID,CONVERT(TRUNCATE((datediff(now(),starttime) / CASE WHEN datediff(endtime,starttime)=0 THEN 1 ELSE datediff(endtime,starttime) END)*100,1),char),status
                FROM stage
                WHERE stationBelong='%s' and projectBelong='%s'
                ORDER BY stageSequence
            """ % (str(tempII[1]),projectName)
            dataJ = cur.fetchmany(cur.execute(sqlStr))
            tempObj["stationNo"] = str(tempII[0])
            tempObj["stationName"] = str(tempII[1])
            tempObj["bluePrintQ"] = str(tempII[2])
            tempObj["stageDutyman"] = str(tempII[3])
            tempObj["stationStartTime"] = tempII[4].strftime('%Y-%m-%d')
            tempObj["stageArr"] = dataJ
            # for tempJJ in  dataJ:
            #     tempObj["stageArr"].append(tempJJ[0])
            tempArr.append(tempObj)

        print(tempArr)
        self.write(json.dumps(tempArr,ensure_ascii=False))
        cur.close()
        conn.close()


def main():
    handlers = [
        (r'/', IndexHandler),
        (r'/login', LoginHandler),
        (r'/getProjectDelayInfo', GetProjectDelayInfo),
        (r'/getProjectInfo', GetProjectInfo),
        (r'/getStageInfo', GetStageInfo),
        (r'/changeStageInfo',ChangeStageInfo),
    ]
    settings = \
    {
        "cookie_secret": "HeavyMetalWillNeverDie", #Cookie secret
        "xsrf_cookies": True, #开启跨域安全
        "gzip": False, #关闭gzip输出
        "debug": False, #关闭调试模式，其实调试模式是很纠结的一事，我喜欢打开。
        "static_path" : os.path.join(os.path.dirname(__file__), "./static"),
        "template_path" : os.path.join(os.path.dirname(__file__), "./templates"),

    }
    app = tornado.web.Application(handlers,**settings)

    app.listen(8010)
    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__": #启动tornado，配置里如果打开debug，则可以使用autoload，属于development模式，如果关闭debug，则不可以使用autoload，属于production模式。autoload的含义是当tornado监测到有任何文件发生变化，不需要重启server即可看到相应的页面变化，否则是修改了东西看不到变化。
    main()