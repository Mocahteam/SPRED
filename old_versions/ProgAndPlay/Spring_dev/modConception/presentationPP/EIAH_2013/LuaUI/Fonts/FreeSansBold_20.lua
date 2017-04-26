
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 21,
  height   = 20,
  xTexSize = 512,
  yTexSize = 512,
  outlineRadius = 2,
  outlineWeight = 100,
}

local glyphs = {}

glyphs[32] = { --' '--
  num = 32,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    3, oyp =    2,
  txn =    1, tyn =    1, txp =    6, typ =    6,
}
glyphs[33] = { --'!'--
  num = 33,
  adv = 7,
  oxn =    0, oyn =   -2, oxp =    8, oyp =   17,
  txn =   27, tyn =    1, txp =   35, typ =   20,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 9,
  oxn =   -1, oyn =    7, oxp =   11, oyp =   17,
  txn =   53, tyn =    1, txp =   65, typ =   11,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   16,
  txn =   79, tyn =    1, txp =   95, typ =   20,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 11,
  oxn =   -2, oyn =   -5, oxp =   13, oyp =   18,
  txn =  105, tyn =    1, txp =  120, typ =   24,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 18,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   17,
  txn =  131, tyn =    1, txp =  153, typ =   21,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   17,
  txn =  157, tyn =    1, txp =  174, typ =   21,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 5,
  oxn =   -1, oyn =    7, oxp =    6, oyp =   17,
  txn =  183, tyn =    1, txp =  190, typ =   11,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 7,
  oxn =   -2, oyn =   -6, oxp =    9, oyp =   17,
  txn =  209, tyn =    1, txp =  220, typ =   24,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 7,
  oxn =   -2, oyn =   -6, oxp =    8, oyp =   17,
  txn =  235, tyn =    1, txp =  245, typ =   24,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 8,
  oxn =   -2, oyn =    6, oxp =   10, oyp =   17,
  txn =  261, tyn =    1, txp =  273, typ =   12,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   12,
  txn =  287, tyn =    1, txp =  301, typ =   16,
}
glyphs[44] = { --','--
  num = 44,
  adv = 6,
  oxn =   -1, oyn =   -6, oxp =    7, oyp =    5,
  txn =  313, tyn =    1, txp =  321, typ =   12,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 7,
  oxn =   -2, oyn =    2, oxp =    8, oyp =    9,
  txn =  339, tyn =    1, txp =  349, typ =    8,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 6,
  oxn =   -1, oyn =   -2, oxp =    7, oyp =    5,
  txn =  365, tyn =    1, txp =  373, typ =    8,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   17,
  txn =  391, tyn =    1, txp =  401, typ =   21,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  417, tyn =    1, txp =  432, typ =   21,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   17,
  txn =  443, tyn =    1, txp =  454, typ =   20,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   17,
  txn =  469, tyn =    1, txp =  484, typ =   20,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =    1, tyn =   28, txp =   16, typ =   48,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   17,
  txn =   27, tyn =   28, txp =   42, typ =   47,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =   53, tyn =   28, txp =   68, typ =   48,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =   79, tyn =   28, txp =   94, typ =   48,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   17,
  txn =  105, tyn =   28, txp =  120, typ =   47,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  131, tyn =   28, txp =  146, typ =   48,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  157, tyn =   28, txp =  172, typ =   48,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 7,
  oxn =    0, oyn =   -2, oxp =    8, oyp =   13,
  txn =  183, tyn =   28, txp =  191, typ =   43,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 7,
  oxn =    0, oyn =   -6, oxp =    8, oyp =   13,
  txn =  209, tyn =   28, txp =  217, typ =   47,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   12,
  txn =  235, tyn =   28, txp =  250, typ =   43,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 12,
  oxn =   -1, oyn =   -1, oxp =   13, oyp =   11,
  txn =  261, tyn =   28, txp =  275, typ =   40,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   12,
  txn =  287, tyn =   28, txp =  302, typ =   43,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   17,
  txn =  313, tyn =   28, txp =  328, typ =   47,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 20,
  oxn =   -2, oyn =   -5, oxp =   21, oyp =   17,
  txn =  339, tyn =   28, txp =  362, typ =   50,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   17,
  txn =  365, tyn =   28, txp =  384, typ =   47,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   17,
  txn =  391, tyn =   28, txp =  408, typ =   47,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   17,
  txn =  417, tyn =   28, txp =  435, typ =   48,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   17,
  txn =  443, tyn =   28, txp =  460, typ =   47,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   17,
  txn =  469, tyn =   28, txp =  485, typ =   47,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   17,
  txn =    1, tyn =   55, txp =   16, typ =   74,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   17,
  txn =   27, tyn =   55, txp =   46, typ =   75,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   17,
  txn =   53, tyn =   55, txp =   70, typ =   74,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 6,
  oxn =   -1, oyn =   -2, oxp =    7, oyp =   17,
  txn =   79, tyn =   55, txp =   87, typ =   74,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   17,
  txn =  105, tyn =   55, txp =  119, typ =   75,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   17,
  txn =  131, tyn =   55, txp =  149, typ =   74,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   17,
  txn =  157, tyn =   55, txp =  172, typ =   74,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   18, oyp =   17,
  txn =  183, tyn =   55, txp =  202, typ =   74,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   17,
  txn =  209, tyn =   55, txp =  226, typ =   74,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   17,
  txn =  235, tyn =   55, txp =  254, typ =   75,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   17,
  txn =  261, tyn =   55, txp =  277, typ =   74,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 16,
  oxn =   -2, oyn =   -4, oxp =   17, oyp =   17,
  txn =  287, tyn =   55, txp =  306, typ =   76,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   17,
  txn =  313, tyn =   55, txp =  330, typ =   74,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   17,
  txn =  339, tyn =   55, txp =  356, typ =   75,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   17,
  txn =  365, tyn =   55, txp =  381, typ =   74,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   17,
  txn =  391, tyn =   55, txp =  408, typ =   75,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   17,
  txn =  417, tyn =   55, txp =  434, typ =   74,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 19,
  oxn =   -2, oyn =   -2, oxp =   21, oyp =   17,
  txn =  443, tyn =   55, txp =  466, typ =   74,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   16, oyp =   17,
  txn =  469, tyn =   55, txp =  487, typ =   74,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   17,
  txn =    1, tyn =   82, txp =   18, typ =  101,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   17,
  txn =   27, tyn =   82, txp =   43, typ =  101,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 7,
  oxn =   -1, oyn =   -6, oxp =    9, oyp =   17,
  txn =   53, tyn =   82, txp =   63, typ =  105,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 6,
  oxn =   -3, oyn =   -3, oxp =    8, oyp =   17,
  txn =   79, tyn =   82, txp =   90, typ =  102,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 7,
  oxn =   -2, oyn =   -6, oxp =    8, oyp =   17,
  txn =  105, tyn =   82, txp =  115, typ =  105,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 12,
  oxn =   -1, oyn =    3, oxp =   13, oyp =   16,
  txn =  131, tyn =   82, txp =  145, typ =   95,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 11,
  oxn =   -3, oyn =   -6, oxp =   14, oyp =    0,
  txn =  157, tyn =   82, txp =  174, typ =   88,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 7,
  oxn =   -2, oyn =   10, oxp =    7, oyp =   18,
  txn =  183, tyn =   82, txp =  192, typ =   90,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   13,
  txn =  209, tyn =   82, txp =  224, typ =   98,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   17,
  txn =  235, tyn =   82, txp =  250, typ =  102,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   13,
  txn =  261, tyn =   82, txp =  276, typ =   98,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  287, tyn =   82, txp =  302, typ =  102,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   13,
  txn =  313, tyn =   82, txp =  328, typ =   98,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 7,
  oxn =   -2, oyn =   -2, oxp =    9, oyp =   17,
  txn =  339, tyn =   82, txp =  350, typ =  101,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 12,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   13,
  txn =  365, tyn =   82, txp =  380, typ =  102,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   17,
  txn =  391, tyn =   82, txp =  405, typ =  101,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 6,
  oxn =   -1, oyn =   -2, oxp =    7, oyp =   17,
  txn =  417, tyn =   82, txp =  425, typ =  101,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 6,
  oxn =   -2, oyn =   -7, oxp =    7, oyp =   17,
  txn =  443, tyn =   82, txp =  452, typ =  106,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   17,
  txn =  469, tyn =   82, txp =  483, typ =  101,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 6,
  oxn =   -1, oyn =   -2, oxp =    7, oyp =   17,
  txn =    1, tyn =  109, txp =    9, typ =  128,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 18,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   13,
  txn =   27, tyn =  109, txp =   47, typ =  124,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   13,
  txn =   53, tyn =  109, txp =   67, typ =  124,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   13,
  txn =   79, tyn =  109, txp =   95, typ =  125,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 12,
  oxn =   -1, oyn =   -7, oxp =   14, oyp =   13,
  txn =  105, tyn =  109, txp =  120, typ =  129,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 12,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   13,
  txn =  131, tyn =  109, txp =  146, typ =  129,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   13,
  txn =  157, tyn =  109, txp =  168, typ =  124,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   13,
  txn =  183, tyn =  109, txp =  198, typ =  125,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 7,
  oxn =   -2, oyn =   -3, oxp =    9, oyp =   16,
  txn =  209, tyn =  109, txp =  220, typ =  128,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   13,
  txn =  235, tyn =  109, txp =  249, typ =  125,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   13,
  txn =  261, tyn =  109, txp =  276, typ =  124,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 16,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   13,
  txn =  287, tyn =  109, txp =  307, typ =  124,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   13,
  txn =  313, tyn =  109, txp =  328, typ =  124,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 11,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   13,
  txn =  339, tyn =  109, txp =  354, typ =  129,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   13,
  txn =  365, tyn =  109, txp =  379, typ =  124,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 8,
  oxn =   -2, oyn =   -6, oxp =    9, oyp =   17,
  txn =  391, tyn =  109, txp =  402, typ =  132,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 6,
  oxn =    0, oyn =   -6, oxp =    6, oyp =   17,
  txn =  417, tyn =  109, txp =  423, typ =  132,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 8,
  oxn =   -1, oyn =   -6, oxp =   10, oyp =   17,
  txn =  443, tyn =  109, txp =  454, typ =  132,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 12,
  oxn =   -1, oyn =    0, oxp =   13, oyp =    9,
  txn =  469, tyn =  109, txp =  483, typ =  118,
}
glyphs[127] = { --''--
  num = 127,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =    1, tyn =  136, txp =   12, typ =  154,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =   27, tyn =  136, txp =   38, typ =  154,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =   53, tyn =  136, txp =   64, typ =  154,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =   79, tyn =  136, txp =   90, typ =  154,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  105, tyn =  136, txp =  116, typ =  154,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  131, tyn =  136, txp =  142, typ =  154,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  157, tyn =  136, txp =  168, typ =  154,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  183, tyn =  136, txp =  194, typ =  154,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  209, tyn =  136, txp =  220, typ =  154,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  235, tyn =  136, txp =  246, typ =  154,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  261, tyn =  136, txp =  272, typ =  154,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  287, tyn =  136, txp =  298, typ =  154,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  313, tyn =  136, txp =  324, typ =  154,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  339, tyn =  136, txp =  350, typ =  154,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  365, tyn =  136, txp =  376, typ =  154,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  391, tyn =  136, txp =  402, typ =  154,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  417, tyn =  136, txp =  428, typ =  154,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  443, tyn =  136, txp =  454, typ =  154,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  469, tyn =  136, txp =  480, typ =  154,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =    1, tyn =  163, txp =   12, typ =  181,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =   27, tyn =  163, txp =   38, typ =  181,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =   53, tyn =  163, txp =   64, typ =  181,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =   79, tyn =  163, txp =   90, typ =  181,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  105, tyn =  163, txp =  116, typ =  181,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  131, tyn =  163, txp =  142, typ =  181,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  157, tyn =  163, txp =  168, typ =  181,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  183, tyn =  163, txp =  194, typ =  181,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  209, tyn =  163, txp =  220, typ =  181,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  235, tyn =  163, txp =  246, typ =  181,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  261, tyn =  163, txp =  272, typ =  181,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  287, tyn =  163, txp =  298, typ =  181,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  313, tyn =  163, txp =  324, typ =  181,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  339, tyn =  163, txp =  350, typ =  181,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  365, tyn =  163, txp =  376, typ =  181,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 7,
  oxn =   -1, oyn =   -6, oxp =    7, oyp =   13,
  txn =  391, tyn =  163, txp =  399, typ =  182,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 11,
  oxn =   -2, oyn =   -5, oxp =   13, oyp =   15,
  txn =  417, tyn =  163, txp =  432, typ =  183,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  443, tyn =  163, txp =  458, typ =  183,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 11,
  oxn =   -2, oyn =    0, oxp =   13, oyp =   15,
  txn =  469, tyn =  163, txp =  484, typ =  178,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   17,
  txn =    1, tyn =  190, txp =   17, typ =  209,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 6,
  oxn =    0, oyn =   -6, oxp =    6, oyp =   17,
  txn =   27, tyn =  190, txp =   33, typ =  213,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 11,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   17,
  txn =   53, tyn =  190, txp =   68, typ =  214,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 7,
  oxn =   -2, oyn =   10, oxp =    9, oyp =   17,
  txn =   79, tyn =  190, txp =   90, typ =  197,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 15,
  oxn =   -3, oyn =   -3, oxp =   18, oyp =   17,
  txn =  105, tyn =  190, txp =  126, typ =  210,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 7,
  oxn =   -2, oyn =    3, oxp =    9, oyp =   17,
  txn =  131, tyn =  190, txp =  142, typ =  204,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 11,
  oxn =   -1, oyn =   -1, oxp =   12, oyp =   12,
  txn =  157, tyn =  190, txp =  170, typ =  203,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 12,
  oxn =   -2, oyn =   -1, oxp =   13, oyp =   10,
  txn =  183, tyn =  190, txp =  198, typ =  201,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 9,
  oxn =   -1, oyn =   -2, oxp =   10, oyp =   16,
  txn =  209, tyn =  190, txp =  220, typ =  208,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 15,
  oxn =   -3, oyn =   -3, oxp =   18, oyp =   17,
  txn =  235, tyn =  190, txp =  256, typ =  210,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 7,
  oxn =   -2, oyn =   10, oxp =    9, oyp =   17,
  txn =  261, tyn =  190, txp =  272, typ =  197,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 12,
  oxn =    1, oyn =    5, oxp =   12, oyp =   16,
  txn =  287, tyn =  190, txp =  298, typ =  201,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   15,
  txn =  313, tyn =  190, txp =  327, typ =  208,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 7,
  oxn =   -2, oyn =    3, oxp =    9, oyp =   17,
  txn =  339, tyn =  190, txp =  350, typ =  204,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 7,
  oxn =   -2, oyn =    3, oxp =    9, oyp =   17,
  txn =  365, tyn =  190, txp =  376, typ =  204,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 7,
  oxn =    0, oyn =   10, oxp =    9, oyp =   18,
  txn =  391, tyn =  190, txp =  400, typ =  198,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 12,
  oxn =   -1, oyn =   -7, oxp =   14, oyp =   13,
  txn =  417, tyn =  190, txp =  432, typ =  210,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 11,
  oxn =   -2, oyn =   -6, oxp =   13, oyp =   17,
  txn =  443, tyn =  190, txp =  458, typ =  213,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 6,
  oxn =   -1, oyn =    1, oxp =    6, oyp =    8,
  txn =  469, tyn =  190, txp =  476, typ =  197,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 7,
  oxn =   -2, oyn =   -7, oxp =    8, oyp =    2,
  txn =    1, tyn =  217, txp =   11, typ =  226,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 7,
  oxn =   -2, oyn =    3, oxp =    7, oyp =   17,
  txn =   27, tyn =  217, txp =   36, typ =  231,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 7,
  oxn =   -2, oyn =    3, oxp =    9, oyp =   17,
  txn =   53, tyn =  217, txp =   64, typ =  231,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 11,
  oxn =   -1, oyn =   -1, oxp =   12, oyp =   12,
  txn =   79, tyn =  217, txp =   92, typ =  230,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   19, oyp =   17,
  txn =  105, tyn =  217, txp =  126, typ =  237,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   19, oyp =   17,
  txn =  131, tyn =  217, txp =  152, typ =  237,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   19, oyp =   17,
  txn =  157, tyn =  217, txp =  178, typ =  237,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 12,
  oxn =   -1, oyn =   -7, oxp =   13, oyp =   13,
  txn =  183, tyn =  217, txp =  197, typ =  237,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   22,
  txn =  209, tyn =  217, txp =  228, typ =  241,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   22,
  txn =  235, tyn =  217, txp =  254, typ =  241,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   22,
  txn =  261, tyn =  217, txp =  280, typ =  241,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   21,
  txn =  287, tyn =  217, txp =  306, typ =  240,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   21,
  txn =  313, tyn =  217, txp =  332, typ =  240,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   22,
  txn =  339, tyn =  217, txp =  358, typ =  241,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 20,
  oxn =   -2, oyn =   -2, oxp =   22, oyp =   17,
  txn =  365, tyn =  217, txp =  389, typ =  236,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 14,
  oxn =   -2, oyn =   -7, oxp =   16, oyp =   17,
  txn =  391, tyn =  217, txp =  409, typ =  241,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   22,
  txn =  417, tyn =  217, txp =  433, typ =  241,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   22,
  txn =  443, tyn =  217, txp =  459, typ =  241,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   22,
  txn =  469, tyn =  217, txp =  485, typ =  241,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   21,
  txn =    1, tyn =  244, txp =   17, typ =  267,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 6,
  oxn =   -3, oyn =   -2, oxp =    7, oyp =   22,
  txn =   27, tyn =  244, txp =   37, typ =  268,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 6,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =   22,
  txn =   53, tyn =  244, txp =   62, typ =  268,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 6,
  oxn =   -3, oyn =   -2, oxp =    8, oyp =   22,
  txn =   79, tyn =  244, txp =   90, typ =  268,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 6,
  oxn =   -3, oyn =   -2, oxp =    8, oyp =   21,
  txn =  105, tyn =  244, txp =  116, typ =  267,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   16, oyp =   17,
  txn =  131, tyn =  244, txp =  149, typ =  263,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 14,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   21,
  txn =  157, tyn =  244, txp =  174, typ =  267,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   22,
  txn =  183, tyn =  244, txp =  202, typ =  269,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   22,
  txn =  209, tyn =  244, txp =  228, typ =  269,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   22,
  txn =  235, tyn =  244, txp =  254, typ =  269,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   21,
  txn =  261, tyn =  244, txp =  280, typ =  268,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   21,
  txn =  287, tyn =  244, txp =  306, typ =  268,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   11,
  txn =  313, tyn =  244, txp =  327, typ =  257,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   17,
  txn =  339, tyn =  244, txp =  359, typ =  264,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   22,
  txn =  365, tyn =  244, txp =  382, typ =  269,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   22,
  txn =  391, tyn =  244, txp =  408, typ =  269,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   22,
  txn =  417, tyn =  244, txp =  434, typ =  269,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 14,
  oxn =   -1, oyn =   -3, oxp =   16, oyp =   21,
  txn =  443, tyn =  244, txp =  460, typ =  268,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   22,
  txn =  469, tyn =  244, txp =  486, typ =  268,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   17,
  txn =    1, tyn =  271, txp =   17, typ =  290,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   17,
  txn =   27, tyn =  271, txp =   42, typ =  291,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =   53, tyn =  271, txp =   68, typ =  292,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =   79, tyn =  271, txp =   94, typ =  292,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =  105, tyn =  271, txp =  120, typ =  292,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  131, tyn =  271, txp =  146, typ =  291,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  157, tyn =  271, txp =  172, typ =  291,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =  183, tyn =  271, txp =  198, typ =  292,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 18,
  oxn =   -2, oyn =   -3, oxp =   20, oyp =   13,
  txn =  209, tyn =  271, txp =  231, typ =  287,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 11,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   13,
  txn =  235, tyn =  271, txp =  250, typ =  291,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =  261, tyn =  271, txp =  276, typ =  292,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =  287, tyn =  271, txp =  302, typ =  292,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   18,
  txn =  313, tyn =  271, txp =  328, typ =  292,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   17,
  txn =  339, tyn =  271, txp =  354, typ =  291,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 6,
  oxn =   -3, oyn =   -2, oxp =    7, oyp =   18,
  txn =  365, tyn =  271, txp =  375, typ =  291,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 6,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =   18,
  txn =  391, tyn =  271, txp =  400, typ =  291,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 6,
  oxn =   -3, oyn =   -2, oxp =    8, oyp =   18,
  txn =  417, tyn =  271, txp =  428, typ =  291,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 6,
  oxn =   -3, oyn =   -2, oxp =    8, oyp =   17,
  txn =  443, tyn =  271, txp =  454, typ =  290,
}
glyphs[240] = { --''--
  num = 240,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   17,
  txn =  469, tyn =  271, txp =  485, typ =  291,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   17,
  txn =    1, tyn =  298, txp =   15, typ =  317,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   18,
  txn =   27, tyn =  298, txp =   43, typ =  319,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   18,
  txn =   53, tyn =  298, txp =   69, typ =  319,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   18,
  txn =   79, tyn =  298, txp =   95, typ =  319,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   17,
  txn =  105, tyn =  298, txp =  121, typ =  318,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   17,
  txn =  131, tyn =  298, txp =  147, typ =  318,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   12,
  txn =  157, tyn =  298, txp =  171, typ =  313,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   14,
  txn =  183, tyn =  298, txp =  199, typ =  315,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   18,
  txn =  209, tyn =  298, txp =  223, typ =  319,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   18,
  txn =  235, tyn =  298, txp =  249, typ =  319,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   18,
  txn =  261, tyn =  298, txp =  275, typ =  319,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 12,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   17,
  txn =  287, tyn =  298, txp =  301, typ =  318,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 11,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   18,
  txn =  313, tyn =  298, txp =  328, typ =  323,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 12,
  oxn =   -1, oyn =   -7, oxp =   14, oyp =   17,
  txn =  339, tyn =  298, txp =  354, typ =  322,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 11,
  oxn =   -2, oyn =   -7, oxp =   13, oyp =   17,
  txn =  365, tyn =  298, txp =  380, typ =  322,
}

fontSpecs.glyphs = glyphs

return fontSpecs

