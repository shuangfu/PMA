#!/usr/bin/env python3
# -*- coding: utf-8 -*-
 
import tornado.ioloop
import tornado.web
import tornado.httpserver
import json
import datetime
import os
import sqlite3
import copy

def strToDate(tempStr):
    temp = tempStr.split('/')
    return datetime.datetime(int(temp[2]),int(temp[0]),int(temp[1]))

def getProjects(**kwargs):
    todayDate = datetime.datetime.today()
    tempf = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'r', encoding='utf-8')
    fs = json.load(tempf)
    if 'projectID' in kwargs:
        tempf.close()
        for tempProject in fs:
            if tempProject['projectCode'] == kwargs['projectID']:
                tempReturnProject = tempProject
                for tempStationObj in tempProject['stationArr']:
                    # temp = tempStationObj["startPoint"].split('/')
                    # startDate = datetime.datetime(int(temp[2]),int(temp[0]),int(temp[1]))
                    # print(type((todayDate - startDate).days))
                    if (todayDate - strToDate(tempStationObj['startPoint'])).days >= 0 and (tempStationObj["stageArr"][0]['statusFlag'] == "UNBEGINNING" or tempStationObj["stageArr"][0]['statusFlag'] == None):
                         tempStationObj["currentStage"] = '0'
                    tempStationObj["stageArr"][0]['startTime'] = tempStationObj['startPoint']
                    tempStationObj["stageArr"][0]['endTime'] = str((strToDate(tempStationObj["stageArr"][0]['startTime']) + datetime.timedelta(int(tempStationObj["stageArr"][0]['dueTime']))).strftime("%m/%d/%Y"))

                    for i in range(0, (len(tempStationObj["stageArr"]))):
                        if i > 0:
                            tempStationObj["stageArr"][i]['startTime'] = tempStationObj["stageArr"][i - 1]['endTime']
                            tempStationObj["stageArr"][i]['endTime'] = str((strToDate(tempStationObj["stageArr"][i]['startTime']) + datetime.timedelta(int(tempStationObj["stageArr"][i]['dueTime']))).strftime("%m/%d/%Y"))
                        print("there", i, tempStationObj["stageArr"][i]['startTime'])
                        if i < int(tempStationObj['currentStage']):
                            pass
                            # tempStationObj["stageArr"][i]['lable'] = (startDate + datetime.timedelta(int(tempStationObj["stageArr"][i]['infactTime']))).strftime('%x')
                            # tempStageObj['lable'] = startDate + int(tempStageObj['dueTime'])
                            # tempStationObj["stageArr"][i]['percent'] = 'test'
                        elif i == int(tempStationObj['currentStage']):
                            # tempStageObj['lable'] = startDate + int(tempStageObj['dueTime'])
                            tempStationObj["stageArr"][i]['lable'] = str((strToDate(tempStationObj["stageArr"][i]['endTime']) - strToDate(datetime.datetime.today().strftime("%m/%d/%Y"))).days)
                            # print("相差天数：", str((self.strToDate(tempStationObj["stageArr"][i]['endTime']) - self.strToDate(datetime.datetime.today().strftime("%m/%d/%Y"))).days))
                            print(tempStationObj["stageArr"][i]['endTime'], datetime.datetime.today().strftime("%x"))
                            tempStationObj["stageArr"][i]['infactTime'] = str((datetime.datetime.today() - strToDate(tempStationObj["stageArr"][i]['startTime'])).days)
                            tempStationObj["stageArr"][i]['statusFlag'] = 'RUNNING'
                            if tempStationObj["stageArr"][i]['dueTime'] == '0':
                                tempStationObj["stageArr"][i]['percent'] = '1'
                            else:
                                tempStationObj["stageArr"][i]['percent'] = str(int(tempStationObj["stageArr"][i]['infactTime']) / int(tempStationObj["stageArr"][i]['dueTime']))
                        else:
                            tempStationObj["stageArr"][i]['lable'] = tempStationObj["stageArr"][i]['endTime']
                            # tempStageObj['lable'] = startDate + int(tempStageObj['dueTime'])
                            tempStationObj["stageArr"][i]['percent'] = '0'
                            tempStationObj["stageArr"][i]['statusFlag'] = 'UNBEGINNING'
                            tempStationObj["stageArr"][i]['dueTime'] = str((strToDate(tempStationObj["stageArr"][i]['endTime']) - strToDate(tempStationObj["stageArr"][i]['startTime'])).days)
                            tempStationObj["stageArr"][i]['completedTime'] = '0'
                            tempStationObj["stageArr"][i]['infactTime'] = '0'
        tempf = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'w', encoding='utf-8')
        tempf.write(json.dumps(fs,ensure_ascii=False,indent=4))
        tempf.close()
        return tempReturnProject

    if 'projectDutyMan' in kwargs:
        tempReturnProjectList = []
        for tempProject in fs:
            if tempProject['projectDutyMan'] == kwargs['projectDutyMan']:
                tempReturnProjectList.append(tempProject)
                for tempStationObj in tempProject['stationArr']:
                    # temp = tempStationObj["startPoint"].split('/')
                    # startDate = datetime.datetime(int(temp[2]),int(temp[0]),int(temp[1]))
                    # print(type((todayDate - startDate).days))
                    if (todayDate - strToDate(tempStationObj['startPoint'])).days >= 0 and (tempStationObj["stageArr"][0]['statusFlag'] == "UNBEGINNING" or tempStationObj["stageArr"][0]['statusFlag'] == None):
                         tempStationObj["currentStage"] = '0'
                    tempStationObj["stageArr"][0]['startTime'] = tempStationObj['startPoint']
                    tempStationObj["stageArr"][0]['endTime'] = str((strToDate(tempStationObj["stageArr"][0]['startTime']) + datetime.timedelta(int(tempStationObj["stageArr"][0]['dueTime']))).strftime("%m/%d/%Y"))

                    for i in range(0, (len(tempStationObj["stageArr"]))):
                        if i > 0:
                            tempStationObj["stageArr"][i]['startTime'] = tempStationObj["stageArr"][i - 1]['endTime']
                            tempStationObj["stageArr"][i]['endTime'] = str((strToDate(tempStationObj["stageArr"][i]['startTime']) + datetime.timedelta(int(tempStationObj["stageArr"][i]['dueTime']))).strftime("%m/%d/%Y"))
                        print("there", i, tempStationObj["stageArr"][i]['startTime'])
                        if i < int(tempStationObj['currentStage']):
                            pass
                            # tempStationObj["stageArr"][i]['lable'] = (startDate + datetime.timedelta(int(tempStationObj["stageArr"][i]['infactTime']))).strftime('%x')
                            # tempStageObj['lable'] = startDate + int(tempStageObj['dueTime'])
                            # tempStationObj["stageArr"][i]['percent'] = 'test'
                        elif i == int(tempStationObj['currentStage']):
                            # tempStageObj['lable'] = startDate + int(tempStageObj['dueTime'])
                            tempStationObj["stageArr"][i]['lable'] = str((strToDate(tempStationObj["stageArr"][i]['endTime']) - strToDate(datetime.datetime.today().strftime("%m/%d/%Y"))).days)
                            # print("相差天数：", str((self.strToDate(tempStationObj["stageArr"][i]['endTime']) - self.strToDate(datetime.datetime.today().strftime("%m/%d/%Y"))).days))
                            print(tempStationObj["stageArr"][i]['endTime'], datetime.datetime.today().strftime("%x"))
                            tempStationObj["stageArr"][i]['infactTime'] = str((datetime.datetime.today() - strToDate(tempStationObj["stageArr"][i]['startTime'])).days)
                            tempStationObj["stageArr"][i]['statusFlag'] = 'RUNNING'
                            if tempStationObj["stageArr"][i]['dueTime'] == '0':
                                tempStationObj["stageArr"][i]['percent'] = '1'
                            else:
                                tempStationObj["stageArr"][i]['percent'] = str(int(tempStationObj["stageArr"][i]['infactTime']) / int(tempStationObj["stageArr"][i]['dueTime']))
                        else:
                            tempStationObj["stageArr"][i]['lable'] = tempStationObj["stageArr"][i]['endTime']
                            # tempStageObj['lable'] = startDate + int(tempStageObj['dueTime'])
                            tempStationObj["stageArr"][i]['percent'] = '0'
                            tempStationObj["stageArr"][i]['statusFlag'] = 'UNBEGINNING'
                            tempStationObj["stageArr"][i]['dueTime'] = str((strToDate(tempStationObj["stageArr"][i]['endTime']) - strToDate(tempStationObj["stageArr"][i]['startTime'])).days)
                            tempStationObj["stageArr"][i]['completedTime'] = '0'
                            tempStationObj["stageArr"][i]['infactTime'] = '0'
        tempf = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'w', encoding='utf-8')
        tempf.write(json.dumps(fs,ensure_ascii=False,indent=4))
        tempf.close()
        return tempReturnProjectList

class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('Main.html') #否则渲染welcome.html
        # fin = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'r', encoding='utf-8')
        # s = json.load(fin)
        # fin.close()
        # for projectObj in s:
        #     if projectObj['projectDutyMan'] == "付爽1":
        #         for stationObj in projectObj['stationArr']:
        #             for stageObj in stationObj['stageArr']:
        #                 stageObj['dueTime'] = "000"
        #
        # fin = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'w', encoding='utf-8')
        # fin.write(json.dumps(s,ensure_ascii=False,indent=4))
        # fin.close()
        # today = datetime.datetime.today()
        # day1 = datetime.datetime(2016,1,1)
        # print((today - day1).days)

class ChangeStatus(tornado.web.RequestHandler):
    def strToDate(self,tempStr):
        temp = tempStr.split('/')
        return datetime.datetime(int(temp[2]),int(temp[0]),int(temp[1]))
    def get(self):
        fins = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'r', encoding='utf-8')
        fs = json.load(fins)
        fins.close()
        for projectObj in fs:
            if projectObj['projectCode'] == self.get_argument("project"):
                for stationObj in projectObj['stationArr']:
                    if stationObj["stationNum"] == self.get_argument("station"):
                        stationObj["stageArr"][int(self.get_argument("stage"))]['completedTime'] = datetime.datetime.today().strftime("%m/%d/%Y")
                        stationObj["stageArr"][int(self.get_argument("stage"))]['infactTime'] = str((self.strToDate(stationObj["stageArr"][int(self.get_argument("stage"))]['completedTime']) - self.strToDate(stationObj["stageArr"][int(self.get_argument("stage"))]['startTime'])).days)
                        if stationObj["stageArr"][int(self.get_argument("stage"))]['dueTime'] == '0':
                            stationObj["stageArr"][int(self.get_argument("stage"))]['percent'] = stationObj["stageArr"][int(self.get_argument("stage"))]['infactTime']
                        else:
                            stationObj["stageArr"][int(self.get_argument("stage"))]['percent'] = int(stationObj["stageArr"][int(self.get_argument("stage"))]['infactTime']) / int(stationObj["stageArr"][int(self.get_argument("stage"))]['dueTime'])
                        stationObj["stageArr"][int(self.get_argument("stage"))]['statusFlag'] = "COMPLETED"
                        stationObj['currentStage'] = str(int(self.get_argument("stage")) + 1)
                        print('update status of',stationObj["stationName"],'stage to', str(int(self.get_argument("stage")) + 1))
        fins = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'w', encoding='utf-8')
        fins.write(json.dumps(fs,ensure_ascii=False,indent=4))
        fins.close()
        self.write(getProjects(projectID=self.get_argument("project")))

class LoginHandler(tornado.web.RequestHandler):
    def get(self):
        if self.get_argument("un") == "fs" and self.get_argument("pw") == "123":
            self.write("OK")
        else:
            self.write("NG")

class GetConvData(tornado.web.RequestHandler):
    def get(self):
        # tempf = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'r', encoding='utf-8')
        # fs = json.load(tempf)
        # tempf.close()
        tempStrList = []
        convData = {
            "pmName" : self.get_argument("un"),
            "date":datetime.datetime.today().strftime("%x")
        }
        projectsList = getProjects(projectDutyMan=self.get_argument("un"))
        convData['projectNums'] = len(projectsList)

        for tempProject in projectsList:
            for tempStation in tempProject['stationArr']:
                for i, tempStage in enumerate(tempStation['stageArr']):
                    if tempStage['statusFlag'] == "RUNNING" and float(tempStage['percent']) >= 1:
                        tempStrList.append({
                            'projectName' : tempProject['projectName'],
                            'stationNum' : tempStation['stationNum'],
                            'stageNum' : str(i + 1),
                            'percent' : ("%.2f" % float(tempStage['percent'])),
                            'dutyMan' : tempStation['dutyMan'],
                            'projectID' : tempProject['projectCode']
                        })

        convData['delayInfo'] = tempStrList

        self.write(json.dumps(convData,ensure_ascii=False))

    def strToDate(self,tempStr):
        temp = tempStr.split('-')
        return datetime.datetime(int(temp[2]),int(temp[0]),int(temp[1]))

class GetProjectsByIDHandler(tornado.web.RequestHandler):
    def get(self):
        self.write(json.dumps(getProjects(projectID=self.get_argument("projectID")),ensure_ascii=False))

class GetProjectsByDutyManHandler(tornado.web.RequestHandler):
    def get(self):
        getProjects(projectDutyMan=self.get_argument("projectDutyMan"))

def main():
    handlers = [
        (r'/', IndexHandler),
        (r'/getProjectsByDutyMan',GetProjectsByDutyManHandler),
        (r'/getProjectsByID',GetProjectsByIDHandler),
        (r'/cd', ChangeStatus),
        (r'/login', LoginHandler),
        (r'/getConvData', GetConvData)
    ]

    app = tornado.web.Application(handlers,
                                  static_path=os.path.join(os.path.dirname(__file__), "static"),
                                  template_path=os.path.join(os.path.dirname(__file__), "templates")
                                  )
    app.listen(8010)
    tornado.ioloop.IOLoop.instance().start()





if __name__ == "__main__": #启动tornado，配置里如果打开debug，则可以使用autoload，属于development模式，如果关闭debug，则不可以使用autoload，属于production模式。autoload的含义是当tornado监测到有任何文件发生变化，不需要重启server即可看到相应的页面变化，否则是修改了东西看不到变化。
    main()