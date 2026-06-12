#!/usr/bin/env bash
# Gera os áudios das lições com o TTS neural do Azure (mesma chave do .env).
# Roda uma vez por lição; os MP3 viram assets do app — nada de TTS em runtime.
set -euo pipefail
cd "$(dirname "$0")/.."

set -a
source .env
set +a

voice="en-US-JennyNeural"
outdir="assets/audio/fase1/licao01"
mkdir -p "$outdir"

words=("banana" "cinema" "hotel" "internet" "pizza")

for w in "${words[@]}"; do
  ssml="<speak version='1.0' xml:lang='en-US'><voice name='$voice'><prosody rate='-10%'>$w</prosody></voice></speak>"
  curl -sf -X POST "https://${AZURE_SPEECH_REGION}.tts.speech.microsoft.com/cognitiveservices/v1" \
    -H "Ocp-Apim-Subscription-Key: $AZURE_SPEECH_KEY" \
    -H "Content-Type: application/ssml+xml" \
    -H "X-Microsoft-OutputFormat: audio-16khz-64kbitrate-mono-mp3" \
    -H "User-Agent: method484" \
    --data "$ssml" -o "$outdir/$w.mp3"
  echo "gerado: $outdir/$w.mp3"
done
