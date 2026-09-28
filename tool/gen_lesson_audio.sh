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

# Fase 2 ("Verbo To Be — Forma e Som", ver docs/curriculo-fase2.md): itens
# são frases (às vezes com apóstrofo/pontuação), não palavras soltas — nomear
# o arquivo pelo texto como `gen()` faz colidiria/ficaria ilegível, então
# aqui o arquivo é só a posição do item na lição (01.mp3..10.mp3), igual ao
# `audioAsset` de cada LessonItem em lib/data/fase2.dart.
gen_fase2() {
  local licao="$1"; shift
  local outdir="assets/audio/fase2/$licao"
  mkdir -p "$outdir"
  local i=0
  for s in "$@"; do
    i=$((i + 1))
    local file
    file=$(printf '%s/%02d.mp3' "$outdir" "$i")
    [[ -f "$file" ]] && { echo "já existe: $file"; continue; }
    local ssml="<speak version='1.0' xml:lang='en-US'><voice name='$voice'><prosody rate='-10%'>$s</prosody></voice></speak>"
    curl -sf -X POST "https://${AZURE_SPEECH_REGION}.tts.speech.microsoft.com/cognitiveservices/v1" \
      -H "Ocp-Apim-Subscription-Key: $AZURE_SPEECH_KEY" \
      -H "Content-Type: application/ssml+xml" \
      -H "X-Microsoft-OutputFormat: audio-16khz-64kbitrate-mono-mp3" \
      -H "User-Agent: method484" \
      --data "$ssml" -o "$file"
    echo "gerado: $file"
  done
}

gen_fase2 licao01 "I am happy." "I am calm." "I am tired." "You are confident." "You are busy." "He is friendly." "She is nervous." "It is important." "We are ready." "They are excited."
gen_fase2 licao02 "I am not sad." "I am not nervous." "I am not energetic." "You are not insecure." "You are not free." "He is not unfriendly." "She is not calm." "It is not irrelevant." "We are not unprepared." "They are not bored."
gen_fase2 licao04 "I'm." "You're." "He's." "She's." "It's." "We're." "They're." "I'm not." "You aren't." "He isn't."
gen_fase2 licao05 "She isn't." "It isn't." "We aren't." "They aren't." "I'm not." "You aren't." "He isn't." "She isn't." "We aren't." "They aren't."
gen_fase2 licao06 "I'm happy." "I'm calm." "I'm tired." "You're confident." "You're busy." "He's friendly." "She's nervous." "It's important." "We're ready." "They're excited."
gen_fase2 licao07 "I'm not sad." "I'm not nervous." "I'm not energetic." "You aren't insecure." "You aren't free." "He isn't unfriendly." "She isn't calm." "It isn't irrelevant." "We aren't unprepared." "They aren't bored."
# licao03 e licao08 (blocos de contraste) não geram áudio próprio: o item
# afirmativo de cada um (o `text`, que é o ReferenceText avaliado) é
# IDÊNTICO ao de licao01/06 — `audioAsset` em lib/data/fase2.dart já aponta
# pros arquivos de licao01/06 (mesmo padrão das lições de revisão da Fase
# 1). O contraste (a negativa) aparece só como texto no Livro Aberto
# (`example`), nunca precisou de áudio.
