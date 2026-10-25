#!/bin/bash
cd "$(git rev-parse --show-toplevel)" || exit 1
NOME="DigitaHinos Regência"
echo "▶ 1/5 Renomeando para $NOME…"
sed -i 's/"appName": *"[^"]*"/"appName": "'"$NOME"'"/' capacitor.config.json
sed -i 's/"name":"[^"]*"/"name":"'"$NOME"'"/; s/"short_name":"[^"]*"/"short_name":"DigitaHinos"/' www/manifest.webmanifest
sed -i 's#<title>[^<]*</title>#<title>'"$NOME"'</title>#; s#♪ Regência · CCB#'"$NOME"'#' www/index.html
sed -i "s/regencia-v[0-9A-Za-z]*/regencia-$(date +%Y%m%d%H%M%S)/" www/sw.js

echo "▶ 2/5 Criando a chave de assinatura (uma única vez)…"
command -v keytool >/dev/null || { sudo apt-get update -qq && sudo apt-get install -y -qq default-jre-headless; }
D="$HOME/chave-apk"; mkdir -p "$D"
if [ ! -f "$D/digitahinos.jks" ]; then
  SENHA=$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9' | head -c 20)
  keytool -genkeypair -keystore "$D/digitahinos.jks" -alias digitahinos -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$SENHA" -keypass "$SENHA" -dname "CN=DigitaHinos Regencia, OU=App, O=DigitaHinos, C=BR" || exit 1
  echo "$SENHA" > "$D/senha.txt"; chmod 600 "$D/senha.txt" "$D/digitahinos.jks"
else
  SENHA=$(cat "$D/senha.txt"); echo "  (chave já existia, reaproveitando)"
fi
B64=$(base64 -w0 "$D/digitahinos.jks")

echo "▶ 3/5 Cadastrando os segredos no GitHub…"
if ! gh secret set ANDROID_KEY_ALIAS --body "digitahinos" >/dev/null 2>&1; then
  echo "  O Codespaces não tem permissão para segredos. Vou pedir autorização (abra o link e digite o código):"
  unset GITHUB_TOKEN
  gh auth login -h github.com -p https -w -s repo -s workflow --skip-ssh-key || exit 1
  gh secret set ANDROID_KEY_ALIAS --body "digitahinos" || exit 1
fi
gh secret set ANDROID_KEYSTORE_BASE64 --body "$B64" && \
gh secret set ANDROID_KEYSTORE_PASSWORD --body "$SENHA" && \
gh secret set ANDROID_KEY_PASSWORD --body "$SENHA" || exit 1

echo "▶ 4/5 Enviando as alterações…"
git add -A && git commit -qm "Renomeia o app para $NOME" ; git push || echo "  (aviso: git push falhou; envie manualmente)"

echo "▶ 5/5 Iniciando a geração do APK…"
gh workflow run android.yml && echo "  Workflow iniciado." || echo "  Não consegui iniciar sozinho: vá em Actions → Gerar APK (Android) → Run workflow."
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)
echo; echo "✅ Pronto! Acompanhe em: https://github.com/$REPO/actions (o APK sai em 'Artifacts' ao terminar)."
echo; echo "⚠️  GUARDE UM BACKUP da chave (sem ela você não consegue atualizar o app depois):"
echo "   Arquivo: $D/digitahinos.jks   Senha: $SENHA   Alias: digitahinos"
