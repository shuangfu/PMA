#coding: utf-8
 
import tornado.ioloop
import tornado.web
import tornado.httpserver
import json
import datetime
import os
import sqlite3


class indexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('welcome.html') #否则渲染welcome.html
        fin = open(os.path.join(os.path.dirname(__file__), "DB\data.json"), 'r', encoding='utf-8')
        s = json.load(fin)
        fin.close()
        for projectObj in s:
            if projectObj['projectDutyMan'] == "付爽1":
                print(projectObj)
        today = datetime.datetime.today()
        day1 = datetime.datetime(2016,1,1)
        print((today - day1).days)

def main():
    handlers = [
        (r'/', indexHandler),
    ]

    app = tornado.web.Application(handlers,
                                  static_path=os.path.join(os.path.dirname(__file__), "static"),
                                  template_path=os.path.join(os.path.dirname(__file__), "templates")
                                  )
    app.listen(8010)
    tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__": #启动tornado，配置里如果打开debug，则可以使用autoload，属于development模式，如果关闭debug，则不可以使用autoload，属于production模式。autoload的含义是当tornado监测到有任何文件发生变化，不需要重启server即可看到相应的页面变化，否则是修改了东西看不到变化。
    main()