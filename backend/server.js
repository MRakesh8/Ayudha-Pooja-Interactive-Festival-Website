// =======================================================================
// 🚀 TECHNITIX BACKEND LOCALHOST SERVER (Port: 5500)
// =======================================================================
// 📁 PROJECT ARCHITECTURE:
//    ├── frontend/   ➔ HTML Pages & Assets (finialpro1.html, media.html, index.html, assets/)
//    ├── backend/    ➔ Server Engine (server.js)
//    └── database/   ➔ User Media Config & Media (media-config.js, media/)
//
// 📌 HOW TO START THIS LOCALHOST SERVER:
//    👉 node backend/server.js   (from project root)
//    👉 npm start                (from project root)
//    👉 node server.js           (from inside backend folder)
//
// 🌐 BROWSER ACCESS URLS:
//    - 🏛️ Royal Simulator : http://127.0.0.1:5500/finialpro1.html
//    - 🎬 Media Player    : http://127.0.0.1:5500/media.html
//    - 🏠 Default Root    : http://127.0.0.1:5500/
// =======================================================================

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 5500;
const PROJECT_ROOT = path.resolve(__dirname, '..');

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.mp3': 'audio/mpeg',
  '.wav': 'audio/wav',
  '.ogg': 'audio/ogg',
  '.m4a': 'audio/mp4',
  '.mp4': 'video/mp4',
  '.webm': 'video/webm',
  '.mov': 'video/quicktime'
};

// =======================================================================
// ⚙️ SMART WINDOWS PATH RESOLVER (Handles local files outside project)
// =======================================================================
function resolveWindowsPath(input) {
  if (!input) return '';
  let clean = input.trim().replace(/^['"]+|['"]+$/g, '');
  // Auto-heal unescaped \v (vertical tab \x0B) to 'v' (e.g. \vidssave -> vidssave)
  clean = clean.replace(/[\x0B\u000B]/g, 'v');
  // Auto-heal missing slash after drive letter when \V was unescaped: "D:Videos" -> "D:/Videos"
  clean = clean.replace(/^([a-zA-Z]:)\s*(?![\/\\])/i, '$1/');
  // Fix accidental space after drive letter: "D: \..." -> "D:/..."
  clean = clean.replace(/^([a-zA-Z]:)\s*[\/\\]+/i, '$1/');
  clean = clean.replace(/\\/g, '/');

  const norm = path.normalize(clean);
  if (fs.existsSync(norm) && fs.statSync(norm).isFile()) return norm;

  // Smart folder search if minor typo, missing space or extra space in filename
  const dir = path.dirname(norm);
  const base = path.basename(norm);
  if (fs.existsSync(dir)) {
    try {
      const files = fs.readdirSync(dir);
      const targetSimp = base.replace(/[\s\(\)_.-]/g, '').toLowerCase();
      for (const f of files) {
        const fSimp = f.replace(/[\s\(\)_.-]/g, '').toLowerCase();
        if (fSimp === targetSimp || fSimp.includes(targetSimp.slice(0, 20))) {
          const matched = path.join(dir, f);
          if (fs.statSync(matched).isFile()) return matched;
        }
      }
    } catch (e) { }
  }
  return norm;
}

// =======================================================================
// 📂 MULTI-TIER STATIC FILE RESOLVER (frontend, database, backend)
// =======================================================================
function resolveStaticFilePath(rawReqPath) {
  let reqPath = decodeURI(rawReqPath);
  if (reqPath === '/' || reqPath === '') reqPath = '/finialpro1.html';

  const clean = reqPath.startsWith('/') ? reqPath.slice(1) : reqPath;
  const baseName = path.basename(clean);

  // Search candidate paths in priority order across modular directories
  const candidates = [
    // 1. In frontend/ (HTML, JS, CSS, assets)
    path.join(PROJECT_ROOT, 'frontend', clean),
    path.join(PROJECT_ROOT, 'frontend', clean.replace(/^frontend[\/\\]/i, '')),
    // 2. In frontend/assets/ (Images, textures, photos)
    path.join(PROJECT_ROOT, 'frontend', 'assets', clean.replace(/^(frontend[\/\\]|database[\/\\])?assets[\/\\]/i, '')),
    path.join(PROJECT_ROOT, 'frontend', 'assets', baseName),
    // 3. In database/ (media-config.js, media/)
    path.join(PROJECT_ROOT, 'database', clean),
    path.join(PROJECT_ROOT, 'database', clean.replace(/^database[\/\\]/i, '')),
    path.join(PROJECT_ROOT, 'database', baseName),
    // 4. In database/media/ (sample audio, video)
    path.join(PROJECT_ROOT, 'database', 'media', clean.replace(/^(database[\/\\])?media[\/\\]/i, '')),
    path.join(PROJECT_ROOT, 'database', 'media', baseName),
    // 5. In backend/
    path.join(PROJECT_ROOT, 'backend', clean),
    // 6. Direct path from project root (fallback)
    path.join(PROJECT_ROOT, clean)
  ];

  for (const c of candidates) {
    try {
      if (fs.existsSync(c) && fs.statSync(c).isFile()) {
        return c;
      }
    } catch (e) { }
  }

  // Fallback to project root path
  return path.join(PROJECT_ROOT, 'frontend', clean);
}

// =======================================================================
// 🌐 HTTP SERVER & API ENGINE
// =======================================================================
const server = http.createServer((req, res) => {
  let reqUrl;
  try {
    reqUrl = new URL(req.url, `http://${req.headers.host || '127.0.0.1:5500'}`);
  } catch (e) {
    res.statusCode = 400;
    res.end('Bad Request');
    return;
  }

  if (req.method === 'OPTIONS') {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', '*');
    res.writeHead(204);
    res.end();
    return;
  }

  // ⚡ 1. LIVE CONFIG API: Polls media-config.js from database/ folder
  if (reqUrl.pathname === '/api/media-config') {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    res.setHeader('Pragma', 'no-cache');
    res.setHeader('Expires', '0');

    try {
      const configCandidates = [
        path.join(PROJECT_ROOT, 'database', 'media-config.js'),
        path.join(PROJECT_ROOT, 'media-config.js'),
        path.join(PROJECT_ROOT, 'frontend', 'media.html'),
        path.join(PROJECT_ROOT, 'media.html')
      ];

      for (const cfgPath of configCandidates) {
        if (fs.existsSync(cfgPath)) {
          const text = fs.readFileSync(cfgPath, 'utf8');
          // Strip comments first so line 16 is matched, not comments!
          const cleanText = text.replace(/\/\*[\s\S]*?\*\/|\/\/.*$/gm, '');
          const vMatch = cleanText.match(/video\s*:\s*["'`](.*?)["'`]/);
          const aMatch = cleanText.match(/audio\s*:\s*["'`](.*?)["'`]/);
          if (vMatch && vMatch[1]) {
            res.writeHead(200);
            res.end(JSON.stringify({
              video: vMatch[1].trim(),
              audio: aMatch && aMatch[1] ? aMatch[1].trim() : ''
            }));
            return;
          }
        }
      }
    } catch (e) { }

    res.writeHead(200);
    res.end(JSON.stringify({ video: '', audio: '' }));
    return;
  }

  // ⚡ 2. STREAMING MEDIA API: Streams local videos (D:/Videos/...) with HTTP 206 partial range support
  let filePath;
  if (reqUrl.pathname === '/api/media') {
    const rawPath = reqUrl.searchParams.get('path');
    if (!rawPath) {
      res.statusCode = 400;
      res.end('Missing path parameter');
      return;
    }
    filePath = resolveWindowsPath(rawPath);
  } else {
    filePath = resolveStaticFilePath(reqUrl.pathname);
  }

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      res.statusCode = 404;
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.end('Not Found: ' + reqUrl.pathname);
      return;
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME[ext] || 'application/octet-stream';
    const totalSize = stats.size;
    const range = req.headers.range;

    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Accept-Ranges', 'bytes');

    if (req.method === 'HEAD') {
      res.writeHead(200, {
        'Content-Length': totalSize,
        'Content-Type': contentType
      });
      res.end();
      return;
    }

    // HTTP 206 Partial Content Stream for Video and Audio Seek
    if (range && (contentType.startsWith('video/') || contentType.startsWith('audio/'))) {
      const match = range.match(/bytes=(\d*)-(\d*)/);
      let start = 0;
      let end = totalSize - 1;
      if (match) {
        if (match[1]) start = parseInt(match[1], 10);
        if (match[2]) end = parseInt(match[2], 10);
        else if (!match[1] && match[2]) {
          start = Math.max(0, totalSize - parseInt(match[2], 10));
          end = totalSize - 1;
        }
      }
      if (isNaN(start) || start < 0) start = 0;
      if (isNaN(end) || end >= totalSize) end = totalSize - 1;
      if (start > end) {
        res.writeHead(416, { 'Content-Range': `bytes */${totalSize}` });
        res.end();
        return;
      }

      const chunkSize = (end - start) + 1;
      res.writeHead(206, {
        'Content-Range': `bytes ${start}-${end}/${totalSize}`,
        'Content-Length': chunkSize,
        'Content-Type': contentType
      });
      fs.createReadStream(filePath, { start, end }).pipe(res);
    } else {
      res.writeHead(200, {
        'Content-Length': totalSize,
        'Content-Type': contentType
      });
      fs.createReadStream(filePath).pipe(res);
    }
  });
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`\n======================================================`);
  console.log(`🚀 TECHNITIX LOCALHOST SERVER RUNNING!`);
  console.log(`======================================================`);
  console.log(`📁 Structured Architecture: frontend/ | backend/ | database/`);
  console.log(`🏛️ Royal Simulator : http://127.0.0.1:${PORT}/finialpro1.html`);
  console.log(`🎬 Media Player    : http://127.0.0.1:${PORT}/media.html`);
  console.log(`🏠 Root URL        : http://127.0.0.1:${PORT}/`);
  console.log(`🛑 Stop Server     : Press Ctrl + C`);
  console.log(`======================================================\n`);
});

module.exports = server;
