
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 32,
  height   = 30,
  xTexSize = 512,
  yTexSize = 1024,
  outlineRadius = 2,
  outlineWeight = 100,
}

local glyphs = {}

glyphs[32] = { --' '--
  num = 32,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =    3, oyp =    2,
  txn =    1, tyn =    1, txp =    6, typ =    6,
}
glyphs[33] = { --'!'--
  num = 33,
  adv = 10,
  oxn =    1, oyn =   -2, oxp =   10, oyp =   24,
  txn =   36, tyn =    1, txp =   45, typ =   27,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 14,
  oxn =   -1, oyn =   12, oxp =   15, oyp =   24,
  txn =   71, tyn =    1, txp =   87, typ =   13,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   19, oyp =   23,
  txn =  106, tyn =    1, txp =  127, typ =   27,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 17,
  oxn =   -2, oyn =   -6, oxp =   18, oyp =   25,
  txn =  141, tyn =    1, txp =  161, typ =   32,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 27,
  oxn =   -2, oyn =   -3, oxp =   28, oyp =   24,
  txn =  176, tyn =    1, txp =  206, typ =   28,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 22,
  oxn =   -1, oyn =   -3, oxp =   23, oyp =   24,
  txn =  211, tyn =    1, txp =  235, typ =   28,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 7,
  oxn =   -1, oyn =   12, oxp =    8, oyp =   24,
  txn =  246, tyn =    1, txp =  255, typ =   13,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 10,
  oxn =   -1, oyn =   -8, oxp =   12, oyp =   24,
  txn =  281, tyn =    1, txp =  294, typ =   33,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 10,
  oxn =   -2, oyn =   -8, oxp =   11, oyp =   24,
  txn =  316, tyn =    1, txp =  329, typ =   33,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 12,
  oxn =   -2, oyn =   10, oxp =   13, oyp =   24,
  txn =  351, tyn =    1, txp =  366, typ =   15,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   17,
  txn =  386, tyn =    1, txp =  405, typ =   21,
}
glyphs[44] = { --','--
  num = 44,
  adv = 8,
  oxn =   -1, oyn =   -8, oxp =    9, oyp =    7,
  txn =  421, tyn =    1, txp =  431, typ =   16,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 10,
  oxn =   -2, oyn =    4, oxp =   11, oyp =   13,
  txn =  456, tyn =    1, txp =  469, typ =   10,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =    7,
  txn =    1, tyn =   37, txp =   11, typ =   46,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 8,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   24,
  txn =   36, tyn =   37, txp =   49, typ =   64,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   24,
  txn =   71, tyn =   37, txp =   91, typ =   64,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 17,
  oxn =    0, oyn =   -2, oxp =   14, oyp =   24,
  txn =  106, tyn =   37, txp =  120, typ =   63,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   24,
  txn =  141, tyn =   37, txp =  161, typ =   63,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   24,
  txn =  176, tyn =   37, txp =  196, typ =   64,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   24,
  txn =  211, tyn =   37, txp =  231, typ =   63,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   24,
  txn =  246, tyn =   37, txp =  266, typ =   64,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   24,
  txn =  281, tyn =   37, txp =  301, typ =   64,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   18, oyp =   24,
  txn =  316, tyn =   37, txp =  336, typ =   63,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   24,
  txn =  351, tyn =   37, txp =  371, typ =   64,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   24,
  txn =  386, tyn =   37, txp =  406, typ =   64,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 10,
  oxn =    1, oyn =   -2, oxp =   10, oyp =   18,
  txn =  421, tyn =   37, txp =  430, typ =   57,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 10,
  oxn =    1, oyn =   -8, oxp =   10, oyp =   18,
  txn =  456, tyn =   37, txp =  465, typ =   63,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   17,
  txn =    1, tyn =   73, txp =   20, typ =   93,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 18,
  oxn =   -1, oyn =   -1, oxp =   19, oyp =   15,
  txn =   36, tyn =   73, txp =   56, typ =   89,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   17,
  txn =   71, tyn =   73, txp =   90, typ =   93,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 18,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   25,
  txn =  106, tyn =   73, txp =  126, typ =  100,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 29,
  oxn =   -2, oyn =   -7, oxp =   31, oyp =   25,
  txn =  141, tyn =   73, txp =  174, typ =  105,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   24,
  txn =  176, tyn =   73, txp =  202, typ =   99,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   22, oyp =   24,
  txn =  211, tyn =   73, txp =  233, typ =   99,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 22,
  oxn =   -1, oyn =   -3, oxp =   23, oyp =   25,
  txn =  246, tyn =   73, txp =  270, typ =  101,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   23, oyp =   24,
  txn =  281, tyn =   73, txp =  304, typ =   99,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   24,
  txn =  316, tyn =   73, txp =  337, typ =   99,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 18,
  oxn =    0, oyn =   -2, oxp =   20, oyp =   24,
  txn =  351, tyn =   73, txp =  371, typ =   99,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   24, oyp =   25,
  txn =  386, tyn =   73, txp =  411, typ =  101,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   22, oyp =   24,
  txn =  421, tyn =   73, txp =  443, typ =   99,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   24,
  txn =  456, tyn =   73, txp =  466, typ =   99,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   17, oyp =   24,
  txn =    1, tyn =  109, txp =   20, typ =  136,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   24, oyp =   24,
  txn =   36, tyn =  109, txp =   60, typ =  135,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 18,
  oxn =    0, oyn =   -2, oxp =   20, oyp =   24,
  txn =   71, tyn =  109, txp =   91, typ =  135,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 25,
  oxn =   -1, oyn =   -2, oxp =   26, oyp =   24,
  txn =  106, tyn =  109, txp =  133, typ =  135,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   22, oyp =   24,
  txn =  141, tyn =  109, txp =  163, typ =  135,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   25, oyp =   25,
  txn =  176, tyn =  109, txp =  202, typ =  137,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   24,
  txn =  211, tyn =  109, txp =  232, typ =  135,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 23,
  oxn =   -1, oyn =   -4, oxp =   25, oyp =   25,
  txn =  246, tyn =  109, txp =  272, typ =  138,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   23, oyp =   24,
  txn =  281, tyn =  109, txp =  304, typ =  135,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 20,
  oxn =   -2, oyn =   -3, oxp =   21, oyp =   25,
  txn =  316, tyn =  109, txp =  339, typ =  137,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 18,
  oxn =   -2, oyn =   -2, oxp =   20, oyp =   24,
  txn =  351, tyn =  109, txp =  373, typ =  135,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 22,
  oxn =    0, oyn =   -3, oxp =   22, oyp =   24,
  txn =  386, tyn =  109, txp =  408, typ =  136,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 20,
  oxn =   -2, oyn =   -2, oxp =   22, oyp =   24,
  txn =  421, tyn =  109, txp =  445, typ =  135,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 28,
  oxn =   -2, oyn =   -2, oxp =   30, oyp =   24,
  txn =  456, tyn =  109, txp =  488, typ =  135,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 20,
  oxn =   -2, oyn =   -2, oxp =   22, oyp =   24,
  txn =    1, tyn =  145, txp =   25, typ =  171,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 20,
  oxn =   -2, oyn =   -2, oxp =   22, oyp =   24,
  txn =   36, tyn =  145, txp =   60, typ =  171,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 18,
  oxn =   -2, oyn =   -2, oxp =   20, oyp =   24,
  txn =   71, tyn =  145, txp =   93, typ =  171,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 10,
  oxn =   -1, oyn =   -8, oxp =   12, oyp =   24,
  txn =  106, tyn =  145, txp =  119, typ =  177,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 8,
  oxn =   -3, oyn =   -3, oxp =   11, oyp =   24,
  txn =  141, tyn =  145, txp =  155, typ =  172,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 10,
  oxn =   -2, oyn =   -8, oxp =   10, oyp =   24,
  txn =  176, tyn =  145, txp =  188, typ =  177,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 18,
  oxn =   -1, oyn =    6, oxp =   18, oyp =   23,
  txn =  211, tyn =  145, txp =  230, typ =  162,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 17,
  oxn =   -3, oyn =   -8, oxp =   20, oyp =   -1,
  txn =  246, tyn =  145, txp =  269, typ =  152,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 10,
  oxn =   -2, oyn =   16, oxp =    9, oyp =   25,
  txn =  281, tyn =  145, txp =  292, typ =  154,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   19,
  txn =  316, tyn =  145, txp =  336, typ =  167,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   24,
  txn =  351, tyn =  145, txp =  372, typ =  172,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 17,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   19,
  txn =  386, tyn =  145, txp =  405, typ =  167,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 18,
  oxn =   -2, oyn =   -3, oxp =   19, oyp =   24,
  txn =  421, tyn =  145, txp =  442, typ =  172,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   19,
  txn =  456, tyn =  145, txp =  476, typ =  167,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   24,
  txn =    1, tyn =  181, txp =   15, typ =  207,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 18,
  oxn =   -1, oyn =   -9, oxp =   19, oyp =   19,
  txn =   36, tyn =  181, txp =   56, typ =  209,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 18,
  oxn =    0, oyn =   -2, oxp =   19, oyp =   24,
  txn =   71, tyn =  181, txp =   90, typ =  207,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 8,
  oxn =    0, oyn =   -2, oxp =    9, oyp =   24,
  txn =  106, tyn =  181, txp =  115, typ =  207,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 8,
  oxn =   -2, oyn =   -9, oxp =    9, oyp =   24,
  txn =  141, tyn =  181, txp =  152, typ =  214,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 17,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   24,
  txn =  176, tyn =  181, txp =  196, typ =  207,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 8,
  oxn =    0, oyn =   -2, oxp =    9, oyp =   24,
  txn =  211, tyn =  181, txp =  220, typ =  207,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 27,
  oxn =   -1, oyn =   -2, oxp =   27, oyp =   19,
  txn =  246, tyn =  181, txp =  274, typ =  202,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 18,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   19,
  txn =  281, tyn =  181, txp =  301, typ =  202,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   19,
  txn =  316, tyn =  181, txp =  337, typ =  203,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 18,
  oxn =   -1, oyn =   -9, oxp =   20, oyp =   19,
  txn =  351, tyn =  181, txp =  372, typ =  209,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 18,
  oxn =   -2, oyn =   -9, oxp =   19, oyp =   19,
  txn =  386, tyn =  181, txp =  407, typ =  209,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   19,
  txn =  421, tyn =  181, txp =  436, typ =  202,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   19,
  txn =  456, tyn =  181, txp =  476, typ =  203,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   23,
  txn =    1, tyn =  217, txp =   15, typ =  243,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   19,
  txn =   36, tyn =  217, txp =   56, typ =  239,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   19,
  txn =   71, tyn =  217, txp =   92, typ =  238,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 23,
  oxn =   -2, oyn =   -2, oxp =   25, oyp =   19,
  txn =  106, tyn =  217, txp =  133, typ =  238,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   19,
  txn =  141, tyn =  217, txp =  162, typ =  238,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 17,
  oxn =   -2, oyn =   -9, oxp =   19, oyp =   19,
  txn =  176, tyn =  217, txp =  197, typ =  245,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 15,
  oxn =   -2, oyn =   -2, oxp =   17, oyp =   19,
  txn =  211, tyn =  217, txp =  230, typ =  238,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 12,
  oxn =   -1, oyn =   -8, oxp =   12, oyp =   24,
  txn =  246, tyn =  217, txp =  259, typ =  249,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 8,
  oxn =    1, oyn =   -8, oxp =    8, oyp =   24,
  txn =  281, tyn =  217, txp =  288, typ =  249,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 12,
  oxn =    0, oyn =   -8, oxp =   13, oyp =   24,
  txn =  316, tyn =  217, txp =  329, typ =  249,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 18,
  oxn =   -1, oyn =    2, oxp =   18, oyp =   12,
  txn =  351, tyn =  217, txp =  370, typ =  227,
}
glyphs[127] = { --''--
  num = 127,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  386, tyn =  217, txp =  400, typ =  241,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  421, tyn =  217, txp =  435, typ =  241,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  456, tyn =  217, txp =  470, typ =  241,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =    1, tyn =  253, txp =   15, typ =  277,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   36, tyn =  253, txp =   50, typ =  277,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   71, tyn =  253, txp =   85, typ =  277,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  106, tyn =  253, txp =  120, typ =  277,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  141, tyn =  253, txp =  155, typ =  277,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  176, tyn =  253, txp =  190, typ =  277,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  211, tyn =  253, txp =  225, typ =  277,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  246, tyn =  253, txp =  260, typ =  277,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  281, tyn =  253, txp =  295, typ =  277,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  316, tyn =  253, txp =  330, typ =  277,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  351, tyn =  253, txp =  365, typ =  277,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  386, tyn =  253, txp =  400, typ =  277,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  421, tyn =  253, txp =  435, typ =  277,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  456, tyn =  253, txp =  470, typ =  277,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =    1, tyn =  289, txp =   15, typ =  313,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   36, tyn =  289, txp =   50, typ =  313,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   71, tyn =  289, txp =   85, typ =  313,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  106, tyn =  289, txp =  120, typ =  313,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  141, tyn =  289, txp =  155, typ =  313,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  176, tyn =  289, txp =  190, typ =  313,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  211, tyn =  289, txp =  225, typ =  313,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  246, tyn =  289, txp =  260, typ =  313,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  281, tyn =  289, txp =  295, typ =  313,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  316, tyn =  289, txp =  330, typ =  313,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  351, tyn =  289, txp =  365, typ =  313,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  386, tyn =  289, txp =  400, typ =  313,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  421, tyn =  289, txp =  435, typ =  313,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =  456, tyn =  289, txp =  470, typ =  313,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =    1, tyn =  325, txp =   15, typ =  349,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   36, tyn =  325, txp =   50, typ =  349,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   71, tyn =  325, txp =   85, typ =  349,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 10,
  oxn =   -1, oyn =   -8, oxp =    9, oyp =   19,
  txn =  106, tyn =  325, txp =  116, typ =  352,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 17,
  oxn =   -1, oyn =   -6, oxp =   18, oyp =   22,
  txn =  141, tyn =  325, txp =  160, typ =  353,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   19, oyp =   24,
  txn =  176, tyn =  325, txp =  197, typ =  352,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 17,
  oxn =   -2, oyn =    1, oxp =   18, oyp =   21,
  txn =  211, tyn =  325, txp =  231, typ =  345,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   24,
  txn =  246, tyn =  325, txp =  267, typ =  351,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 8,
  oxn =    1, oyn =   -8, oxp =    8, oyp =   24,
  txn =  281, tyn =  325, txp =  288, typ =  357,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 17,
  oxn =   -2, oyn =   -9, oxp =   18, oyp =   24,
  txn =  316, tyn =  325, txp =  336, typ =  358,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 10,
  oxn =   -2, oyn =   16, oxp =   12, oyp =   25,
  txn =  351, tyn =  325, txp =  365, typ =  334,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 22,
  oxn =   -3, oyn =   -3, oxp =   25, oyp =   25,
  txn =  386, tyn =  325, txp =  414, typ =  353,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 11,
  oxn =   -2, oyn =    5, oxp =   12, oyp =   24,
  txn =  421, tyn =  325, txp =  435, typ =  344,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 17,
  oxn =    0, oyn =    0, oxp =   17, oyp =   17,
  txn =  456, tyn =  325, txp =  473, typ =  342,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 18,
  oxn =   -1, oyn =    0, oxp =   19, oyp =   14,
  txn =    1, tyn =  361, txp =   21, typ =  375,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   22,
  txn =   36, tyn =  361, txp =   50, typ =  385,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 22,
  oxn =   -3, oyn =   -3, oxp =   25, oyp =   25,
  txn =   71, tyn =  361, txp =   99, typ =  389,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 10,
  oxn =   -2, oyn =   17, oxp =   12, oyp =   24,
  txn =  106, tyn =  361, txp =  120, typ =  368,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 18,
  oxn =    2, oyn =    9, oxp =   16, oyp =   23,
  txn =  141, tyn =  361, txp =  155, typ =  375,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   18, oyp =   21,
  txn =  176, tyn =  361, txp =  195, typ =  385,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 11,
  oxn =   -2, oyn =    6, oxp =   12, oyp =   24,
  txn =  211, tyn =  361, txp =  225, typ =  379,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 11,
  oxn =   -2, oyn =    6, oxp =   12, oyp =   24,
  txn =  246, tyn =  361, txp =  260, typ =  379,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 10,
  oxn =    1, oyn =   16, oxp =   12, oyp =   25,
  txn =  281, tyn =  361, txp =  292, typ =  370,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 18,
  oxn =   -1, oyn =   -9, oxp =   20, oyp =   19,
  txn =  316, tyn =  361, txp =  337, typ =  389,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 17,
  oxn =   -2, oyn =   -8, oxp =   18, oyp =   24,
  txn =  351, tyn =  361, txp =  371, typ =  393,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 8,
  oxn =   -1, oyn =    3, oxp =    8, oyp =   11,
  txn =  386, tyn =  361, txp =  395, typ =  369,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 10,
  oxn =   -2, oyn =   -9, oxp =   11, oyp =    2,
  txn =  421, tyn =  361, txp =  434, typ =  372,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 11,
  oxn =   -1, oyn =    6, oxp =   10, oyp =   24,
  txn =  456, tyn =  361, txp =  467, typ =  379,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 11,
  oxn =   -2, oyn =    5, oxp =   13, oyp =   24,
  txn =    1, tyn =  397, txp =   16, typ =  416,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 17,
  oxn =    0, oyn =    0, oxp =   16, oyp =   17,
  txn =   36, tyn =  397, txp =   52, typ =  414,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 26,
  oxn =   -1, oyn =   -3, oxp =   28, oyp =   24,
  txn =   71, tyn =  397, txp =  100, typ =  424,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 26,
  oxn =   -1, oyn =   -3, oxp =   28, oyp =   24,
  txn =  106, tyn =  397, txp =  135, typ =  424,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 26,
  oxn =   -2, oyn =   -3, oxp =   28, oyp =   24,
  txn =  141, tyn =  397, txp =  171, typ =  424,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 18,
  oxn =   -1, oyn =   -9, oxp =   19, oyp =   19,
  txn =  176, tyn =  397, txp =  196, typ =  425,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   30,
  txn =  211, tyn =  397, txp =  237, typ =  429,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   30,
  txn =  246, tyn =  397, txp =  272, typ =  429,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   30,
  txn =  281, tyn =  397, txp =  307, typ =  429,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   30,
  txn =  316, tyn =  397, txp =  342, typ =  429,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   30,
  txn =  351, tyn =  397, txp =  377, typ =  429,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   24, oyp =   31,
  txn =  386, tyn =  397, txp =  412, typ =  430,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 30,
  oxn =   -2, oyn =   -2, oxp =   31, oyp =   24,
  txn =  421, tyn =  397, txp =  454, typ =  423,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 22,
  oxn =   -1, oyn =   -9, oxp =   23, oyp =   25,
  txn =  456, tyn =  397, txp =  480, typ =  431,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   30,
  txn =    1, tyn =  433, txp =   22, typ =  465,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   30,
  txn =   36, tyn =  433, txp =   57, typ =  465,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   30,
  txn =   71, tyn =  433, txp =   92, typ =  465,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   30,
  txn =  106, tyn =  433, txp =  127, typ =  465,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 8,
  oxn =   -3, oyn =   -2, oxp =    9, oyp =   30,
  txn =  141, tyn =  433, txp =  153, typ =  465,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =   11, oyp =   30,
  txn =  176, tyn =  433, txp =  188, typ =  465,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 8,
  oxn =   -3, oyn =   -2, oxp =   11, oyp =   30,
  txn =  211, tyn =  433, txp =  225, typ =  465,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 8,
  oxn =   -3, oyn =   -2, oxp =   11, oyp =   30,
  txn =  246, tyn =  433, txp =  260, typ =  465,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 22,
  oxn =   -2, oyn =   -2, oxp =   23, oyp =   24,
  txn =  281, tyn =  433, txp =  306, typ =  459,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 22,
  oxn =    0, oyn =   -2, oxp =   22, oyp =   30,
  txn =  316, tyn =  433, txp =  338, typ =  465,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   25, oyp =   30,
  txn =  351, tyn =  433, txp =  377, typ =  466,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   25, oyp =   30,
  txn =  386, tyn =  433, txp =  412, typ =  466,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   25, oyp =   30,
  txn =  421, tyn =  433, txp =  447, typ =  466,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   25, oyp =   30,
  txn =  456, tyn =  433, txp =  482, typ =  466,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 23,
  oxn =   -1, oyn =   -3, oxp =   25, oyp =   30,
  txn =    1, tyn =  469, txp =   27, typ =  502,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 18,
  oxn =    0, oyn =   -2, oxp =   18, oyp =   16,
  txn =   36, tyn =  469, txp =   54, typ =  487,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 23,
  oxn =   -2, oyn =   -4, oxp =   25, oyp =   25,
  txn =   71, tyn =  469, txp =   98, typ =  498,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 22,
  oxn =    0, oyn =   -3, oxp =   22, oyp =   30,
  txn =  106, tyn =  469, txp =  128, typ =  502,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 22,
  oxn =    0, oyn =   -3, oxp =   22, oyp =   30,
  txn =  141, tyn =  469, txp =  163, typ =  502,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 22,
  oxn =    0, oyn =   -3, oxp =   22, oyp =   30,
  txn =  176, tyn =  469, txp =  198, typ =  502,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 22,
  oxn =    0, oyn =   -3, oxp =   22, oyp =   30,
  txn =  211, tyn =  469, txp =  233, typ =  502,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 20,
  oxn =   -2, oyn =   -2, oxp =   22, oyp =   30,
  txn =  246, tyn =  469, txp =  270, typ =  501,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 20,
  oxn =    0, oyn =   -2, oxp =   21, oyp =   24,
  txn =  281, tyn =  469, txp =  302, typ =  495,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 18,
  oxn =    0, oyn =   -3, oxp =   20, oyp =   24,
  txn =  316, tyn =  469, txp =  336, typ =  496,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  351, tyn =  469, txp =  371, typ =  497,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  386, tyn =  469, txp =  406, typ =  497,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  421, tyn =  469, txp =  441, typ =  497,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  456, tyn =  469, txp =  476, typ =  497,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =    1, tyn =  505, txp =   21, typ =  533,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   26,
  txn =   36, tyn =  505, txp =   56, typ =  534,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 27,
  oxn =   -2, oyn =   -3, oxp =   28, oyp =   19,
  txn =   71, tyn =  505, txp =  101, typ =  527,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 17,
  oxn =   -1, oyn =   -9, oxp =   18, oyp =   19,
  txn =  106, tyn =  505, txp =  125, typ =  533,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  141, tyn =  505, txp =  161, typ =  533,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  176, tyn =  505, txp =  196, typ =  533,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  211, tyn =  505, txp =  231, typ =  533,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 17,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   25,
  txn =  246, tyn =  505, txp =  266, typ =  533,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 8,
  oxn =   -3, oyn =   -2, oxp =    9, oyp =   25,
  txn =  281, tyn =  505, txp =  293, typ =  532,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 8,
  oxn =    0, oyn =   -2, oxp =   11, oyp =   25,
  txn =  316, tyn =  505, txp =  327, typ =  532,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 8,
  oxn =   -3, oyn =   -2, oxp =   11, oyp =   25,
  txn =  351, tyn =  505, txp =  365, typ =  532,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 8,
  oxn =   -3, oyn =   -2, oxp =   11, oyp =   25,
  txn =  386, tyn =  505, txp =  400, typ =  532,
}
glyphs[240] = { --''--
  num = 240,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   25,
  txn =  421, tyn =  505, txp =  442, typ =  533,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 18,
  oxn =   -1, oyn =   -2, oxp =   19, oyp =   25,
  txn =  456, tyn =  505, txp =  476, typ =  532,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   25,
  txn =    1, tyn =  541, txp =   22, typ =  569,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   25,
  txn =   36, tyn =  541, txp =   57, typ =  569,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   25,
  txn =   71, tyn =  541, txp =   92, typ =  569,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   25,
  txn =  106, tyn =  541, txp =  127, typ =  569,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   20, oyp =   25,
  txn =  141, tyn =  541, txp =  162, typ =  569,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   17,
  txn =  176, tyn =  541, txp =  196, typ =  561,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 18,
  oxn =   -2, oyn =   -4, oxp =   20, oyp =   19,
  txn =  211, tyn =  541, txp =  233, typ =  564,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   25,
  txn =  246, tyn =  541, txp =  266, typ =  569,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   25,
  txn =  281, tyn =  541, txp =  301, typ =  569,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   25,
  txn =  316, tyn =  541, txp =  336, typ =  569,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 18,
  oxn =   -1, oyn =   -3, oxp =   19, oyp =   25,
  txn =  351, tyn =  541, txp =  371, typ =  569,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 17,
  oxn =   -2, oyn =   -9, oxp =   19, oyp =   25,
  txn =  386, tyn =  541, txp =  407, typ =  575,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 18,
  oxn =   -1, oyn =   -9, oxp =   20, oyp =   24,
  txn =  421, tyn =  541, txp =  442, typ =  574,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 17,
  oxn =   -2, oyn =   -9, oxp =   19, oyp =   25,
  txn =  456, tyn =  541, txp =  477, typ =  575,
}

fontSpecs.glyphs = glyphs

return fontSpecs

