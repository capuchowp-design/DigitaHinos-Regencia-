# Regência CCB — PWA + APK

Partituras dos 480 hinos com regência animada, mão esquerda, dinâmicas e som. Funciona como site (GitHub Pages), como PWA instalável e como APK Android (Capacitor).

## Estrutura
- `www/` — o app (index.html, data.js, sw.js, manifest, ícones). É a única pasta que o app usa.
- `assets/` — ícone e splash (usados para gerar os ícones do Android).
- `capacitor.config.json` e `package.json` — configuração do Capacitor.
- `.github/workflows/pages.yml` — publica `www/` no GitHub Pages.
- `.github/workflows/android.yml` — gera o APK.

## 1) Subir para o GitHub
Crie o repositório e envie **tudo** desta pasta, incluindo `.github` e `.gitignore` (pastas que começam com ponto às vezes ficam escondidas).

## 2) Publicar o site/PWA
Settings → Pages → **Build and deployment → Source: GitHub Actions**. A cada push na `main` o site é publicado (aba Actions → "Publicar PWA").

## 3) Gerar o APK
Aba **Actions → Gerar APK (Android) → Run workflow**. Ao terminar, baixe o arquivo em **Artifacts**:
- `regencia-ccb-debug-apk` — APK de teste, instala direto no celular (permita "fontes desconhecidas").
- `regencia-ccb-release-apk` — APK assinado (só aparece se você configurar os segredos abaixo).

Criando uma tag, por exemplo `v1.0.0`, o APK também é anexado em **Releases**.

### APK assinado (necessário para lojas como APKPure/Play)
1. Gere uma chave (guarde o arquivo e as senhas; use sempre a mesma nas atualizações):
   `keytool -genkeypair -v -keystore regencia.jks -alias regencia -keyalg RSA -keysize 2048 -validity 10000`
2. Converta para base64: `base64 -w0 regencia.jks`
3. Em Settings → Secrets and variables → Actions, crie:
   `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_PASSWORD`.
4. Rode o workflow de novo.

## Rodar/gerar localmente (opcional)
Requer Node 20, JDK 21 e Android Studio.
```
npm install
npx cap add android
npm run android:assets
npx cap sync android
npx cap open android
```

## Observações
- O `appId` está em `capacitor.config.json` (`br.com.regenciaccb.app`); troque antes de publicar em loja.
- O som de instrumentos reais é baixado da internet na primeira vez (WebAudioFont/FluidR3) e fica em cache. Sem internet, usa o sintetizador interno.
- `www/ajustes-compassos.js` permite corrigir manualmente o agrupamento de compassos de algum hino.
- Ao alterar arquivos em `www/`, aumente a versão do cache em `www/sw.js` (`regencia-v7` → `v8`).
- A pasta `android/` é criada pelo workflow; se você personalizá-la e commitá-la, o workflow passa a usá-la.
