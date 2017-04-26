
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 26,
  height   = 24,
  xTexSize = 512,
  yTexSize = 512,
  outlineRadius = 2,
  outlineWeight = 100,
}

local glyphs = {}

glyphs[32] = { --' '--
  num = 32,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    3, oyp =    2,
  txn =    1, tyn =    1, txp =    6, typ =    6,
}
glyphs[33] = { --'!'--
  num = 33,
  adv = 8,
  oxn =    0, oyn =   -2, oxp =    9, oyp =   20,
  txn =   31, tyn =    1, txp =   40, typ =   23,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 11,
  oxn =   -1, oyn =    9, oxp =   13, oyp =   20,
  txn =   61, tyn =    1, txp =   75, typ =   12,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   19,
  txn =   91, tyn =    1, txp =  109, typ =   23,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 13,
  oxn =   -2, oyn =   -6, oxp =   15, oyp =   21,
  txn =  121, tyn =    1, txp =  138, typ =   28,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 21,
  oxn =   -2, oyn =   -3, oxp =   23, oyp =   20,
  txn =  151, tyn =    1, txp =  176, typ =   24,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   20,
  txn =  181, tyn =    1, txp =  201, typ =   24,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 6,
  oxn =   -1, oyn =    9, oxp =    7, oyp =   20,
  txn =  211, tyn =    1, txp =  219, typ =   12,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 8,
  oxn =   -2, oyn =   -7, oxp =   10, oyp =   20,
  txn =  241, tyn =    1, txp =  253, typ =   28,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 8,
  oxn =   -2, oyn =   -7, oxp =    9, oyp =   20,
  txn =  271, tyn =    1, txp =  282, typ =   28,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 9,
  oxn =   -2, oyn =    7, oxp =   11, oyp =   20,
  txn =  301, tyn =    1, txp =  314, typ =   14,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   14,
  txn =  331, tyn =    1, txp =  347, typ =   18,
}
glyphs[44] = { --','--
  num = 44,
  adv = 7,
  oxn =   -1, oyn =   -7, oxp =    8, oyp =    6,
  txn =  361, tyn =    1, txp =  370, typ =   14,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 8,
  oxn =   -2, oyn =    2, oxp =   10, oyp =   11,
  txn =  391, tyn =    1, txp =  403, typ =   10,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =    6,
  txn =  421, tyn =    1, txp =  430, typ =    9,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   20,
  txn =  451, tyn =    1, txp =  462, typ =   24,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  481, tyn =    1, txp =  498, typ =   24,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   12, oyp =   20,
  txn =    1, tyn =   32, txp =   14, typ =   54,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   20,
  txn =   31, tyn =   32, txp =   48, typ =   54,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =   61, tyn =   32, txp =   78, typ =   55,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   20,
  txn =   91, tyn =   32, txp =  108, typ =   54,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  121, tyn =   32, txp =  138, typ =   55,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  151, tyn =   32, txp =  168, typ =   55,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   20,
  txn =  181, tyn =   32, txp =  198, typ =   54,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  211, tyn =   32, txp =  228, typ =   55,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  241, tyn =   32, txp =  258, typ =   55,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 8,
  oxn =    0, oyn =   -2, oxp =    9, oyp =   15,
  txn =  271, tyn =   32, txp =  280, typ =   49,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 8,
  oxn =    0, oyn =   -7, oxp =    9, oyp =   15,
  txn =  301, tyn =   32, txp =  310, typ =   54,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   14,
  txn =  331, tyn =   32, txp =  348, typ =   49,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 14,
  oxn =   -1, oyn =   -1, oxp =   15, oyp =   12,
  txn =  361, tyn =   32, txp =  377, typ =   45,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   14,
  txn =  391, tyn =   32, txp =  408, typ =   49,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   20,
  txn =  421, tyn =   32, txp =  438, typ =   54,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 23,
  oxn =   -2, oyn =   -6, oxp =   25, oyp =   20,
  txn =  451, tyn =   32, txp =  478, typ =   58,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   20,
  txn =  481, tyn =   32, txp =  502, typ =   54,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   20,
  txn =    1, tyn =   63, txp =   20, typ =   85,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   20,
  txn =   31, tyn =   63, txp =   51, typ =   86,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   20,
  txn =   61, tyn =   63, txp =   81, typ =   85,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   20,
  txn =   91, tyn =   63, txp =  109, typ =   85,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   20,
  txn =  121, tyn =   63, txp =  139, typ =   85,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 19,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   20,
  txn =  151, tyn =   63, txp =  172, typ =   86,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   20,
  txn =  181, tyn =   63, txp =  200, typ =   85,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =   20,
  txn =  211, tyn =   63, txp =  220, typ =   85,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   20,
  txn =  241, tyn =   63, txp =  257, typ =   86,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   20, oyp =   20,
  txn =  271, tyn =   63, txp =  292, typ =   85,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   20,
  txn =  301, tyn =   63, txp =  318, typ =   85,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 20,
  oxn =   -1, oyn =   -2, oxp =   21, oyp =   20,
  txn =  331, tyn =   63, txp =  353, typ =   85,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   20,
  txn =  361, tyn =   63, txp =  380, typ =   85,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   20,
  txn =  391, tyn =   63, txp =  413, typ =   86,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   20,
  txn =  421, tyn =   63, txp =  440, typ =   85,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 19,
  oxn =   -1, oyn =   -4, oxp =   20, oyp =   20,
  txn =  451, tyn =   63, txp =  472, typ =   87,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   20,
  txn =  481, tyn =   63, txp =  501, typ =   85,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   20,
  txn =    1, tyn =   94, txp =   21, typ =  117,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 15,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   20,
  txn =   31, tyn =   94, txp =   50, typ =  116,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   20,
  txn =   61, tyn =   94, txp =   80, typ =  117,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 16,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   20,
  txn =   91, tyn =   94, txp =  111, typ =  116,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 23,
  oxn =   -2, oyn =   -2, oxp =   25, oyp =   20,
  txn =  121, tyn =   94, txp =  148, typ =  116,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 16,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   20,
  txn =  151, tyn =   94, txp =  171, typ =  116,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 16,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   20,
  txn =  181, tyn =   94, txp =  201, typ =  116,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 15,
  oxn =   -2, oyn =   -2, oxp =   16, oyp =   20,
  txn =  211, tyn =   94, txp =  229, typ =  116,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 8,
  oxn =   -1, oyn =   -7, oxp =   10, oyp =   20,
  txn =  241, tyn =   94, txp =  252, typ =  121,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 7,
  oxn =   -3, oyn =   -3, oxp =    9, oyp =   20,
  txn =  271, tyn =   94, txp =  283, typ =  117,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 8,
  oxn =   -2, oyn =   -7, oxp =    9, oyp =   20,
  txn =  301, tyn =   94, txp =  312, typ =  121,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 14,
  oxn =   -1, oyn =    4, oxp =   15, oyp =   19,
  txn =  331, tyn =   94, txp =  347, typ =  109,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 13,
  oxn =   -3, oyn =   -7, oxp =   16, oyp =    0,
  txn =  361, tyn =   94, txp =  380, typ =  101,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 8,
  oxn =   -2, oyn =   12, oxp =    8, oyp =   21,
  txn =  391, tyn =   94, txp =  401, typ =  103,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =  421, tyn =   94, txp =  438, typ =  113,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   20,
  txn =  451, tyn =   94, txp =  468, typ =  117,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =  481, tyn =   94, txp =  498, typ =  113,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   20,
  txn =    1, tyn =  125, txp =   19, typ =  148,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =   31, tyn =  125, txp =   48, typ =  144,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 8,
  oxn =   -2, oyn =   -2, oxp =   10, oyp =   20,
  txn =   61, tyn =  125, txp =   73, typ =  147,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 15,
  oxn =   -2, oyn =   -8, oxp =   15, oyp =   16,
  txn =   91, tyn =  125, txp =  108, typ =  149,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   20,
  txn =  121, tyn =  125, txp =  137, typ =  147,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    7, oyp =   20,
  txn =  151, tyn =  125, txp =  159, typ =  147,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 7,
  oxn =   -2, oyn =   -8, oxp =    8, oyp =   20,
  txn =  181, tyn =  125, txp =  191, typ =  153,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   20,
  txn =  211, tyn =  125, txp =  228, typ =  147,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    7, oyp =   20,
  txn =  241, tyn =  125, txp =  249, typ =  147,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 21,
  oxn =   -1, oyn =   -2, oxp =   22, oyp =   16,
  txn =  271, tyn =  125, txp =  294, typ =  143,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   16,
  txn =  301, tyn =  125, txp =  318, typ =  143,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   16,
  txn =  331, tyn =  125, txp =  349, typ =  144,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 15,
  oxn =   -1, oyn =   -8, oxp =   16, oyp =   16,
  txn =  361, tyn =  125, txp =  378, typ =  149,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 15,
  oxn =   -2, oyn =   -8, oxp =   16, oyp =   16,
  txn =  391, tyn =  125, txp =  409, typ =  149,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   16,
  txn =  421, tyn =  125, txp =  433, typ =  143,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =  451, tyn =  125, txp =  468, typ =  144,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   10, oyp =   19,
  txn =  481, tyn =  125, txp =  493, typ =  147,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   15,
  txn =    1, tyn =  156, txp =   17, typ =  174,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   15,
  txn =   31, tyn =  156, txp =   48, typ =  173,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 19,
  oxn =   -2, oyn =   -2, oxp =   21, oyp =   15,
  txn =   61, tyn =  156, txp =   84, typ =  173,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   15,
  txn =   91, tyn =  156, txp =  108, typ =  173,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 13,
  oxn =   -2, oyn =   -8, oxp =   15, oyp =   15,
  txn =  121, tyn =  156, txp =  138, typ =  179,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   15,
  txn =  151, tyn =  156, txp =  167, typ =  173,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 9,
  oxn =   -2, oyn =   -7, oxp =   10, oyp =   20,
  txn =  181, tyn =  156, txp =  193, typ =  183,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 7,
  oxn =    0, oyn =   -7, oxp =    7, oyp =   20,
  txn =  211, tyn =  156, txp =  218, typ =  183,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 9,
  oxn =   -1, oyn =   -7, oxp =   11, oyp =   20,
  txn =  241, tyn =  156, txp =  253, typ =  183,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 14,
  oxn =   -1, oyn =    1, oxp =   15, oyp =   10,
  txn =  271, tyn =  156, txp =  287, typ =  165,
}
glyphs[127] = { --''--
  num = 127,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  301, tyn =  156, txp =  313, typ =  176,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  331, tyn =  156, txp =  343, typ =  176,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  361, tyn =  156, txp =  373, typ =  176,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  391, tyn =  156, txp =  403, typ =  176,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  421, tyn =  156, txp =  433, typ =  176,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  451, tyn =  156, txp =  463, typ =  176,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  481, tyn =  156, txp =  493, typ =  176,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =    1, tyn =  187, txp =   13, typ =  207,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =   31, tyn =  187, txp =   43, typ =  207,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =   61, tyn =  187, txp =   73, typ =  207,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =   91, tyn =  187, txp =  103, typ =  207,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  121, tyn =  187, txp =  133, typ =  207,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  151, tyn =  187, txp =  163, typ =  207,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  181, tyn =  187, txp =  193, typ =  207,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  211, tyn =  187, txp =  223, typ =  207,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  241, tyn =  187, txp =  253, typ =  207,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  271, tyn =  187, txp =  283, typ =  207,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  301, tyn =  187, txp =  313, typ =  207,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  331, tyn =  187, txp =  343, typ =  207,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  361, tyn =  187, txp =  373, typ =  207,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  391, tyn =  187, txp =  403, typ =  207,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  421, tyn =  187, txp =  433, typ =  207,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  451, tyn =  187, txp =  463, typ =  207,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  481, tyn =  187, txp =  493, typ =  207,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =    1, tyn =  218, txp =   13, typ =  238,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =   31, tyn =  218, txp =   43, typ =  238,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =   61, tyn =  218, txp =   73, typ =  238,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =   91, tyn =  218, txp =  103, typ =  238,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  121, tyn =  218, txp =  133, typ =  238,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  151, tyn =  218, txp =  163, typ =  238,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  181, tyn =  218, txp =  193, typ =  238,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  211, tyn =  218, txp =  223, typ =  238,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  241, tyn =  218, txp =  253, typ =  238,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  271, tyn =  218, txp =  283, typ =  238,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 8,
  oxn =   -1, oyn =   -7, oxp =    8, oyp =   15,
  txn =  301, tyn =  218, txp =  310, typ =  240,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 13,
  oxn =   -2, oyn =   -5, oxp =   15, oyp =   18,
  txn =  331, tyn =  218, txp =  348, typ =  241,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  361, tyn =  218, txp =  378, typ =  241,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 13,
  oxn =   -2, oyn =    0, oxp =   15, oyp =   17,
  txn =  391, tyn =  218, txp =  408, typ =  235,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   16, oyp =   19,
  txn =  421, tyn =  218, txp =  439, typ =  239,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 7,
  oxn =    0, oyn =   -7, oxp =    7, oyp =   20,
  txn =  451, tyn =  218, txp =  458, typ =  245,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 13,
  oxn =   -2, oyn =   -7, oxp =   15, oyp =   20,
  txn =  481, tyn =  218, txp =  498, typ =  245,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 8,
  oxn =   -2, oyn =   12, oxp =   10, oyp =   20,
  txn =    1, tyn =  249, txp =   13, typ =  257,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 18,
  oxn =   -3, oyn =   -3, oxp =   21, oyp =   20,
  txn =   31, tyn =  249, txp =   55, typ =  272,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 9,
  oxn =   -2, oyn =    4, oxp =   10, oyp =   20,
  txn =   61, tyn =  249, txp =   73, typ =  265,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 13,
  oxn =    0, oyn =   -1, oxp =   14, oyp =   14,
  txn =   91, tyn =  249, txp =  105, typ =  264,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 14,
  oxn =   -2, oyn =    0, oxp =   16, oyp =   11,
  txn =  121, tyn =  249, txp =  139, typ =  260,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   18,
  txn =  151, tyn =  249, txp =  163, typ =  269,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 18,
  oxn =   -3, oyn =   -3, oxp =   21, oyp =   20,
  txn =  181, tyn =  249, txp =  205, typ =  272,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 8,
  oxn =   -2, oyn =   13, oxp =   10, oyp =   20,
  txn =  211, tyn =  249, txp =  223, typ =  256,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 15,
  oxn =    1, oyn =    7, oxp =   13, oyp =   19,
  txn =  241, tyn =  249, txp =  253, typ =  261,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   17,
  txn =  271, tyn =  249, txp =  287, typ =  269,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 8,
  oxn =   -2, oyn =    4, oxp =   10, oyp =   20,
  txn =  301, tyn =  249, txp =  313, typ =  265,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 8,
  oxn =   -2, oyn =    4, oxp =   10, oyp =   20,
  txn =  331, tyn =  249, txp =  343, typ =  265,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 8,
  oxn =    0, oyn =   12, oxp =   10, oyp =   21,
  txn =  361, tyn =  249, txp =  371, typ =  258,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 15,
  oxn =   -1, oyn =   -8, oxp =   16, oyp =   15,
  txn =  391, tyn =  249, txp =  408, typ =  272,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 13,
  oxn =   -2, oyn =   -7, oxp =   15, oyp =   20,
  txn =  421, tyn =  249, txp =  438, typ =  276,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 7,
  oxn =   -1, oyn =    2, oxp =    7, oyp =   10,
  txn =  451, tyn =  249, txp =  459, typ =  257,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 8,
  oxn =   -2, oyn =   -8, oxp =   10, oyp =    2,
  txn =  481, tyn =  249, txp =  493, typ =  259,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 8,
  oxn =   -2, oyn =    4, oxp =    8, oyp =   20,
  txn =    1, tyn =  280, txp =   11, typ =  296,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 9,
  oxn =   -2, oyn =    4, oxp =   11, oyp =   20,
  txn =   31, tyn =  280, txp =   44, typ =  296,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 13,
  oxn =    0, oyn =   -1, oxp =   14, oyp =   14,
  txn =   61, tyn =  280, txp =   75, typ =  295,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 21,
  oxn =   -2, oyn =   -3, oxp =   23, oyp =   20,
  txn =   91, tyn =  280, txp =  116, typ =  303,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 21,
  oxn =   -2, oyn =   -3, oxp =   23, oyp =   20,
  txn =  121, tyn =  280, txp =  146, typ =  303,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 21,
  oxn =   -2, oyn =   -3, oxp =   23, oyp =   20,
  txn =  151, tyn =  280, txp =  176, typ =  303,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 15,
  oxn =   -1, oyn =   -7, oxp =   16, oyp =   15,
  txn =  181, tyn =  280, txp =  198, typ =  302,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   25,
  txn =  211, tyn =  280, txp =  232, typ =  307,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   25,
  txn =  241, tyn =  280, txp =  262, typ =  307,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   25,
  txn =  271, tyn =  280, txp =  292, typ =  307,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   24,
  txn =  301, tyn =  280, txp =  322, typ =  306,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   24,
  txn =  331, tyn =  280, txp =  352, typ =  306,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   25,
  txn =  361, tyn =  280, txp =  382, typ =  307,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 24,
  oxn =   -2, oyn =   -2, oxp =   26, oyp =   20,
  txn =  391, tyn =  280, txp =  419, typ =  302,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 17,
  oxn =   -1, oyn =   -8, oxp =   19, oyp =   20,
  txn =  421, tyn =  280, txp =  441, typ =  308,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   25,
  txn =  451, tyn =  280, txp =  469, typ =  307,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   25,
  txn =  481, tyn =  280, txp =  499, typ =  307,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   25,
  txn =    1, tyn =  311, txp =   19, typ =  338,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   24,
  txn =   31, tyn =  311, txp =   49, typ =  337,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 7,
  oxn =   -3, oyn =   -2, oxp =    8, oyp =   25,
  txn =   61, tyn =  311, txp =   72, typ =  338,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   25,
  txn =   91, tyn =  311, txp =  101, typ =  338,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 7,
  oxn =   -3, oyn =   -2, oxp =    9, oyp =   25,
  txn =  121, tyn =  311, txp =  133, typ =  338,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 7,
  oxn =   -3, oyn =   -2, oxp =    9, oyp =   24,
  txn =  151, tyn =  311, txp =  163, typ =  337,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   20,
  txn =  181, tyn =  311, txp =  202, typ =  333,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   24,
  txn =  211, tyn =  311, txp =  230, typ =  337,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   25,
  txn =  241, tyn =  311, txp =  263, typ =  339,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   25,
  txn =  271, tyn =  311, txp =  293, typ =  339,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   25,
  txn =  301, tyn =  311, txp =  323, typ =  339,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   24,
  txn =  331, tyn =  311, txp =  353, typ =  338,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   24,
  txn =  361, tyn =  311, txp =  383, typ =  338,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   13,
  txn =  391, tyn =  311, txp =  407, typ =  326,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 19,
  oxn =   -2, oyn =   -3, oxp =   21, oyp =   20,
  txn =  421, tyn =  311, txp =  444, typ =  334,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   25,
  txn =  451, tyn =  311, txp =  470, typ =  339,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   25,
  txn =  481, tyn =  311, txp =  500, typ =  339,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   25,
  txn =    1, tyn =  342, txp =   20, typ =  370,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   24,
  txn =   31, tyn =  342, txp =   50, typ =  369,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 16,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   25,
  txn =   61, tyn =  342, txp =   81, typ =  369,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   20,
  txn =   91, tyn =  342, txp =  110, typ =  364,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   20,
  txn =  121, tyn =  342, txp =  138, typ =  365,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  151, tyn =  342, txp =  168, typ =  366,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  181, tyn =  342, txp =  198, typ =  366,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  211, tyn =  342, txp =  228, typ =  366,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  241, tyn =  342, txp =  258, typ =  365,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  271, tyn =  342, txp =  288, typ =  365,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  301, tyn =  342, txp =  318, typ =  366,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 21,
  oxn =   -2, oyn =   -3, oxp =   23, oyp =   16,
  txn =  331, tyn =  342, txp =  356, typ =  361,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 13,
  oxn =   -2, oyn =   -8, oxp =   15, oyp =   16,
  txn =  361, tyn =  342, txp =  378, typ =  366,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  391, tyn =  342, txp =  408, typ =  366,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  421, tyn =  342, txp =  438, typ =  366,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   21,
  txn =  451, tyn =  342, txp =  468, typ =  366,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   20,
  txn =  481, tyn =  342, txp =  498, typ =  365,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 7,
  oxn =   -3, oyn =   -2, oxp =    7, oyp =   21,
  txn =    1, tyn =  373, txp =   11, typ =  396,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   21,
  txn =   31, tyn =  373, txp =   41, typ =  396,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 7,
  oxn =   -3, oyn =   -2, oxp =    9, oyp =   21,
  txn =   61, tyn =  373, txp =   73, typ =  396,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 7,
  oxn =   -3, oyn =   -2, oxp =    9, oyp =   20,
  txn =   91, tyn =  373, txp =  103, typ =  395,
}
glyphs[240] = { --''--
  num = 240,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   20,
  txn =  121, tyn =  373, txp =  139, typ =  396,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   20,
  txn =  151, tyn =  373, txp =  168, typ =  395,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   21,
  txn =  181, tyn =  373, txp =  199, typ =  397,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   21,
  txn =  211, tyn =  373, txp =  229, typ =  397,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   21,
  txn =  241, tyn =  373, txp =  259, typ =  397,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   20,
  txn =  271, tyn =  373, txp =  289, typ =  396,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   20,
  txn =  301, tyn =  373, txp =  319, typ =  396,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   14,
  txn =  331, tyn =  373, txp =  347, typ =  390,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 15,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   16,
  txn =  361, tyn =  373, txp =  380, typ =  392,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   21,
  txn =  391, tyn =  373, txp =  407, typ =  397,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   21,
  txn =  421, tyn =  373, txp =  437, typ =  397,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   21,
  txn =  451, tyn =  373, txp =  467, typ =  397,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 15,
  oxn =   -1, oyn =   -3, oxp =   15, oyp =   20,
  txn =  481, tyn =  373, txp =  497, typ =  396,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 13,
  oxn =   -2, oyn =   -8, oxp =   15, oyp =   21,
  txn =    1, tyn =  404, txp =   18, typ =  433,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 15,
  oxn =   -1, oyn =   -8, oxp =   16, oyp =   20,
  txn =   31, tyn =  404, txp =   48, typ =  432,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 13,
  oxn =   -2, oyn =   -8, oxp =   15, oyp =   20,
  txn =   61, tyn =  404, txp =   78, typ =  432,
}

fontSpecs.glyphs = glyphs

return fontSpecs

