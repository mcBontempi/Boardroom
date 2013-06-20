import cherrypyxxx
import os
class FileDemo(object):
	def index(self):
		return """
		<html><body>
		<h2>Upload a file</h2>
		<form action="upload" method="post" enctype="multipart/form-data">
		filename: <input type="file" name="myFile" /><br />
		<input type="submit" />
		</form>
		<h2>Download a file</h2>
		<a href='download'>This one</a>
		</body></html>
		"""
	index.exposed = True
	
	def view(self):   
		return """
		<html>
		<head><meta http-equiv="refresh" content="1"></head>
		<body>
		<img src="http://192.168.1.64:9000/temp.png" alt="Smiley face" height="1000" width="1000"/>
		</body></html>
		"""
	view.exposed = True
		
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
			allData+=data
			if not data:
				break
			
		size += len(allData)
		savedFile=open(myFile.filename, 'wb')
		savedFile.write(allData)
		savedFile.close()
		return out % (size, myFile.filename, myFile.type)
		#~ return allData
	upload.exposed = True

cherrypy.config.update({'server.socket_host': '0.0.0.0'})
cherrypy.config.update({'server.socket_port': 8080,})
cherrypy.quickstart(FileDemo())

