import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const mime = { '.html': 'text/html', '.css': 'text/css', '.js': 'application/javascript' };
const root = new URL('.', import.meta.url).pathname;

http.createServer((req, res) => {
  let fp = path.join(root, req.url === '/' ? 'index.html' : req.url.split('?')[0]);
  if (!path.extname(fp)) fp = path.join(root, 'index.html');
  fs.readFile(fp, (err, data) => {
    if (err) {
      fs.readFile(path.join(root, 'index.html'), (e2, d2) => {
        if (e2) { res.writeHead(500); res.end('500'); return; }
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(d2);
      }); return;
    }
    const ct = mime[path.extname(fp)] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': ct + '; charset=utf-8' });
    res.end(data);
  });
}).listen(5173, '127.0.0.1', () => console.log('http://127.0.0.1:5173'));
