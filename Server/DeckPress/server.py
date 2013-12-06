import cherrypy
import os
import logging
import pusher

class Root(object):
#def index(self):
    @cherrypy.expose

    def index(self):
        return "<a href='login'>login</a>"
    index.exposed = True

    def testPusher(self):

        out = """ <!DOCTYPE html>
<head>
  <title>Pusher Test</title>
  <script src="http://js.pusher.com/2.1/pusher.min.js" type="text/javascript"></script>
  <script type="text/javascript">
    // Enable pusher logging - don't include this in production
    Pusher.log = function(message) {
      if (window.console && window.console.log) {
        window.console.log(message);
      }
    };

    var pusher = new Pusher('73117b00e748bfc50cb4');
    var channel = pusher.subscribe('test_channel');
    channel.bind('my_event', function(data) {
      alert(data.message);
    });
  </script>
</head> """
        return out
    testPusher.exposed = True

    def serve(self, room):

        out = """ <html>
              <head>
                <script src="http://js.pusher.com/2.1/pusher.min.js" type="text/javascript"></script>
                <script language="JavaScript">
                  // Enable pusher logging - don't include this in production
    Pusher.log = function(message) {
      if (window.console && window.console.log) {
        window.console.log(message);
      }
    };

    var pusher = new Pusher('73117b00e748bfc50cb4');
    var channel = pusher.subscribe('test_channel');
    channel.bind('my_event', function(data) {
   refreshIt(data)
    });



                  function refreshIt(data) {
                  if (!document.images) return;
                    document.images['pic'].src = 'http://162.13.5.127/images/' +  data.message + '.png' ;
                  }


function toggleFullScreen() {
       if (!document.fullscreenElement &&    // alternative standard method
        !document.mozFullScreenElement && !document.webkitFullscreenElement) {  // current working methods
         if (document.documentElement.requestFullscreen) {
           document.documentElement.requestFullscreen();
         } else if (document.documentElement.mozRequestFullScreen) {
           document.documentElement.mozRequestFullScreen();
         } else if (document.documentElement.webkitRequestFullscreen) {
           document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
         }
       } else {
          if (document.cancelFullScreen) {
             document.cancelFullScreen();
          } else if (document.mozCancelFullScreen) {
             document.mozCancelFullScreen();
          } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
          }
       }
     }


                </script>
              </head>
              <body bgcolor="#FFFFFF" onLoad="">

                 <button onclick="toggleFullScreen(); return false">
        Toggle Fullscreen
    </button>

                <img id="pic" src="" width = "100%%">
              </body>
            </html> """

        return out
    serve.exposed = True

    def login(self):
        return "<style>input{ color: #781351;background: #fee3ad;border: 100px solid #781351}.submit input{font-size:10% color: #000;background: #ffa20f;border: 2px outset #d7b9c9}</style><form name='input' action='serve'>Room: <input type='text' name='room'><input type='submit' value='Submit'></form>"
    login.exposed = True

    def check(self, filename):

        if os.path.exists(filename + '.png'):
            p = pusher.Pusher(
            app_id='55201',
            key='73117b00e748bfc50cb4',
            secret='c192b64e3f803df1cbc6')
            p['test_channel'].trigger('my_event', {'message': filename})
            return "Found"
        else:
            return "Not Found"
    check.exposed = True

    def getfile(self, filename):

        if os.path.exists(filename + '.png'):

            f = open(filename, 'wb')

            return f
        else:
            return "Not Found"
    getfile.exposed = True

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
            savedFile=open(myFile.filename + "temp.png", 'wb')
            savedFile.write(allData)
            savedFile.close()

            os.rename(myFile.filename + "temp.png", myFile.filename+".png")

        p = pusher.Pusher(
        app_id='55201',
        key='73117b00e748bfc50cb4',
        secret='c192b64e3f803df1cbc6')
        p['test_channel'].trigger('my_event', {'message': myFile.filename})

        return out % (size, myFile.filename, myFile.type)

    upload.exposed = True

    def list(self):
        dirList = os.listdir("./Decks/")
        dirList.remove("DS_Store")
        return dirList
    list.exposed = True

cherrypy.config.update({'server.socket_host': '0.0.0.0'})
cherrypy.config.update({'server.socket_port': 80, })

conf = {'/images': {'tools.staticdir.on': True,
        'tools.staticdir.dir': '~/boardroom'}}
print conf
cherrypy.quickstart(Root(), '/', config=conf)


