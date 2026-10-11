#!/usr/bin/env bash
# Gera os áudios das lições com o TTS neural do Azure (mesma chave do .env).
# Roda uma vez por lição; os MP3 viram assets do app — nada de TTS em runtime.
set -euo pipefail
cd "$(dirname "$0")/.."

# Chave do Azure: do .env (máquina do dev) ou do ambiente (CI).
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi
: "${AZURE_SPEECH_KEY:?defina AZURE_SPEECH_KEY no .env (ver .env.example)}"
: "${AZURE_SPEECH_REGION:?defina AZURE_SPEECH_REGION no .env (ver .env.example)}"

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

# ---------------------------------------------------------------------------
# Trilha 2 — Sons do inglês real (lib/data/fase2.dart)
# ---------------------------------------------------------------------------
# Diferente da Trilha 1: o texto vai pro TTS COM a pontuação (a pergunta
# precisa soar como pergunta — a lição 26 treina justamente a melodia), e o
# nome do arquivo fica só com letras, dígitos, apóstrofo e "_"
# ("Are you ready?" -> Are_you_ready.mp3). Essa regra precisa bater com o
# `audioAsset` de cada item; o teste de integridade
# (test/curriculum_test.dart) acusa qualquer arquivo faltando.
gen2() {
  local licao="$1"; shift
  local outdir="assets/audio/fase2/$licao"
  mkdir -p "$outdir"
  for w in "$@"; do
    local stem
    stem="$(printf '%s' "$w" | tr -cd "A-Za-z0-9' " | tr ' ' '_')"
    local file="$outdir/$stem.mp3"
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

gen2 licao01 "big" "book" "keep" "club" "Good luck."
gen2 licao02 "stay" "space" "snack" "skip" "Please speak slowly."
gen2 licao03 "feel" "tell" "file" "people" "I'll call you."
gen2 licao04 "time" "phone" "young" "going" "I'm leaving soon."
gen2 licao05 "watched" "played" "moved" "ended" "I cooked and cleaned."
gen2 licao07 "desk" "next" "changed" "world" "I helped a friend."
gen2 licao08 "ship" "sheep" "sit" "seat" "Is it cheap to ship?"
gen2 licao09 "full" "fool" "pull" "pool" "I cook good food."
gen2 licao10 "bad" "bed" "sad" "said" "I left my bag."
gen2 licao11 "cup" "cop" "luck" "lock" "I got lucky."
gen2 licao12 "work" "walk" "shirt" "short" "I walk to work."
gen2 licao14 "Please sit back in your seat." "His pool is full." "She said she was sad." "One cup is not much." "My shirt was too short."
gen2 licao15 "red" "right" "really" "run" "It's raining right now."
gen2 licao16 "car" "more" "very" "corner" "Where is my car?"
gen2 licao17 "team" "different" "idea" "city" "It's a different city."
gen2 licao18 "think" "thanks" "nothing" "both" "I think it's nothing."
gen2 licao19 "they" "this" "other" "together" "This is the other one."
gen2 licao21 "three" "north" "rather" "birthday" "My brother's birthday is on the third."
gen2 licao22 "about" "today" "seven" "breakfast" "Breakfast is at seven."
gen2 licao23 "I need a break." "I work from home." "Let's grab some lunch." "Pick me up at six." "Call me when you land."
gen2 licao24 "a cup of coffee" "black and white" "I need to go." "It's for you." "I'm at work."
gen2 licao25 "I can come." "I can't come." "I can wait." "I can't do it." "We can go now."
gen2 licao26 "Are you hungry?" "Is it far from here?" "Where are you from?" "What time is it?" "Do you like it?"
gen2 licao28 "I think I'll stay home tonight." "I worked from home all week." "I can't make it to the meeting." "What time does the store open?" "Is there a good place to eat here?"
# Revisões da Trilha 2 (06, 13, 20, 27) reusam áudios da própria zona — nada a gerar.

