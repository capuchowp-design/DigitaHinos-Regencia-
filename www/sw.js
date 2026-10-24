const V='regencia-v7',F=['./','./index.html','./data.js','./ajustes-compassos.js','./manifest.webmanifest','./icon-192.png','./icon-512.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(V).then(c=>c.addAll(F)).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==V).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',e=>{if(e.request.method!=='GET')return;const u=new URL(e.request.url);
 const req=(u.origin!==location.origin&&e.request.mode==='no-cors')?new Request(e.request.url,{mode:'cors',credentials:'omit'}):e.request;
 e.respondWith(caches.match(req,{ignoreSearch:true}).then(r=>r||fetch(req).then(n=>{if(n.ok){const c=n.clone();caches.open(V).then(x=>x.put(req,c))}return n}).catch(()=>e.request.mode==='navigate'?caches.match('./index.html'):Response.error())))});
