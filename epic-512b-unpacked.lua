-- exported from crackle tracker
d = {

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
  function(x, y, r, c) rect(0, x - r, 240, r * 2, c) end,
  circ,
  function(x, y, r, c) rect(x - r, 0, r * 2, 240, c) end,
}

function TIC()
  for k = 0, 3 do
    p = t // 896 -- orderlist pos
    poke(65896, 32) -- set chn 2 wave
    e = t << d[k + 97] -- envelope pos
    -- n is note (semitones), 0=no note
    n = d[
        16 * d[9 * k + p + 101] + -15 -- patstart
            + e // 14 % 16] or 0 -- can sometimes be removed
    -- save envelopes for syncs
    -- d[0] = chn 0, d[-1] = chn 1...
    -- % ensures if n=0|pat=0 then env=0
    d[-k] = -e % 14 % (16 * n * d[9 * k + p + 101] + 1)
    u = d[4 * d[9 * 4 + p + 101] + 81 + t // 224 % 4]

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
  cls(3)
  for j = 0, 47 do
    poke(16320 + j, 255 / (1 + 2 ^ (5 - s(j % 3 + p) - j / 5 - d[-3] * .2)) ^ 2)
  end
  lx = s(p % 4 * (t / 49 + s(t / 99))) * 52 + 120
  ly = s(p % 4 * (t / 69 + s(t / 79))) * 52 + 68

  func[p % 3 + 1](lx, ly, 50, 0)

  for a = 13, 1, -1 do
    u = a * a * (d[-3] + 14) / 400 / 14 + 1
    for k = .5, 10 do
      w = t / 29
      y = 1 - k / 5
      y = (p + 1) % 3 // 2 * y
      r = (1 - y * y) ^ .5
      n = 1.3 * (p - 1)
      x = r * s(n * k + 8 + w)
      z = r * s(n * k + w)
      h = math.atan(math.max(u * (x ^ 2 + y ^ 2) ^ .5 - 1, z) * 10) * d[-2] / 3 - 1

      func[p % 3 + 1](
        52 * x * u + lx,
        52 * y * u + ly,
        (a + u) * h,
        -a)
    end
    y = (d[0] - 6) * u * 19 + 99
    func[1 + p % 2 * 2](y, y, u * 10, -a)
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
