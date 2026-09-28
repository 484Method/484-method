#!/usr/bin/env python3
"""Resume um export de usuários do painel do dev (analytics/raw/*.csv) em
métricas agregadas SEM PII, prontas pra reaproveitar num pitch — nunca
imprime nome/e-mail individual. Uso: python3 analisar.py raw/ARQUIVO.csv
"""
import csv
import sys
from collections import Counter
from pathlib import Path


def load(path):
    with open(path, newline="", encoding="utf-8") as f:
        return [row for row in csv.DictReader(f) if row.get("user_id")]


def analisar(rows):
    total = len(rows)
    emails = Counter(r["email"].strip().lower() for r in rows if r["email"].strip())
    pessoas_unicas = len(emails)
    contas_duplicadas = sum(c - 1 for c in emails.values() if c > 1)
    anonimos = sum(1 for r in rows if not r["email"].strip())

    def li(r):
        return int(r["lessons_completed"] or 0)

    def seg(r):
        return int(r["approved_seconds"] or 0)

    def streak(r):
        return int(r["streak_days"] or 0)

    zero = sum(1 for r in rows if li(r) == 0 and seg(r) == 0)
    parcial_sem_licao = sum(1 for r in rows if li(r) == 0 and seg(r) > 0)
    com_licao = sum(1 for r in rows if li(r) >= 1)
    total_seg = sum(seg(r) for r in rows)
    max_licoes = max((li(r) for r in rows), default=0)
    retornou_2d = sum(1 for r in rows if streak(r) >= 2)

    return {
        "total_linhas": total,
        "pessoas_com_contato_unicas": pessoas_unicas,
        "contas_duplicadas_mesmo_email": contas_duplicadas,
        "linhas_anonimas_sem_cadastro": anonimos,
        "zero_atividade": zero,
        "tentou_mas_nao_concluiu_licao": parcial_sem_licao,
        "concluiu_1_ou_mais_licoes": com_licao,
        "total_minutos_aprovados": round(total_seg / 60, 1),
        "max_licoes_concluidas_por_1_pessoa": max_licoes,
        "linhas_com_streak_2_mais": retornou_2d,
    }


def main():
    if len(sys.argv) != 2:
        print("uso: python3 analisar.py raw/ARQUIVO.csv", file=sys.stderr)
        sys.exit(1)
    path = Path(sys.argv[1])
    rows = load(path)
    m = analisar(rows)
    stamp = path.stem
    out = Path(__file__).parent / f"resumo-{stamp}.md"
    with open(out, "w", encoding="utf-8") as f:
        f.write(f"# Resumo de uso — {stamp}\n\n")
        f.write("Agregado sem PII — gerado por `analisar.py` a partir do export do painel do dev.\n\n")
        for k, v in m.items():
            f.write(f"- **{k.replace('_', ' ')}**: {v}\n")
    print(f"Escrito em {out}")
    for k, v in m.items():
        print(f"{k}: {v}")


if __name__ == "__main__":
    main()
