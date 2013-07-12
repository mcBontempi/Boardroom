import cherrypy
import os
import logging 
class FileDemo(object):
	#def index(self):
	
	def upload(self, myFile):
		out = """<html>
		<body>
		myFile length: %s<br />
		myFile filename: %s<br />
		myFile mime-type: %s
		</body>
		</html>"""
		# Although this just counts the file length, it demonstrates
		# how to read large files in chunks instead of all at once.
		# CherryPy uses Python's cgi module to read the uploaded file
		# into a temporary file; myFile.file.read reads from that.
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
		#~ return allData
	upload.exposed = True

cherrypy.config.update({'server.socket_host': '0.0.0.0'})
cherrypy.config.update({'server.socket_port': 8080,})
cherrypy.quickstart(FileDemo())

