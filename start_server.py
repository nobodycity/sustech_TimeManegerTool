import http.server
import socketserver
import os
os.chdir(r'C:\Users\lenovo\Desktop\timemanager\project_TimeManager')
PORT = 5173
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(('', PORT), Handler) as httpd:
    httpd.serve_forever()
