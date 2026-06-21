#!/usr/bin/env python3
"""Gera os ícones do 484 Method a partir das cores do logo.

Logo: fundo creme (#F5F2EB), texto navy (#1B2D4F), detalhe dourado (#C9A252).
Para ícones quadrados, usa "484" centralizado — mais legível que o wordmark
horizontal em tamanhos pequenos.
"""

from PIL import Image, ImageDraw, ImageFont
import os, sys

CREAM  = (245, 242, 235)   # #F5F2EB
NAVY   = (27,  45,  79)    # #1B2D4F
GOLD   = (201, 162, 82)    # #C9A252

OUT = os.path.join(os.path.dirname(__file__), '..', 'web')

def find_serif_font(size):
    candidates = [
        '/System/Library/Fonts/Supplemental/Georgia.ttf',
        '/Library/Fonts/Georgia.ttf',
        '/System/Library/Fonts/Times New Roman.ttf',
        '/Library/Fonts/Times New Roman.ttf',
        '/System/Library/Fonts/Supplemental/TimesNewRoman.ttf',
        '/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf',
    ]
    for p in candidates:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()

def make_icon(px):
    img = Image.new('RGBA', (px, px), CREAM + (255,))
    d   = ImageDraw.Draw(img)

    # Linhas douradas horizontais
    lw  = max(1, px // 128)         # espessura proporcional
    gap = px * 0.28                 # distância do centro para as linhas
    cx  = px // 2
    cy  = px // 2
    lx1 = px * 0.12
    lx2 = px * 0.88
    d.line([(lx1, cy - gap), (lx2, cy - gap)], fill=GOLD, width=lw)
    d.line([(lx1, cy + gap), (lx2, cy + gap)], fill=GOLD, width=lw)

    # Diamante dourado centralizado entre as linhas
    dm = max(3, px // 64)
    d.polygon([
        (cx,          cy - gap - dm*1.8),
        (cx + dm*1.2, cy - gap),
        (cx,          cy - gap + dm*1.8),
        (cx - dm*1.2, cy - gap),
    ], fill=GOLD)
    d.polygon([
        (cx,          cy + gap - dm*1.8),
        (cx + dm*1.2, cy + gap),
        (cx,          cy + gap + dm*1.8),
        (cx - dm*1.2, cy + gap),
    ], fill=GOLD)

    # Texto "484"
    fsize = int(px * 0.38)
    font  = find_serif_font(fsize)
    bbox  = d.textbbox((0, 0), '484', font=font)
    tw    = bbox[2] - bbox[0]
    th    = bbox[3] - bbox[1]
    d.text((cx - tw // 2, cy - th // 2 - bbox[1]), '484',
           font=font, fill=NAVY)

    return img

def save(img, path, size=None):
    if size:
        img = img.resize((size, size), Image.LANCZOS)
    img.save(path)
    print(f'  ✓ {path} ({img.size[0]}×{img.size[1]})')

if __name__ == '__main__':
    base = make_icon(1024)

    save(base, os.path.join(OUT, 'favicon.png'), 32)
    save(base, os.path.join(OUT, 'icons', 'Icon-192.png'), 192)
    save(base, os.path.join(OUT, 'icons', 'Icon-512.png'), 512)
    save(base, os.path.join(OUT, 'icons', 'Icon-maskable-192.png'), 192)
    save(base, os.path.join(OUT, 'icons', 'Icon-maskable-512.png'), 512)
    # Fonte de alta resolução para uso futuro (flutter_launcher_icons)
    src = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')
    os.makedirs(src, exist_ok=True)
    save(base, os.path.join(src, 'icon.png'))
    print('Ícones gerados.')
