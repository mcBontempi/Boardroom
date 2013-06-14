#!python
import glob
import os.path

import cherrypy
from cherrypy.lib.static import serve_file


class Root:

	def view(self):
		return """
		<html>
		<head><meta http-equiv="refresh" content="1"></head>
		<body>
		<img src="index" alt="Smiley face" height="1000" width="1000"/>
		</body></html>
		"""
	view.exposed = True
		
class Download:

    def index(self, filepath):
        return serve_file(filepath)
    index.exposed = True

if __name__ == '__main__':
    root = Root()
    root.download = Download()

cherrypy.config.update({'server.socket_host': '0.0.0.0'})
cherrypy.config.update({'server.socket_port': 9000,})
cherrypy.quickstart(root)
