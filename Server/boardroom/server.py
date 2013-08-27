import cherrypy
import os
import logging 
class FileDemo(object):
	#def index(self):

  def index(self):
    return "<a href='login'>login</a>"

  index.exposed = True
  
  
  def serve(self,room):
    
    out = """ <html>
              <head>
                <script language="JavaScript">
                  function refreshIt() {
                  if (!document.images) return;
                    document.images['pic'].src = 'http://localhost:8001/%s.png?' + Math.random();
                  }
                </script>
              </head>
              <body onLoad="refreshIt()">
                <img onLoad="setTimeout('refreshIt()',1000);" id="pic" src="" width = "100%%">
              </body>
            </html> """
  
    return out % (room)
  
  serve.exposed = True
  
  def login(self):
    return "<form name='input' action='http://localhost:8080/serve'>Room: <input type='text' name='room'><input type='submit' value='Submit'></form>"

  login.exposed = True
  
  def upload(self, myFile):
    out = """<html>
          <body>
          myFile length: %s<br />
          myFile filename: %s<br />
          myFile mime-type: %s
          </body>
          </html>"""
    size = 0
    allData=''
    while True:
      data = myFile.file.read(8192)
      logging.warning('data packet read')
      allData+=data
      if not data:
        break
        
      size += len(allData)
      savedFile=open(myFile.filename, 'wb')
      savedFile.write(allData)
      savedFile.close()
        
      os.rename('temp2.png', 'temp.png')
        
    return out % (size, myFile.filename, myFile.type)

  upload.exposed = True

cherrypy.config.update({'server.socket_host': '0.0.0.0'})
cherrypy.config.update({'server.socket_port': 8080,})
cherrypy.quickstart(FileDemo())

