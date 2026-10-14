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

# Baixa num arquivo temporário e só move quando veio áudio de verdade: se a
# rede cair ou a chave estiver errada no meio, não sobra MP3 vazio (que a
# próxima rodada pularia como "já existe" e viraria lição muda).
tts() {
  local w="$1" file="$2" tmp="$2.tmp"
  local ssml="<speak version='1.0' xml:lang='en-US'><voice name='$voice'><prosody rate='-10%'>$w</prosody></voice></speak>"
  if curl -sf -X POST "https://${AZURE_SPEECH_REGION}.tts.speech.microsoft.com/cognitiveservices/v1" \
      -H "Ocp-Apim-Subscription-Key: $AZURE_SPEECH_KEY" \
      -H "Content-Type: application/ssml+xml" \
      -H "X-Microsoft-OutputFormat: audio-16khz-64kbitrate-mono-mp3" \
      -H "User-Agent: method484" \
      --data "$ssml" -o "$tmp" && [[ -s "$tmp" ]]; then
    mv "$tmp" "$file"
    echo "gerado: $file"
  else
    rm -f "$tmp"
    echo "ERRO ao gerar: $file — confira AZURE_SPEECH_KEY/AZURE_SPEECH_REGION no .env e a internet, e rode de novo (continua de onde parou)." >&2
    exit 1
  fi
}

gen() {
  local licao="$1"; shift
  local outdir="assets/audio/fase1/$licao"
  mkdir -p "$outdir"
  for w in "$@"; do
    local file="$outdir/${w// /_}.mp3"
    [[ -s "$file" ]] && { echo "já existe: $file"; continue; }
    tts "$w" "$file"
  done
}
gen2() { gen_trail fase2 "$@"; }
gen3() { gen_trail fase3 "$@"; }
gen4() { gen_trail fase4 "$@"; }
gen5() { gen_trail fase5 "$@"; }

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
# Trilha 3 usa a mesma regra (gen3 → assets/audio/fase3/).
gen_trail() {
  local fase="$1"; local licao="$2"; shift 2
  local outdir="assets/audio/$fase/$licao"
  mkdir -p "$outdir"
  for w in "$@"; do
    local stem
    stem="$(printf '%s' "$w" | tr -cd "A-Za-z0-9' " | tr ' ' '_')"
    local file="$outdir/$stem.mp3"
    [[ -s "$file" ]] && { echo "já existe: $file"; continue; }
    tts "$w" "$file"
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

# ---------------------------------------------------------------------------
# Trilha 3 — Frases prontas do dia a dia (lib/data/fase3.dart)
# ---------------------------------------------------------------------------
gen3 licao01 "Sounds good." "Sure thing." "Works for me." "Let's do it." "Count me in."
gen3 licao02 "Thanks a lot." "I really appreciate it." "You're welcome." "No worries." "My pleasure."
gen3 licao03 "Sorry, what was that?" "Could you say that again?" "I didn't catch that." "What do you mean?" "Can you slow down a bit?"
gen3 licao04 "My bad." "Sorry about that." "Sorry I'm late." "Don't worry about it." "It's all good."
gen3 licao05 "No way!" "Good for you!" "That's too bad." "I'm so sorry to hear that." "That's awesome!"
gen3 licao07 "Sounds like a plan to me." "Thanks so much, I owe you one." "Sorry, could you say that one more time?" "No worries at all, it happens." "Wow, that's great news. Congratulations!"
gen3 licao08 "Could you close the door, please?" "Could you send me the file?" "Can you give me a ride?" "Would you mind waiting a second?" "Could I get the check, please?"
gen3 licao09 "Do you want me to help?" "Let me get that for you." "Do you need a hand?" "I can drive you home." "Let me know if you need anything."
gen3 licao10 "Do you mind if I sit here?" "Is it okay if I leave early?" "Can I borrow your pen?" "Mind if I open the window?" "May I ask you something?"
gen3 licao11 "Does Friday work for you?" "How about tomorrow morning?" "What time works for you?" "Let's meet at six." "I'm free after three."
gen3 licao12 "I'd love to, but I can't." "Maybe next time." "Can we do it another day?" "I'm a bit busy right now." "I'll get back to you."
gen3 licao14 "Would you mind sending me the details later?" "Do you want me to pick you up?" "Is it okay if I bring a friend?" "How does next Tuesday afternoon sound to you?" "I'd love to, but can we make it Saturday?"
gen3 licao15 "What do you do?" "Where do you work?" "Where did you grow up?" "How long have you lived here?" "What brings you here?"
gen3 licao16 "How was your weekend?" "Did you do anything fun?" "What are you up to?" "How's your week going?" "What do you do for fun?"
gen3 licao17 "What about you?" "Me too." "Me neither." "Same here." "That makes sense."
gen3 licao18 "Let me think." "Good question." "Hold on a second." "How can I put it?" "It's hard to say."
gen3 licao19 "I should get going." "Talk to you later." "It was nice talking to you." "Let's keep in touch." "Have a good one."
gen3 licao21 "How did you get into that?" "What do you like most about it?" "How long have you been doing that?" "What was the best part of the trip?" "Oh really? What happened next?"
gen3 licao22 "I'm going to call you later." "I want to go home." "I have to work tomorrow." "Do you want to come?" "We're going to be late."
gen3 licao23 "What do you think?" "Did you get my message?" "Do you need anything?" "What did you say?" "Did you have lunch?"
gen3 licao24 "Turn it off." "Pick it up." "Come on in." "Check it out." "Fill it out."
gen3 licao25 "I'm kind of tired." "That's a lot of work." "Can I get a cup of tea?" "Salt and pepper, please." "I'm out of time."
gen3 licao26 "Nice to meet you." "Thanks for coming." "Have a good weekend." "Let me know by Friday." "Sorry, I'm running late."
gen3 licao28 "I'm going to pick it up after work." "What do you want to do tonight?" "Did you get a lot of work done?" "I have to get up at six tomorrow." "It was kind of a long day."
# Revisões da Trilha 3 (06, 13, 20, 27) reusam áudios da própria zona — nada a gerar.

# ---------------------------------------------------------------------------
# Trilha 4 — Estruturas em fala (lib/data/fase4.dart)
# ---------------------------------------------------------------------------
gen4 licao01 "Do you cook?" "Does it hurt?" "Do you have kids?" "Does she live near here?" "Do they speak English?"
gen4 licao02 "Are you okay?" "Is this yours?" "Are you new here?" "Is she your sister?" "Is it always this busy?"
gen4 licao03 "Who's that?" "Where do you live?" "When does it start?" "Which one do you want?" "What time do you get up?"
gen4 licao04 "How much do you need?" "How long does it take?" "How far is your office?" "How often do you work out?" "How many languages do you speak?"
gen4 licao05 "Is that right?" "Which one is better?" "What does this word mean?" "How do you spell that?" "How do you say this in English?"
gen4 licao07 "Do you know where she lives?" "Do you know if he's here today?" "Could you tell me how this works?" "Can you tell me what time it opens?" "Do you mind if I ask what you do?"
gen4 licao08 "I don't drink coffee." "I don't live here." "They don't know each other." "We don't work on Sundays." "You don't need a car here."
gen4 licao09 "It doesn't work." "He doesn't drive." "It doesn't matter." "She doesn't eat meat." "My boss doesn't speak Portuguese."
gen4 licao10 "I'm not sure." "It isn't far." "They aren't ready." "I'm not from around here." "There isn't any milk left."
gen4 licao11 "I can't hear you." "It won't take long." "You don't have to pay." "I can't make it tonight." "You shouldn't walk alone at night."
gen4 licao12 "Not really." "I'm not done yet." "I never eat breakfast." "There's nothing to worry about." "Nobody uses cash anymore."
gen4 licao14 "That's not exactly what I mean." "I don't think that's a good idea." "I can't stay long, I work early tomorrow." "I see your point, but I don't agree." "I'd rather not talk about it right now."
gen4 licao15 "I went home early." "I found my keys." "She told me everything." "We made it on time." "They left without me."
gen4 licao16 "Where were you?" "It was amazing." "How was the trip?" "We were at home." "The traffic was terrible."
gen4 licao17 "Did you see it?" "Did you sleep well?" "How did it go?" "When did you get here?" "Where did you buy it?"
gen4 licao18 "I didn't know." "It wasn't my fault." "They weren't home." "We didn't have time." "I didn't sleep at all."
gen4 licao19 "It happened last night." "I saw her yesterday." "After that, we got lost." "First we ate, then we left." "I called you two days ago."
gen4 licao21 "What did you do after the meeting?" "I didn't see your message until this morning." "I missed the bus, so I took a taxi." "When I got home, I found the door open." "We got there late, but it was worth it."
gen4 licao22 "I'm driving." "What are you doing?" "It's raining again." "I'm working on it." "Are you still waiting outside?"
gen4 licao23 "I'm leaving tomorrow." "We're flying on Monday." "I'm meeting a client at five." "Are you coming on Friday?" "We're going to move next year."
gen4 licao24 "I'll do it." "I'll call you back." "I'll send it tonight." "Don't worry, I'll be there." "I think I'll stay home today."
gen4 licao25 "I've been there." "I've never tried it." "Have you ever seen snow?" "I've been to New York twice." "Have you ever been to Canada?"
gen4 licao26 "I just got here." "I've already done it." "I've known her for years." "How long have you been waiting?" "I've lived here since last year."
gen4 licao28 "Have you seen it yet? You'll love it." "I've never been there, but I'd love to go." "I'm still at work, so I'll text you later." "We got here on Monday and we're leaving tomorrow." "I've already made plans, so I'll pass this time."
# Revisões da Trilha 4 (06, 13, 20, 27) reusam áudios da própria zona — nada a gerar.

# ---------------------------------------------------------------------------
# Trilha 5 — Inglês para sobrevivência (lib/data/fase5.dart)
# ---------------------------------------------------------------------------
gen5 licao01 "Table for two, please." "We have a reservation." "Is there a table by the window?" "Can we sit outside?" "How long is the wait?"
gen5 licao02 "What do you recommend?" "What comes with that?" "Could I see the menu?" "I'll have the chicken, please." "I need a few more minutes."
gen5 licao03 "No onions, please." "Is it spicy?" "Does this have dairy?" "I'm allergic to peanuts." "Can I get it without cheese?"
gen5 licao04 "I didn't order this." "This is a little cold." "Could we get some napkins?" "Could I get a clean fork?" "We're still waiting on our food."
gen5 licao05 "Keep the change." "Separate checks, please." "Is the tip included?" "Can we split the check?" "Do you take credit cards?"
gen5 licao07 "Can I get a large iced coffee to go?" "Could I get a medium latte with oat milk?" "Can I have the dressing on the side?" "Could you put the rest in a box?" "Excuse me, is there a restroom I can use?"
gen5 licao08 "Window seat, please." "Just one bag." "Is the flight on time?" "Is this bag too heavy?" "Can I get an aisle seat?"
gen5 licao09 "Here's my passport." "I'm here on vacation." "I have nothing to declare." "I'll be here for two weeks." "Should I take my shoes off?"
gen5 licao10 "Where's gate twelve?" "Is my flight delayed?" "When does boarding start?" "I have a connecting flight." "Am I going to miss my connection?"
gen5 licao11 "My bag didn't arrive." "My suitcase is damaged." "It's a big black suitcase." "Where do I report lost luggage?" "Can you send it to my hotel?"
gen5 licao12 "To this address, please." "How much to the airport?" "Where can I buy a ticket?" "Does this bus go downtown?" "Which stop should I get off at?"
gen5 licao14 "Is there any way we could sit together?" "I'm here on business for about a week." "My flight was canceled. What are my options?" "Could you let me know when we get there?" "Can you call me when you find my bag?"
gen5 licao15 "I'm checking in." "It's under Silva." "Is breakfast included?" "What time is checkout?" "Can I check in early?"
gen5 licao16 "There's no hot water." "The room is too noisy." "Could I get more towels?" "The air conditioner isn't working." "Could I move to another room?"
gen5 licao17 "Excuse me, I'm lost." "Can I walk there?" "Is it on the left?" "How do I get to the museum?" "Can you show me on the map?"
gen5 licao18 "I'm just looking, thanks." "Can I try this on?" "Where are the fitting rooms?" "It's a little too big." "Do you have this in a medium?"
gen5 licao19 "How much is this jacket?" "Is this one on sale too?" "Can I pay with cash?" "I'd like to return this, please." "Could I get a gift receipt, please?"
gen5 licao21 "Can I leave my bags here until three?" "Could someone come up and take a look?" "How long does it take to walk there?" "Do you have the same one in black?" "I'd like to exchange this for a smaller size."
gen5 licao22 "Is there a pharmacy nearby?" "I need something for a headache." "Do I need a prescription?" "How often should I take it?" "Do you have cough syrup?"
gen5 licao23 "I have a fever." "My stomach hurts." "I feel dizzy." "It hurts right here." "I've been sick since yesterday."
gen5 licao24 "Is it serious?" "I need to see a doctor." "I have travel insurance." "Can I see someone today?" "Could you write that down, please?"
gen5 licao25 "Call an ambulance!" "It's an emergency." "Please call nine one one!" "Where's the nearest hospital?" "Does anyone here speak Portuguese?"
gen5 licao26 "I lost my wallet." "Someone stole my phone." "My passport was stolen." "I need to report a theft." "I need a police report for insurance."
gen5 licao28 "I've had a bad headache since this morning." "Can you recommend something for a sore throat?" "I'm allergic to penicillin. Is this medicine okay?" "My friend passed out and won't wake up." "Can you tell me where the police station is?"
# Revisões da Trilha 5 (06, 13, 20, 27) reusam áudios da própria zona — nada a gerar.
