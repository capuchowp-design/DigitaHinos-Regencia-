# Regência CCB (PWA)

Partituras dos 480 hinos com a regência animada (batidas, anacruse, fermatas, fecho), modo noturno/claro. Funciona offline depois da primeira visita e pode ser instalado como app.

## Publicar no GitHub Pages
1. Crie um repositório (ex.: `regencia-ccb`) e envie **todos** os arquivos desta pasta para a raiz (`index.html`, `data.js`, `sw.js`, `manifest.webmanifest`, ícones, `.nojekyll`).
2. No GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch**, branch `main`, pasta `/ (root)` → Save.
3. Aguarde ~1 min. O endereço será `https://SEU-USUARIO.github.io/regencia-ccb/`.

## Instalar
- **Android/Chrome:** menu ⋮ → *Instalar app*.
- **Ubuntu/Chrome ou Edge:** ícone de instalar na barra de endereço.
- **iPhone/Safari:** Compartilhar → *Adicionar à Tela de Início*.

## Atualizar
Ao mudar algo, aumente a versão em `sw.js` (`const V='regencia-v1'` → `v2`) para os usuários receberem a atualização.
