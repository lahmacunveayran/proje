"""SWF'deki bir kuklaya bağlı bütün şekillerin renklerini sayar.

Kullanım (bkz. docs/SANAT.md, "Referanslar"):
    python3 araclar/olcum/char_palette.py araclar/olcum <oyun.swf> Human,Human_Player cikti.json
"""
import json
import struct
import sys
from collections import Counter, defaultdict

sys.path.insert(0, sys.argv[1])
from swfstats import load, tags, parse_shape, SHAPE_TAGS  # noqa: E402

ver, r, data, pos = load(sys.argv[2])
exports = {}
children = defaultdict(set)
shapes = {}
for code, body in tags(data, pos):
    if code == 56:
        n = struct.unpack_from('<H', body, 0)[0]
        p = 2
        for _ in range(n):
            cid = struct.unpack_from('<H', body, p)[0]
            p += 2
            e = body.index(b'\0', p)
            exports[body[p:e].decode('latin1')] = cid
            p = e + 1
    elif code == 39:
        sid = struct.unpack_from('<H', body, 0)[0]
        for c2, b2 in tags(body, 4):
            if c2 in (26, 70):
                fl = b2[0]
                off = 1 if c2 == 26 else 2
                if fl & 2:
                    cid = struct.unpack_from('<H', b2, off + 2)[0]
                    children[sid].add(cid)
            elif c2 == 4:
                children[sid].add(struct.unpack_from('<H', b2, 0)[0])
    elif code in SHAPE_TAGS:
        try:
            s = parse_shape(body, SHAPE_TAGS[code])
            shapes[s[0]] = s
        except Exception:
            pass

roots = [exports[n] for n in sys.argv[3].split(',') if n in exports]
seen = set()
stack = list(roots)
while stack:
    c = stack.pop()
    if c in seen:
        continue
    seen.add(c)
    stack.extend(children.get(c, ()))
char_shapes = [shapes[c] for c in seen if c in shapes]
print('kök:', roots, 'erişilen:', len(seen), 'şekil:', len(char_shapes))

solid = Counter()
grads = Counter()
for sid, bounds, fills, lines, edges, used in char_shapes:
    for fdef in fills:
        w = used.get(id(fdef), 0) or 1
        if fdef['type'] == 'solid':
            solid['#%02X%02X%02X' % tuple(fdef['color'][:3])] += w
        elif fdef['type'] in ('linear', 'radial', 'focal'):
            st = fdef['stops']
            key = (fdef['type'][0],) + tuple('#%02X%02X%02X' % tuple(c[:3]) for _, c in st)
            grads[key] += w
    for e in edges:
        pass
tot_s = sum(solid.values())
tot_g = sum(grads.values())
out = {
    'duz': [(c, round(v / tot_s, 4)) for c, v in solid.most_common(60)],
    'degrade': [(list(k), round(v / tot_g, 4)) for k, v in grads.most_common(60)],
    'cizgili_kenar_orani': None,
}
lined = sum(L for s in char_shapes for (ln, cv, L, w, col) in s[4] if ln)
total = sum(L for s in char_shapes for (ln, cv, L, w, col) in s[4])
out['cizgili_kenar_orani'] = round(lined / max(total, 1), 4)
n_solid = sum(1 for s in char_shapes for fd in s[2] if fd['type'] == 'solid')
n_grad = sum(1 for s in char_shapes for fd in s[2] if fd['type'] in ('linear', 'radial', 'focal'))
out['dolgu_sayilari'] = {'duz': n_solid, 'degrade': n_grad}
json.dump(out, open(sys.argv[4], 'w'), ensure_ascii=False, indent=1)
print('çizgili kenar oranı:', out['cizgili_kenar_orani'], 'dolgular:', out['dolgu_sayilari'])
print('düz:', ' '.join(f'{c}({v*100:.1f})' for c, v in out['duz'][:40]))
print('degrade:')
for k, v in out['degrade'][:40]:
    print('  ', k, f'{v*100:.1f}')
