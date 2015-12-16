#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from sqlite3 import connect

import tornado.ioloop
import tornado.web
# import tornado.autoreload
import tornado.httpserver
import json
import datetime
import os
import pymysql

class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('Main.html')
        print("IP:%s has connect." % (self.request.remote_ip))

class AddProject(tornado.web.RequestHandler):
    def post(self):
        getData = json.loads(self.get_argument('pi'))
        projectName = getData["projectName"]
        stations = getData["stations"]
        stages = getData["stations"][0][3]
        print(getData)
        print(stations)
        print("-------- projectName,realName--------",getData["projectName"],getData["realName"])
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = """
            INSERT project(projectName,projectDutyman) VALUES ("%s","%s")
        """ % (projectName, getData["realName"])
        cur.execute(sqlStr)
        print("project insert completed")
        conn.commit()
        for index,val in enumerate(stations):
            print(val)
            sqlStr = """
                INSERT station(stationName, stationSequence, starttime, blueprintQuantity, projectBelong) VALUES ("%s","%s","%s","%s","%s")
            """  % (val[0]["stationName"], index + 1,val[2]["starttime"], val[1]["blueprintQuantity"], projectName)
            print("the sql is",sqlStr)
            cur.execute(sqlStr)
            print("station insert completed")
            for indexStage, valStage in enumerate(val[3]):
                print("stage:",valStage)
                sqlStr = """
                    INSERT  stage(stageName, stageSequence, planningStartTime, planningEndTime,  stageDutyman, projectBelong, stationBelong) VALUES ("%s","%s","%s","%s","%s","%s","%s")
                """ % (valStage["stageName"], indexStage + 1,valStage["starttime"], valStage["endtime"], valStage["dutyMan"], projectName, val[0]["stationName"])
                print("the sql2 is",sqlStr)
                cur.execute(sqlStr)
                print("stage insert completed")
        conn.commit()
        sqlstr = """
            UPDATE stage
            SET status = 'RUNNING'
            WHERE stageName = '3D' AND status = 'UNBEGINNING' AND datediff(now(), planningStartTime) >= 0;
          """
        cur.execute(sqlstr)
        print("update all UNBEGINNING stage to RUNNING")
        conn.commit()
        cur.close()
        conn.close()

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
        sqlStr = "UPDATE stage SET status='COMPLETED' WHERE stageID = '%s'" % (stageID)
        print("sql:",sqlStr)
        cur.execute(sqlStr)
        conn.commit()
        sqlStr = "UPDATE stage SET actualEndTime = now() WHERE stageID = '%s'" % (stageID)
        print("sql:",sqlStr)
        cur.execute(sqlStr)
        conn.commit()
        sqlStr = """
            SELECT stageSequence,projectBelong,stationBelong
            FROM stage
            WHERE stageID='%s'
         """ % (stageID)
        data = cur.fetchmany(cur.execute(sqlStr))
        conn.commit()
        tempSequence = data[0][0]
        print("search stageID back:",data)
        if int(tempSequence) < 9:
            sqlStr = """
                SELECT stageID
                FROM stage
                WHERE stageSequence='%s' AND projectBelong = "%s" AND stationBelong = "%s"
            """ % (str(int(tempSequence) + 1),data[0][1],data[0][2])
            data = cur.fetchmany(cur.execute(sqlStr))
            print("sql:", sqlStr)

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
            SELECT planningStartTime,planningEndTime,stageDutyman,status,datediff(planningEndTime,planningStartTime)
            FROM stage
            WHERE stageID='%s'
        """ % (stageID)
        data = cur.fetchmany(cur.execute(sqlStr))
        stageInfo = data[0]
        tempObj = {}
        tempObj['starttime'] = stageInfo[0].strftime('%Y-%m-%d')
        tempObj['endtime'] = stageInfo[1].strftime('%Y-%m-%d')
        tempObj['stageDutyman'] = stageInfo[2]
        tempObj['status'] = stageInfo[3]
        tempObj['dueDays'] = stageInfo[4] if stageInfo[4] > 0 else 1
        if tempObj['status'] == "RUNNING":
            sqlStr = """
                SELECT CONVERT(TRUNCATE((datediff(now(),planningStartTime) / CASE WHEN datediff(planningEndTime,planningStartTime)=0 THEN 1 ELSE datediff(planningEndTime,planningStartTime) END)*100,0), char)
                FROM stage
                WHERE stageID='%s'
            """ % (stageID)
            data = cur.fetchmany(cur.execute(sqlStr))
            tempObj['progress'] = data[0]
        elif tempObj['status'] == "COMPLETED":
            sqlStr = """
                SELECT CONVERT(TRUNCATE((datediff(actualEndTime,planningStartTime) / CASE WHEN datediff(planningEndTime,planningStartTime)=0 THEN 1 ELSE datediff(planningEndTime,planningStartTime) END)*100,0), char)
                FROM stage
                WHERE stageID='%s'
            """ % (stageID)
            data = cur.fetchmany(cur.execute(sqlStr))
            tempObj['progress'] = data[0][0] if float(data[0][0]) > 0 else 1
        else:
            tempObj['progress'] = 0
        self.write(json.dumps(tempObj,ensure_ascii=False))
        print(tempObj)
        cur.close()
        conn.close()

class GetProjectDelayInfo(tornado.web.RequestHandler):
    def post(self, *args, **kwargs):
        username = self.get_argument('un')
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = "select role from user where un='%s'" % (username,)
        data = cur.fetchmany(cur.execute(sqlStr))
        if data[0][0] == 'manager':
            # sqlStr = "SELECT p.projectName, GROUP_CONCAT(st.stationName,'|', sg.stageName,'|', datediff(now(),sg.endtime),'|', CONVERT(TRUNCATE((datediff(now(),sg.starttime) / CASE WHEN datediff(sg.endtime,sg.starttime)=0 THEN 1 ELSE datediff(sg.endtime,sg.starttime) END)*100,1), char),'|', sg.stageDutyman) FROM project p,station st,stage sg WHERE datediff(sg.endtime,now()) < 0 and sg.stationBelong=st.stationName and sg.projectBelong=p.projectName and st.projectBelong=p.projectName AND sg.status='RUNNING' GROUP BY p.projectName"
            sqlStr = """
                SELECT p.projectName, st.stationName, sg.stageName, datediff(now(),sg.planningEndTime), CONVERT(TRUNCATE((datediff(now(),sg.planningStartTime) / CASE WHEN datediff(sg.planningEndTime,sg.planningStartTime)=0 THEN 1 ELSE datediff(sg.planningEndTime,sg.planningStartTime) END)*100,0), char), sg.stageDutyman
                FROM project p,station st,stage sg
                WHERE datediff(sg.planningEndTime,now()) < 0 and sg.stationBelong=st.stationName and sg.projectBelong=p.projectName and st.projectBelong=p.projectName AND sg.status='RUNNING'
                ORDER BY datediff(now(),sg.planningEndTime) DESC
              """
            data = cur.fetchmany(cur.execute(sqlStr))
            backdata=[]
            for stage in data:
                backdata.append(stage)
        else:
            sqlStr = "SELECT name from user WHERE un='%s'" % (username)
            realname = cur.fetchmany(cur.execute(sqlStr))[0][0]
            sqlStr = """
                SELECT p.projectName, GROUP_CONCAT(st.stationName,'|', sg.stageName,'|', datediff(now(),sg.planningEndTime),'|', CONVERT(TRUNCATE((datediff(now(),sg.planningStartTime) / CASE WHEN datediff(sg.planningEndTime,sg.planningStartTime)=0 THEN 1 ELSE datediff(sg.planningEndTime,sg.planningStartTime) END)*100,0), char),'|', sg.stageDutyman)
                FROM project p, station st, stage sg
                WHERE datediff(sg.planningEndTime,now()) < 0 and p.projectDutyMan='%s' and sg.stationBelong=st.stationName and sg.projectBelong=p.projectName and st.projectBelong=p.projectName AND sg.status='RUNNING'
                GROUP BY p.projectName
            """ % (realname)
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
    def post(self):
        projectName = self.get_argument('pn')
        conn = pymysql.connect(host ='localhost',user='root', password='lyric',database='lyric_PMA',charset='utf8',port=3309)
        cur = conn.cursor()
        sqlStr = """
            SELECT distinct st.stationSequence,st.stationName,st.blueprintQuantity,st.starttime
            FROM project p,station st
            WHERE p.projectName='%s' and st.projectBelong='%s'
        """ % (projectName,projectName)

        dataI = cur.fetchmany(cur.execute(sqlStr))
        tempArr = []
        for tempII in dataI:
            tempObj = {}
            sqlStr = """
                SELECT CASE
                   WHEN status='RUNNING' THEN datediff(planningEndTime,now())
                   WHEN status='UNBEGINNING' THEN date(planningEndTime)
                   WHEN status='COMPLETED' THEN date(actualEndTime)
                END label,stageID,stageName,stageDutyman,CONVERT(TRUNCATE((datediff(now(),planningStartTime) / CASE
                                                                                                WHEN datediff(planningEndTime,planningStartTime)=0 THEN 1
                                                                                                ELSE datediff(planningEndTime,planningStartTime)
                                                                                            END)*100,0),char) progress,status
                FROM stage
                WHERE stationBelong="%s" and projectBelong="%s"
                ORDER BY stageSequence
            """ % (str(tempII[1]),projectName)
            dataJ = cur.fetchmany(cur.execute(sqlStr))
            tempObj["stationNo"] = str(tempII[0])
            tempObj["stationName"] = str(tempII[1])
            tempObj["bluePrintQ"] = str(tempII[2])
            tempObj["stationStartTime"] = tempII[3].strftime('%Y-%m-%d')
            tempObj["stageArr"] = dataJ
            # for tempJJ in  dataJ:
            #     tempObj["stageArr"].append(tempJJ[0])
            tempArr.append(tempObj)

        print("project info obj:",json.dumps(tempArr,ensure_ascii=False))
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
        (r'/addProject',AddProject),
    ]
    settings = \
    {
        "cookie_secret": "HeavyMetalWillNeverDie", #Cookie secret
        "xsrf_cookies": False, #开启跨域安全
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