#!/usr/bin/env bash
# Gera os áudios das lições com o TTS neural do Azure (mesma chave do .env).
# Roda uma vez por lição; os MP3 viram assets do app — nada de TTS em runtime.
set -euo pipefail
cd "$(dirname "$0")/.."

set -a
source .env
set +a

voice="en-US-JennyNeural"

gen() {
  local licao="$1"; shift
  local outdir="assets/audio/fase1/$licao"
  mkdir -p "$outdir"
  for w in "$@"; do
    local file="$outdir/${w// /_}.mp3"
    [[ -f "$file" ]] && { echo "já existe: $file"; continue; }
    local ssml="<speak version='1.0' xml:lang='en-US'><voice name='$voice'><prosody rate='-10%'>$w</prosody></voice></speak>"
    curl -sf -X POST "https://${AZURE_SPEECH_REGION}.tts.speech.microsoft.com/cognitiveservices/v1" \
      -H "Ocp-Apim-Subscription-Key: $AZURE_SPEECH_KEY" \
      -H "Content-Type: application/ssml+xml" \
      -H "X-Microsoft-OutputFormat: audio-16khz-64kbitrate-mono-mp3" \
      -H "User-Agent: method484" \
      --data "$ssml" -o "$file"
    echo "gerado: $file"
  done
}

gen licao01 "apple" "cinema" "hotel" "internet" "pizza"
gen licao02 "app" "online" "email" "login" "video"
gen licao03 "coffee" "burger" "sandwich" "cake" "water"
gen licao04 "airport" "taxi" "bus" "passport" "ticket"
gen licao05 "meeting" "manager" "project" "office" "job"
gen licao06 "hospital" "chocolate" "camera" "restaurant" "comfortable"
gen licao07 "I like it" "I need it" "I want this" "I love it" "I got it"
gen licao08 "Thank you" "See you" "Excuse me" "It's okay" "No problem"
gen licao09 "Can I have a coffee" "I need help" "One coffee, please" "Can you help me" "Just a minute"
gen muito_facil_2 "banana" "menu" "gym" "mall" "fashion"
gen som_enganoso "business" "interesting" "mouse" "delivery" "feedback"
gen uso_diferente "outdoor" "notebook" "shopping" "home office" "chips"
gen casa_lazer "closet" "freezer" "playground" "babysitter" "happy hour"
gen compras_dinheiro "cash" "credit card" "discount" "voucher" "cashback"
gen bonus_vocabulario "calendar" "celebrity" "vegetable" "elevator" "umbrella"
gen bonus_ritmo "necessary" "temperature" "government" "photography" "vocabulary"
gen bonus_pedidos "Could you help me, please" "I'd like to order a coffee" "Do you have a discount" "Where is the restroom" "Can I get a receipt"
gen bloco4_saudacoes "How are you" "How are you doing" "How's it going" "How have you been" "How's your day going"
gen bloco4_respostas "I'm good, thanks" "I'm doing well" "I'm great, thank you" "Pretty good, actually" "I'm feeling good today"
gen bloco4_clima "It's sunny today" "It's a bit cloudy today" "It's really hot today" "It's a little cold today" "The weather is nice today"
gen bloco4_dia_bonito "It's a beautiful day to go outside" "It's a beautiful day to have a walk" "It's a beautiful day to study English" "It's a beautiful day to drink some coffee" "It's a beautiful day to enjoy the morning"
gen bloco4_planos "What's the plan for today" "What's the plan for this morning" "What's the plan for the afternoon" "What's the plan after class" "What's the plan for the weekend"
gen bloco4_bonus "How have you been doing lately" "I've been pretty busy, but I'm good" "It looks like it might rain later" "It's the perfect day to relax outside" "Do you have any plans for the weekend"
# Lições de revisão (06, 12, 19, 26) reusam áudios das lições anteriores — nada a gerar.
