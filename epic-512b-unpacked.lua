-- exported from crackle tracker
d = {
  0, 0, 0, 0,
  -- start 1, length 80: patterns
  1, 0, 5, 3, 4, 0, 7, 0, 1, 0, 3, 4, 5, 5, 4, 3,
  1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0,
  1, 7, 7, 1, 7, 7, 1, 7, 1, 7, 7, 1, 7, 7, 1, 7,
  1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0,
  1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1,

  -- start 81, length 16: key patterns
  1, 1, 1, 1, 1, 3, 5, 2, 1, 1, 0, 1, 1, 3, 0, 1,

  -- start 97, length 4: channel speeds
  -2, 1, 0, 0,

  -- 101 orderlist
  0, 0, 0, 5, 5, 1, 1, 1, 5,
  2, 2, 3, 3, 3, 3, 3, 3, 0,
  0, 1, 2, 2, 1, 1, 1, 1, 2,
  2, 2, 4, 5, 5, 5, 5, 5, 4,
  -- 137 keylist
  2, 2, 0, 0, 3, 3, 3, 1, 0,

}

t = 0

func = {
  circ,
  function(x, y, r, c) rect(x - r / 4, 0, r / 2, 136, c) end,
  function(x, y, r, c) rect(x - r, y - r, 2 * r, 2 * r, c) end
}

function TIC()
  for k = 0, 3 do
    p = t // 896 -- orderlist pos
    poke(65896, 32) -- set chn 2 wave
    e = t << d[k + 101] -- envelope pos
    -- n is note (semitones), 0=no note
    n = d[
        16 * d[9 * k + p + 105] + -11 -- patstart
            + e // 14 % 16] or 0 -- can sometimes be removed
    -- save envelopes for syncs
    -- d[0] = chn 0, d[-1] = chn 1...
    -- % ensures if n=0|pat=0 then env=0
    d[-k] = -e % 14 % (16 * n * d[9 * k + p + 105] + 1)

    d[k + 1] = d[k + 1] + d[-k]


    u = d[4 * d[9 * 4 + p + 105] + 85 + t // 224 % 4]

    n = (n - 1 - u // 2 * 2) * 7 // 6
    n = (n + u + 1) * 12 // 7
    sfx(
      k, -- channel k uses wave k
      8 -- global pitch:
      + 12 * k -- octave
      + n -- note
      - k // 3 * e % 14 * 7 -- pitch drop
      ~ 0, -- convert to int
      2,
      k,
      d[-k]-- stored envelope
    )
  end
  t = t + 1, t < 8063 or exit()
  cls()
  for j = 0, 47 do
    poke(16320 + j, 19 * d[-3] / (1 + 2 ^ (5 - s(j % 3 + d[3]) - j / 5)))
  end
  lx = s(t / 99) * 50 + 120
  ly = s(t / 79) * 50 + 68

  for z = 15, 1, -1 do
    u = z / 15 + 1
    circ(lx, ly, 25 * u, -z / 2 - 8)
    for k = 0, 20 do
      y = 1 - k / 10
      r = (1 - y * y) ^ .5 * 50
      w = d[4] / 99 + k * 5
      x = r * s(2.4 * k + 8 + w) + lx
      a = s(2.4 * k + w)
      y = y * r + ly
      x = (x - lx) * u + lx
      y = (y - ly) * u + ly
      func[1](x, y, z + u, -z)
    end
    y = (d[0] - 6) * u * 12 + 68
    w = u * 5
    rect(0, y - w, 240, w * 2, -z)
  end


end

s = math.sin
-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
