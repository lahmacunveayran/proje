"""SWF şekil (DefineShape) çözümleyici: dolgu, çizgi, degrade ve kenar istatistikleri.

Kullanım: python3 araclar/olcum/swfstats.py <oyun.swf> <çıktı.json>
"""
import sys, zlib, struct, json, math, colorsys
from collections import Counter, defaultdict


class Bits:
    def __init__(self, data, pos=0):
        self.d = data
        self.pos = pos
        self.bit = 0

    def align(self):
        if self.bit:
            self.bit = 0
            self.pos += 1

    def ub(self, n):
        v = 0
        for _ in range(n):
            b = (self.d[self.pos] >> (7 - self.bit)) & 1
            v = (v << 1) | b
            self.bit += 1
            if self.bit == 8:
                self.bit = 0
                self.pos += 1
        return v

    def sb(self, n):
        if n == 0:
            return 0
        v = self.ub(n)
        if v & (1 << (n - 1)):
            v -= 1 << n
        return v

    def fb(self, n):
        return self.sb(n) / 65536.0

    def u8(self):
        self.align()
        v = self.d[self.pos]
        self.pos += 1
        return v

    def u16(self):
        self.align()
        v = struct.unpack_from('<H', self.d, self.pos)[0]
        self.pos += 2
        return v

    def s16(self):
        self.align()
        v = struct.unpack_from('<h', self.d, self.pos)[0]
        self.pos += 2
        return v


def rect(b):
    b.align()
    n = b.ub(5)
    r = [b.sb(n) for _ in range(4)]
    b.align()
    return r


def matrix(b):
    b.align()
    sx = sy = 1.0
    r0 = r1 = 0.0
    if b.ub(1):
        n = b.ub(5)
        sx = b.fb(n)
        sy = b.fb(n)
    if b.ub(1):
        n = b.ub(5)
        r0 = b.fb(n)
        r1 = b.fb(n)
    n = b.ub(5)
    tx = b.sb(n)
    ty = b.sb(n)
    b.align()
    return (sx, r0, r1, sy, tx, ty)


def color(b, alpha):
    r, g, bb = b.u8(), b.u8(), b.u8()
    a = b.u8() if alpha else 255
    return (r, g, bb, a)


def fillstyle(b, ver):
    t = b.u8()
    alpha = ver >= 3
    if t == 0x00:
        return {'type': 'solid', 'color': color(b, alpha)}
    if t in (0x10, 0x12, 0x13):
        m = matrix(b)
        b.align()
        spread = b.ub(2)
        interp = b.ub(2)
        n = b.ub(4)
        stops = []
        for _ in range(n):
            ratio = b.u8()
            stops.append((ratio, color(b, alpha)))
        if t == 0x13:
            b.s16()
        return {'type': {0x10: 'linear', 0x12: 'radial', 0x13: 'focal'}[t], 'matrix': m, 'stops': stops,
                'spread': spread, 'interp': interp}
    if 0x40 <= t <= 0x43:
        bid = b.u16()
        m = matrix(b)
        # 0x40 tekrarlı, 0x41 kırpılmış, 0x42/0x43 aynıları yumuşatmasız
        return {'type': 'bitmap', 'id': bid, 'matrix': m, 'clip': bool(t & 1), 'smooth': t < 0x42}
    raise ValueError('fill type %x' % t)


def fillarray(b, ver):
    n = b.u8()
    if n == 0xFF and ver >= 2:
        n = b.u16()
    return [fillstyle(b, ver) for _ in range(n)]


def linearray(b, ver):
    n = b.u8()
    if n == 0xFF and ver >= 2:
        n = b.u16()
    out = []
    for _ in range(n):
        w = b.u16()
        if ver == 4:
            b.align()
            startcap = b.ub(2)
            join = b.ub(2)
            hasfill = b.ub(1)
            b.ub(1); b.ub(1); b.ub(1)
            b.ub(5)
            b.ub(1)
            endcap = b.ub(2)
            if join == 2:
                b.u16()
            if hasfill:
                f = fillstyle(b, ver)
                out.append({'width': w, 'fill': f, 'cap': startcap, 'join': join})
            else:
                out.append({'width': w, 'color': color(b, True), 'cap': startcap, 'join': join})
        else:
            out.append({'width': w, 'color': color(b, ver >= 3)})
    return out


def parse_shape(body, ver):
    b = Bits(body)
    sid = b.u16()
    bounds = rect(b)
    if ver == 4:
        rect(b)
        b.u8()
    fills = fillarray(b, ver)
    lines = linearray(b, ver)
    b.align()
    nf = b.ub(4)
    nl = b.ub(4)
    all_fills = list(fills)
    all_lines = list(lines)
    cur_fills, cur_lines = fills, lines
    # kenar sayımları: (çizgi stili var mı, düz/eğri, uzunluk)
    edges = []
    cur_line = 0
    cur_f0 = cur_f1 = 0
    used_line = Counter()
    used_fill = Counter()
    while True:
        if b.ub(1) == 0:
            newst = b.ub(1)
            ls = b.ub(1)
            f1 = b.ub(1)
            f0 = b.ub(1)
            mv = b.ub(1)
            if not (newst or ls or f1 or f0 or mv):
                break
            if mv:
                n = b.ub(5)
                b.sb(n); b.sb(n)
            if f0:
                cur_f0 = b.ub(nf)
            if f1:
                cur_f1 = b.ub(nf)
            if ls:
                cur_line = b.ub(nl)
            if newst:
                b.align()
                cur_fills = fillarray(b, ver)
                cur_lines = linearray(b, ver)
                all_fills += cur_fills
                all_lines += cur_lines
                b.align()
                nf = b.ub(4)
                nl = b.ub(4)
                cur_line = cur_f0 = cur_f1 = 0
        else:
            straight = b.ub(1)
            n = b.ub(4) + 2
            if straight:
                if b.ub(1):
                    dx = b.sb(n); dy = b.sb(n)
                else:
                    if b.ub(1):
                        dx = 0; dy = b.sb(n)
                    else:
                        dx = b.sb(n); dy = 0
                L = math.hypot(dx, dy)
                curved = False
            else:
                cx = b.sb(n); cy = b.sb(n); ax = b.sb(n); ay = b.sb(n)
                L = math.hypot(cx, cy) + math.hypot(ax, ay)
                curved = True
            line = cur_lines[cur_line - 1] if cur_line and cur_line <= len(cur_lines) else None
            edges.append((line is not None, curved, L, line['width'] if line else 0,
                          line.get('color') if line else None))
            if line is not None:
                used_line[id(line)] += L
            for f in (cur_f0, cur_f1):
                if f and f <= len(cur_fills):
                    used_fill[id(cur_fills[f - 1])] += L
    return sid, bounds, all_fills, all_lines, edges, used_fill


def tags(data, start):
    pos = start
    while pos < len(data):
        h = struct.unpack_from('<H', data, pos)[0]
        pos += 2
        code = h >> 6
        ln = h & 0x3F
        if ln == 0x3F:
            ln = struct.unpack_from('<I', data, pos)[0]
            pos += 4
        yield code, data[pos:pos + ln]
        pos += ln
        if code == 0:
            break


def load(path):
    raw = open(path, 'rb').read()
    sig = raw[:3]
    ver = raw[3]
    if sig == b'CWS':
        data = raw[:8] + zlib.decompress(raw[8:])
    elif sig == b'FWS':
        data = raw
    else:
        raise ValueError(sig)
    b = Bits(data, 8)
    r = rect(b)
    pos = b.pos + 4
    return ver, r, data, pos


SHAPE_TAGS = {2: 1, 22: 2, 32: 3, 83: 4}
BITMAP_TAGS = {6, 21, 35, 36, 20, 90}


def main(path, outjson):
    ver, r, data, pos = load(path)
    shapes = []
    tagcount = Counter()
    for code, body in tags(data, pos):
        tagcount[code] += 1
        if code in SHAPE_TAGS:
            try:
                shapes.append(parse_shape(body, SHAPE_TAGS[code]))
            except Exception as e:
                print('hata', code, e, file=sys.stderr)
    out = {'swf_version': ver, 'stage_twips': r, 'tag_counts': dict(tagcount), 'shapes': []}
    for sid, bounds, fills, lines, edges, used_fill in shapes:
        out['shapes'].append({
            'id': sid,
            'bounds': bounds,
            'fills': [{k: v for k, v in f.items()} for f in fills],
            'fill_use': [used_fill.get(id(f), 0) for f in fills],
            'lines': lines,
            'edges': edges,
        })
    json.dump(out, open(outjson, 'w'))
    print('shapes', len(shapes), 'tags', dict(tagcount))


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
