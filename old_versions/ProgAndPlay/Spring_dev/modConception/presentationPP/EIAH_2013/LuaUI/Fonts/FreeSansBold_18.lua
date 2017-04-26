
local fontSpecs = {
  srcFile  = [[FreeSansBold.ttf]],
  family   = [[FreeSans]],
  style    = [[Bold]],
  yStep    = 19,
  height   = 18,
  xTexSize = 512,
  yTexSize = 512,
  outlineRadius = 2,
  outlineWeight = 100,
}

local glyphs = {}

glyphs[32] = { --' '--
  num = 32,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    3, oyp =    2,
  txn =    1, tyn =    1, txp =    6, typ =    6,
}
glyphs[33] = { --'!'--
  num = 33,
  adv = 6,
  oxn =    0, oyn =   -2, oxp =    7, oyp =   16,
  txn =   25, tyn =    1, txp =   32, typ =   19,
}
glyphs[34] = { --'"'--
  num = 34,
  adv = 9,
  oxn =   -2, oyn =    6, oxp =   10, oyp =   16,
  txn =   49, tyn =    1, txp =   61, typ =   11,
}
glyphs[35] = { --'#'--
  num = 35,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   15,
  txn =   73, tyn =    1, txp =   87, typ =   19,
}
glyphs[36] = { --'$'--
  num = 36,
  adv = 10,
  oxn =   -2, oyn =   -5, oxp =   12, oyp =   16,
  txn =   97, tyn =    1, txp =  111, typ =   22,
}
glyphs[37] = { --'%'--
  num = 37,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   15,
  txn =  121, tyn =    1, txp =  141, typ =   19,
}
glyphs[38] = { --'&'--
  num = 38,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =  145, tyn =    1, txp =  162, typ =   20,
}
glyphs[39] = { --'''--
  num = 39,
  adv = 4,
  oxn =   -2, oyn =    6, oxp =    6, oyp =   16,
  txn =  169, tyn =    1, txp =  177, typ =   11,
}
glyphs[40] = { --'('--
  num = 40,
  adv = 6,
  oxn =   -2, oyn =   -6, oxp =    8, oyp =   16,
  txn =  193, tyn =    1, txp =  203, typ =   23,
}
glyphs[41] = { --')'--
  num = 41,
  adv = 6,
  oxn =   -2, oyn =   -6, oxp =    8, oyp =   16,
  txn =  217, tyn =    1, txp =  227, typ =   23,
}
glyphs[42] = { --'*'--
  num = 42,
  adv = 7,
  oxn =   -2, oyn =    5, oxp =    9, oyp =   16,
  txn =  241, tyn =    1, txp =  252, typ =   12,
}
glyphs[43] = { --'+'--
  num = 43,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   11,
  txn =  265, tyn =    1, txp =  279, typ =   15,
}
glyphs[44] = { --','--
  num = 44,
  adv = 5,
  oxn =   -1, oyn =   -6, oxp =    6, oyp =    5,
  txn =  289, tyn =    1, txp =  296, typ =   12,
}
glyphs[45] = { --'-'--
  num = 45,
  adv = 6,
  oxn =   -2, oyn =    1, oxp =    8, oyp =    9,
  txn =  313, tyn =    1, txp =  323, typ =    9,
}
glyphs[46] = { --'.'--
  num = 46,
  adv = 5,
  oxn =   -1, oyn =   -2, oxp =    6, oyp =    5,
  txn =  337, tyn =    1, txp =  344, typ =    8,
}
glyphs[47] = { --'/'--
  num = 47,
  adv = 5,
  oxn =   -2, oyn =   -3, oxp =    7, oyp =   15,
  txn =  361, tyn =    1, txp =  370, typ =   19,
}
glyphs[48] = { --'0'--
  num = 48,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  385, tyn =    1, txp =  399, typ =   20,
}
glyphs[49] = { --'1'--
  num = 49,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   15,
  txn =  409, tyn =    1, txp =  419, typ =   18,
}
glyphs[50] = { --'2'--
  num = 50,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   16,
  txn =  433, tyn =    1, txp =  447, typ =   19,
}
glyphs[51] = { --'3'--
  num = 51,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  457, tyn =    1, txp =  471, typ =   20,
}
glyphs[52] = { --'4'--
  num = 52,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   15,
  txn =  481, tyn =    1, txp =  495, typ =   18,
}
glyphs[53] = { --'5'--
  num = 53,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   15,
  txn =    1, tyn =   25, txp =   15, typ =   43,
}
glyphs[54] = { --'6'--
  num = 54,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =   25, tyn =   25, txp =   39, typ =   44,
}
glyphs[55] = { --'7'--
  num = 55,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   15,
  txn =   49, tyn =   25, txp =   63, typ =   42,
}
glyphs[56] = { --'8'--
  num = 56,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =   73, tyn =   25, txp =   87, typ =   44,
}
glyphs[57] = { --'9'--
  num = 57,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =   97, tyn =   25, txp =  111, typ =   44,
}
glyphs[58] = { --':'--
  num = 58,
  adv = 6,
  oxn =    0, oyn =   -2, oxp =    7, oyp =   12,
  txn =  121, tyn =   25, txp =  128, typ =   39,
}
glyphs[59] = { --';'--
  num = 59,
  adv = 6,
  oxn =    0, oyn =   -6, oxp =    7, oyp =   12,
  txn =  145, tyn =   25, txp =  152, typ =   43,
}
glyphs[60] = { --'<'--
  num = 60,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   11,
  txn =  169, tyn =   25, txp =  183, typ =   39,
}
glyphs[61] = { --'='--
  num = 61,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   10,
  txn =  193, tyn =   25, txp =  207, typ =   37,
}
glyphs[62] = { --'>'--
  num = 62,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   11,
  txn =  217, tyn =   25, txp =  231, typ =   39,
}
glyphs[63] = { --'?'--
  num = 63,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   16,
  txn =  241, tyn =   25, txp =  255, typ =   43,
}
glyphs[64] = { --'@'--
  num = 64,
  adv = 18,
  oxn =   -2, oyn =   -5, oxp =   20, oyp =   16,
  txn =  265, tyn =   25, txp =  287, typ =   46,
}
glyphs[65] = { --'A'--
  num = 65,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   16,
  txn =  289, tyn =   25, txp =  306, typ =   43,
}
glyphs[66] = { --'B'--
  num = 66,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   16,
  txn =  313, tyn =   25, txp =  328, typ =   43,
}
glyphs[67] = { --'C'--
  num = 67,
  adv = 13,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =  337, tyn =   25, txp =  354, typ =   44,
}
glyphs[68] = { --'D'--
  num = 68,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   16,
  txn =  361, tyn =   25, txp =  377, typ =   43,
}
glyphs[69] = { --'E'--
  num = 69,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   16,
  txn =  385, tyn =   25, txp =  400, typ =   43,
}
glyphs[70] = { --'F'--
  num = 70,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   16,
  txn =  409, tyn =   25, txp =  423, typ =   43,
}
glyphs[71] = { --'G'--
  num = 71,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   15, oyp =   16,
  txn =  433, tyn =   25, txp =  450, typ =   44,
}
glyphs[72] = { --'H'--
  num = 72,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   16,
  txn =  457, tyn =   25, txp =  472, typ =   43,
}
glyphs[73] = { --'I'--
  num = 73,
  adv = 5,
  oxn =   -1, oyn =   -2, oxp =    6, oyp =   16,
  txn =  481, tyn =   25, txp =  488, typ =   43,
}
glyphs[74] = { --'J'--
  num = 74,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   11, oyp =   16,
  txn =    1, tyn =   49, txp =   14, typ =   68,
}
glyphs[75] = { --'K'--
  num = 75,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   16,
  txn =   25, tyn =   49, txp =   41, typ =   67,
}
glyphs[76] = { --'L'--
  num = 76,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   13, oyp =   16,
  txn =   49, tyn =   49, txp =   63, typ =   67,
}
glyphs[77] = { --'M'--
  num = 77,
  adv = 15,
  oxn =   -1, oyn =   -2, oxp =   16, oyp =   16,
  txn =   73, tyn =   49, txp =   90, typ =   67,
}
glyphs[78] = { --'N'--
  num = 78,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   16,
  txn =   97, tyn =   49, txp =  112, typ =   67,
}
glyphs[79] = { --'O'--
  num = 79,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   16,
  txn =  121, tyn =   49, txp =  139, typ =   68,
}
glyphs[80] = { --'P'--
  num = 80,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   16,
  txn =  145, tyn =   49, txp =  160, typ =   67,
}
glyphs[81] = { --'Q'--
  num = 81,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   16,
  txn =  169, tyn =   49, txp =  187, typ =   68,
}
glyphs[82] = { --'R'--
  num = 82,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   15, oyp =   16,
  txn =  193, tyn =   49, txp =  209, typ =   67,
}
glyphs[83] = { --'S'--
  num = 83,
  adv = 12,
  oxn =   -2, oyn =   -3, oxp =   14, oyp =   16,
  txn =  217, tyn =   49, txp =  233, typ =   68,
}
glyphs[84] = { --'T'--
  num = 84,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   16,
  txn =  241, tyn =   49, txp =  256, typ =   67,
}
glyphs[85] = { --'U'--
  num = 85,
  adv = 13,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   16,
  txn =  265, tyn =   49, txp =  280, typ =   68,
}
glyphs[86] = { --'V'--
  num = 86,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   16,
  txn =  289, tyn =   49, txp =  305, typ =   67,
}
glyphs[87] = { --'W'--
  num = 87,
  adv = 17,
  oxn =   -2, oyn =   -2, oxp =   19, oyp =   16,
  txn =  313, tyn =   49, txp =  334, typ =   67,
}
glyphs[88] = { --'X'--
  num = 88,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   16,
  txn =  337, tyn =   49, txp =  353, typ =   67,
}
glyphs[89] = { --'Y'--
  num = 89,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   16,
  txn =  361, tyn =   49, txp =  377, typ =   67,
}
glyphs[90] = { --'Z'--
  num = 90,
  adv = 11,
  oxn =   -2, oyn =   -2, oxp =   13, oyp =   16,
  txn =  385, tyn =   49, txp =  400, typ =   67,
}
glyphs[91] = { --'['--
  num = 91,
  adv = 6,
  oxn =   -1, oyn =   -6, oxp =    8, oyp =   16,
  txn =  409, tyn =   49, txp =  418, typ =   71,
}
glyphs[92] = { --'\'--
  num = 92,
  adv = 5,
  oxn =   -3, oyn =   -3, oxp =    8, oyp =   15,
  txn =  433, tyn =   49, txp =  444, typ =   67,
}
glyphs[93] = { --']'--
  num = 93,
  adv = 6,
  oxn =   -2, oyn =   -6, oxp =    7, oyp =   16,
  txn =  457, tyn =   49, txp =  466, typ =   71,
}
glyphs[94] = { --'^'--
  num = 94,
  adv = 11,
  oxn =   -1, oyn =    2, oxp =   12, oyp =   15,
  txn =  481, tyn =   49, txp =  494, typ =   62,
}
glyphs[95] = { --'_'--
  num = 95,
  adv = 10,
  oxn =   -3, oyn =   -6, oxp =   13, oyp =    0,
  txn =    1, tyn =   73, txp =   17, typ =   79,
}
glyphs[96] = { --'`'--
  num = 96,
  adv = 6,
  oxn =   -2, oyn =    8, oxp =    6, oyp =   16,
  txn =   25, tyn =   73, txp =   33, typ =   81,
}
glyphs[97] = { --'a'--
  num = 97,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   12,
  txn =   49, tyn =   73, txp =   63, typ =   88,
}
glyphs[98] = { --'b'--
  num = 98,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   16,
  txn =   73, tyn =   73, txp =   87, typ =   92,
}
glyphs[99] = { --'c'--
  num = 99,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   12,
  txn =   97, tyn =   73, txp =  111, typ =   88,
}
glyphs[100] = { --'d'--
  num = 100,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  121, tyn =   73, txp =  135, typ =   92,
}
glyphs[101] = { --'e'--
  num = 101,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   12,
  txn =  145, tyn =   73, txp =  159, typ =   88,
}
glyphs[102] = { --'f'--
  num = 102,
  adv = 6,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   16,
  txn =  169, tyn =   73, txp =  179, typ =   91,
}
glyphs[103] = { --'g'--
  num = 103,
  adv = 11,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   12,
  txn =  193, tyn =   73, txp =  207, typ =   91,
}
glyphs[104] = { --'h'--
  num = 104,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   12, oyp =   16,
  txn =  217, tyn =   73, txp =  230, typ =   91,
}
glyphs[105] = { --'i'--
  num = 105,
  adv = 5,
  oxn =   -1, oyn =   -2, oxp =    6, oyp =   16,
  txn =  241, tyn =   73, txp =  248, typ =   91,
}
glyphs[106] = { --'j'--
  num = 106,
  adv = 5,
  oxn =   -2, oyn =   -6, oxp =    6, oyp =   16,
  txn =  265, tyn =   73, txp =  273, typ =   95,
}
glyphs[107] = { --'k'--
  num = 107,
  adv = 10,
  oxn =   -1, oyn =   -2, oxp =   12, oyp =   16,
  txn =  289, tyn =   73, txp =  302, typ =   91,
}
glyphs[108] = { --'l'--
  num = 108,
  adv = 5,
  oxn =   -1, oyn =   -2, oxp =    6, oyp =   16,
  txn =  313, tyn =   73, txp =  320, typ =   91,
}
glyphs[109] = { --'m'--
  num = 109,
  adv = 16,
  oxn =   -1, oyn =   -2, oxp =   17, oyp =   12,
  txn =  337, tyn =   73, txp =  355, typ =   87,
}
glyphs[110] = { --'n'--
  num = 110,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   12, oyp =   12,
  txn =  361, tyn =   73, txp =  374, typ =   87,
}
glyphs[111] = { --'o'--
  num = 111,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   12,
  txn =  385, tyn =   73, txp =  400, typ =   88,
}
glyphs[112] = { --'p'--
  num = 112,
  adv = 11,
  oxn =   -1, oyn =   -6, oxp =   13, oyp =   12,
  txn =  409, tyn =   73, txp =  423, typ =   91,
}
glyphs[113] = { --'q'--
  num = 113,
  adv = 11,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   12,
  txn =  433, tyn =   73, txp =  447, typ =   91,
}
glyphs[114] = { --'r'--
  num = 114,
  adv = 7,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   12,
  txn =  457, tyn =   73, txp =  467, typ =   87,
}
glyphs[115] = { --'s'--
  num = 115,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   12,
  txn =  481, tyn =   73, txp =  495, typ =   88,
}
glyphs[116] = { --'t'--
  num = 116,
  adv = 6,
  oxn =   -2, oyn =   -3, oxp =    8, oyp =   15,
  txn =    1, tyn =   97, txp =   11, typ =  115,
}
glyphs[117] = { --'u'--
  num = 117,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   12, oyp =   12,
  txn =   25, tyn =   97, txp =   38, typ =  112,
}
glyphs[118] = { --'v'--
  num = 118,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   12,
  txn =   49, tyn =   97, txp =   63, typ =  111,
}
glyphs[119] = { --'w'--
  num = 119,
  adv = 14,
  oxn =   -2, oyn =   -2, oxp =   16, oyp =   12,
  txn =   73, tyn =   97, txp =   91, typ =  111,
}
glyphs[120] = { --'x'--
  num = 120,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   12,
  txn =   97, tyn =   97, txp =  111, typ =  111,
}
glyphs[121] = { --'y'--
  num = 121,
  adv = 10,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   12,
  txn =  121, tyn =   97, txp =  135, typ =  115,
}
glyphs[122] = { --'z'--
  num = 122,
  adv = 9,
  oxn =   -2, oyn =   -2, oxp =   11, oyp =   12,
  txn =  145, tyn =   97, txp =  158, typ =  111,
}
glyphs[123] = { --'{'--
  num = 123,
  adv = 7,
  oxn =   -2, oyn =   -6, oxp =    8, oyp =   16,
  txn =  169, tyn =   97, txp =  179, typ =  119,
}
glyphs[124] = { --'|'--
  num = 124,
  adv = 5,
  oxn =   -1, oyn =   -6, oxp =    6, oyp =   16,
  txn =  193, tyn =   97, txp =  200, typ =  119,
}
glyphs[125] = { --'}'--
  num = 125,
  adv = 7,
  oxn =   -1, oyn =   -6, oxp =    9, oyp =   16,
  txn =  217, tyn =   97, txp =  227, typ =  119,
}
glyphs[126] = { --'~'--
  num = 126,
  adv = 11,
  oxn =   -1, oyn =    0, oxp =   12, oyp =    8,
  txn =  241, tyn =   97, txp =  254, typ =  105,
}
glyphs[127] = { --''--
  num = 127,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  265, tyn =   97, txp =  275, typ =  113,
}
glyphs[128] = { --'Ä'--
  num = 128,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  289, tyn =   97, txp =  299, typ =  113,
}
glyphs[129] = { --'Å'--
  num = 129,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  313, tyn =   97, txp =  323, typ =  113,
}
glyphs[130] = { --'Ç'--
  num = 130,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  337, tyn =   97, txp =  347, typ =  113,
}
glyphs[131] = { --'É'--
  num = 131,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  361, tyn =   97, txp =  371, typ =  113,
}
glyphs[132] = { --'Ñ'--
  num = 132,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  385, tyn =   97, txp =  395, typ =  113,
}
glyphs[133] = { --'Ö'--
  num = 133,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  409, tyn =   97, txp =  419, typ =  113,
}
glyphs[134] = { --'Ü'--
  num = 134,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  433, tyn =   97, txp =  443, typ =  113,
}
glyphs[135] = { --'á'--
  num = 135,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  457, tyn =   97, txp =  467, typ =  113,
}
glyphs[136] = { --'à'--
  num = 136,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  481, tyn =   97, txp =  491, typ =  113,
}
glyphs[137] = { --'â'--
  num = 137,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =    1, tyn =  121, txp =   11, typ =  137,
}
glyphs[138] = { --'ä'--
  num = 138,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =   25, tyn =  121, txp =   35, typ =  137,
}
glyphs[139] = { --'ã'--
  num = 139,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =   49, tyn =  121, txp =   59, typ =  137,
}
glyphs[140] = { --'å'--
  num = 140,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =   73, tyn =  121, txp =   83, typ =  137,
}
glyphs[141] = { --'ç'--
  num = 141,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =   97, tyn =  121, txp =  107, typ =  137,
}
glyphs[142] = { --'é'--
  num = 142,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  121, tyn =  121, txp =  131, typ =  137,
}
glyphs[143] = { --'è'--
  num = 143,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  145, tyn =  121, txp =  155, typ =  137,
}
glyphs[144] = { --'ê'--
  num = 144,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  169, tyn =  121, txp =  179, typ =  137,
}
glyphs[145] = { --'ë'--
  num = 145,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  193, tyn =  121, txp =  203, typ =  137,
}
glyphs[146] = { --'í'--
  num = 146,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  217, tyn =  121, txp =  227, typ =  137,
}
glyphs[147] = { --'ì'--
  num = 147,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  241, tyn =  121, txp =  251, typ =  137,
}
glyphs[148] = { --'î'--
  num = 148,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  265, tyn =  121, txp =  275, typ =  137,
}
glyphs[149] = { --'ï'--
  num = 149,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  289, tyn =  121, txp =  299, typ =  137,
}
glyphs[150] = { --'ñ'--
  num = 150,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  313, tyn =  121, txp =  323, typ =  137,
}
glyphs[151] = { --'ó'--
  num = 151,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  337, tyn =  121, txp =  347, typ =  137,
}
glyphs[152] = { --'ò'--
  num = 152,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  361, tyn =  121, txp =  371, typ =  137,
}
glyphs[153] = { --'ô'--
  num = 153,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  385, tyn =  121, txp =  395, typ =  137,
}
glyphs[154] = { --'ö'--
  num = 154,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  409, tyn =  121, txp =  419, typ =  137,
}
glyphs[155] = { --'õ'--
  num = 155,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  433, tyn =  121, txp =  443, typ =  137,
}
glyphs[156] = { --'ú'--
  num = 156,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  457, tyn =  121, txp =  467, typ =  137,
}
glyphs[157] = { --'ù'--
  num = 157,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  481, tyn =  121, txp =  491, typ =  137,
}
glyphs[158] = { --'û'--
  num = 158,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =    1, tyn =  145, txp =   11, typ =  161,
}
glyphs[159] = { --'ü'--
  num = 159,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =   25, tyn =  145, txp =   35, typ =  161,
}
glyphs[160] = { --'†'--
  num = 160,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =   49, tyn =  145, txp =   59, typ =  161,
}
glyphs[161] = { --'°'--
  num = 161,
  adv = 6,
  oxn =   -1, oyn =   -6, oxp =    6, oyp =   12,
  txn =   73, tyn =  145, txp =   80, typ =  163,
}
glyphs[162] = { --'¢'--
  num = 162,
  adv = 10,
  oxn =   -2, oyn =   -5, oxp =   12, oyp =   14,
  txn =   97, tyn =  145, txp =  111, typ =  164,
}
glyphs[163] = { --'£'--
  num = 163,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   15,
  txn =  121, tyn =  145, txp =  135, typ =  163,
}
glyphs[164] = { --'§'--
  num = 164,
  adv = 10,
  oxn =   -2, oyn =   -1, oxp =   12, oyp =   13,
  txn =  145, tyn =  145, txp =  159, typ =  159,
}
glyphs[165] = { --'•'--
  num = 165,
  adv = 10,
  oxn =   -2, oyn =   -2, oxp =   12, oyp =   15,
  txn =  169, tyn =  145, txp =  183, typ =  162,
}
glyphs[166] = { --'¶'--
  num = 166,
  adv = 5,
  oxn =   -1, oyn =   -6, oxp =    6, oyp =   16,
  txn =  193, tyn =  145, txp =  200, typ =  167,
}
glyphs[167] = { --'ß'--
  num = 167,
  adv = 10,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   16,
  txn =  217, tyn =  145, txp =  231, typ =  167,
}
glyphs[168] = { --'®'--
  num = 168,
  adv = 6,
  oxn =   -2, oyn =    9, oxp =    8, oyp =   16,
  txn =  241, tyn =  145, txp =  251, typ =  152,
}
glyphs[169] = { --'©'--
  num = 169,
  adv = 13,
  oxn =   -3, oyn =   -3, oxp =   16, oyp =   16,
  txn =  265, tyn =  145, txp =  284, typ =  164,
}
glyphs[170] = { --'™'--
  num = 170,
  adv = 7,
  oxn =   -2, oyn =    2, oxp =    8, oyp =   16,
  txn =  289, tyn =  145, txp =  299, typ =  159,
}
glyphs[171] = { --'´'--
  num = 171,
  adv = 10,
  oxn =   -1, oyn =   -1, oxp =   11, oyp =   11,
  txn =  313, tyn =  145, txp =  325, typ =  157,
}
glyphs[172] = { --'¨'--
  num = 172,
  adv = 11,
  oxn =   -2, oyn =   -1, oxp =   12, oyp =    9,
  txn =  337, tyn =  145, txp =  351, typ =  155,
}
glyphs[173] = { --'≠'--
  num = 173,
  adv = 8,
  oxn =   -1, oyn =   -2, oxp =    9, oyp =   14,
  txn =  361, tyn =  145, txp =  371, typ =  161,
}
glyphs[174] = { --'Æ'--
  num = 174,
  adv = 13,
  oxn =   -3, oyn =   -3, oxp =   16, oyp =   16,
  txn =  385, tyn =  145, txp =  404, typ =  164,
}
glyphs[175] = { --'Ø'--
  num = 175,
  adv = 6,
  oxn =   -2, oyn =    9, oxp =    8, oyp =   15,
  txn =  409, tyn =  145, txp =  419, typ =  151,
}
glyphs[176] = { --'∞'--
  num = 176,
  adv = 11,
  oxn =    0, oyn =    4, oxp =   11, oyp =   15,
  txn =  433, tyn =  145, txp =  444, typ =  156,
}
glyphs[177] = { --'±'--
  num = 177,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   12, oyp =   13,
  txn =  457, tyn =  145, txp =  470, typ =  161,
}
glyphs[178] = { --'≤'--
  num = 178,
  adv = 6,
  oxn =   -2, oyn =    3, oxp =    8, oyp =   15,
  txn =  481, tyn =  145, txp =  491, typ =  157,
}
glyphs[179] = { --'≥'--
  num = 179,
  adv = 6,
  oxn =   -2, oyn =    2, oxp =    8, oyp =   15,
  txn =    1, tyn =  169, txp =   11, typ =  182,
}
glyphs[180] = { --'¥'--
  num = 180,
  adv = 6,
  oxn =    0, oyn =    8, oxp =    8, oyp =   16,
  txn =   25, tyn =  169, txp =   33, typ =  177,
}
glyphs[181] = { --'µ'--
  num = 181,
  adv = 11,
  oxn =   -1, oyn =   -6, oxp =   13, oyp =   12,
  txn =   49, tyn =  169, txp =   63, typ =  187,
}
glyphs[182] = { --'∂'--
  num = 182,
  adv = 10,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   16,
  txn =   73, tyn =  169, txp =   87, typ =  191,
}
glyphs[183] = { --'∑'--
  num = 183,
  adv = 5,
  oxn =   -1, oyn =    1, oxp =    6, oyp =    8,
  txn =   97, tyn =  169, txp =  104, typ =  176,
}
glyphs[184] = { --'∏'--
  num = 184,
  adv = 6,
  oxn =   -2, oyn =   -6, oxp =    8, oyp =    2,
  txn =  121, tyn =  169, txp =  131, typ =  177,
}
glyphs[185] = { --'π'--
  num = 185,
  adv = 6,
  oxn =   -2, oyn =    3, oxp =    7, oyp =   15,
  txn =  145, tyn =  169, txp =  154, typ =  181,
}
glyphs[186] = { --'∫'--
  num = 186,
  adv = 7,
  oxn =   -2, oyn =    2, oxp =    9, oyp =   16,
  txn =  169, tyn =  169, txp =  180, typ =  183,
}
glyphs[187] = { --'ª'--
  num = 187,
  adv = 10,
  oxn =   -1, oyn =   -1, oxp =   11, oyp =   11,
  txn =  193, tyn =  169, txp =  205, typ =  181,
}
glyphs[188] = { --'º'--
  num = 188,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   15,
  txn =  217, tyn =  169, txp =  237, typ =  187,
}
glyphs[189] = { --'Ω'--
  num = 189,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   15,
  txn =  241, tyn =  169, txp =  261, typ =  187,
}
glyphs[190] = { --'æ'--
  num = 190,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   15,
  txn =  265, tyn =  169, txp =  285, typ =  187,
}
glyphs[191] = { --'ø'--
  num = 191,
  adv = 11,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   12,
  txn =  289, tyn =  169, txp =  303, typ =  187,
}
glyphs[192] = { --'¿'--
  num = 192,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   19,
  txn =  313, tyn =  169, txp =  330, typ =  190,
}
glyphs[193] = { --'¡'--
  num = 193,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   19,
  txn =  337, tyn =  169, txp =  354, typ =  190,
}
glyphs[194] = { --'¬'--
  num = 194,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   19,
  txn =  361, tyn =  169, txp =  378, typ =  190,
}
glyphs[195] = { --'√'--
  num = 195,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   19,
  txn =  385, tyn =  169, txp =  402, typ =  190,
}
glyphs[196] = { --'ƒ'--
  num = 196,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   19,
  txn =  409, tyn =  169, txp =  426, typ =  190,
}
glyphs[197] = { --'≈'--
  num = 197,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   19,
  txn =  433, tyn =  169, txp =  450, typ =  190,
}
glyphs[198] = { --'∆'--
  num = 198,
  adv = 18,
  oxn =   -2, oyn =   -2, oxp =   20, oyp =   16,
  txn =  457, tyn =  169, txp =  479, typ =  187,
}
glyphs[199] = { --'«'--
  num = 199,
  adv = 13,
  oxn =   -2, oyn =   -6, oxp =   15, oyp =   16,
  txn =  481, tyn =  169, txp =  498, typ =  191,
}
glyphs[200] = { --'»'--
  num = 200,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   19,
  txn =    1, tyn =  193, txp =   16, typ =  214,
}
glyphs[201] = { --'…'--
  num = 201,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   19,
  txn =   25, tyn =  193, txp =   40, typ =  214,
}
glyphs[202] = { --' '--
  num = 202,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   19,
  txn =   49, tyn =  193, txp =   64, typ =  214,
}
glyphs[203] = { --'À'--
  num = 203,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   19,
  txn =   73, tyn =  193, txp =   88, typ =  214,
}
glyphs[204] = { --'Ã'--
  num = 204,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   19,
  txn =   97, tyn =  193, txp =  105, typ =  214,
}
glyphs[205] = { --'Õ'--
  num = 205,
  adv = 5,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =   19,
  txn =  121, tyn =  193, txp =  130, typ =  214,
}
glyphs[206] = { --'Œ'--
  num = 206,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   19,
  txn =  145, tyn =  193, txp =  155, typ =  214,
}
glyphs[207] = { --'œ'--
  num = 207,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   19,
  txn =  169, tyn =  193, txp =  179, typ =  214,
}
glyphs[208] = { --'–'--
  num = 208,
  adv = 13,
  oxn =   -2, oyn =   -2, oxp =   15, oyp =   16,
  txn =  193, tyn =  193, txp =  210, typ =  211,
}
glyphs[209] = { --'—'--
  num = 209,
  adv = 13,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   19,
  txn =  217, tyn =  193, txp =  232, typ =  214,
}
glyphs[210] = { --'“'--
  num = 210,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   19,
  txn =  241, tyn =  193, txp =  259, typ =  215,
}
glyphs[211] = { --'”'--
  num = 211,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   19,
  txn =  265, tyn =  193, txp =  283, typ =  215,
}
glyphs[212] = { --'‘'--
  num = 212,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   19,
  txn =  289, tyn =  193, txp =  307, typ =  215,
}
glyphs[213] = { --'’'--
  num = 213,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   19,
  txn =  313, tyn =  193, txp =  331, typ =  215,
}
glyphs[214] = { --'÷'--
  num = 214,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   19,
  txn =  337, tyn =  193, txp =  355, typ =  215,
}
glyphs[215] = { --'◊'--
  num = 215,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   12, oyp =   10,
  txn =  361, tyn =  193, txp =  374, typ =  205,
}
glyphs[216] = { --'ÿ'--
  num = 216,
  adv = 14,
  oxn =   -2, oyn =   -3, oxp =   16, oyp =   16,
  txn =  385, tyn =  193, txp =  403, typ =  212,
}
glyphs[217] = { --'Ÿ'--
  num = 217,
  adv = 13,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   19,
  txn =  409, tyn =  193, txp =  424, typ =  215,
}
glyphs[218] = { --'⁄'--
  num = 218,
  adv = 13,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   19,
  txn =  433, tyn =  193, txp =  448, typ =  215,
}
glyphs[219] = { --'€'--
  num = 219,
  adv = 13,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   19,
  txn =  457, tyn =  193, txp =  472, typ =  215,
}
glyphs[220] = { --'‹'--
  num = 220,
  adv = 13,
  oxn =   -1, oyn =   -3, oxp =   14, oyp =   19,
  txn =  481, tyn =  193, txp =  496, typ =  215,
}
glyphs[221] = { --'›'--
  num = 221,
  adv = 12,
  oxn =   -2, oyn =   -2, oxp =   14, oyp =   19,
  txn =    1, tyn =  217, txp =   17, typ =  238,
}
glyphs[222] = { --'ﬁ'--
  num = 222,
  adv = 12,
  oxn =   -1, oyn =   -2, oxp =   14, oyp =   16,
  txn =   25, tyn =  217, txp =   40, typ =  235,
}
glyphs[223] = { --'ﬂ'--
  num = 223,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   13, oyp =   16,
  txn =   49, tyn =  217, txp =   63, typ =  236,
}
glyphs[224] = { --'‡'--
  num = 224,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =   73, tyn =  217, txp =   87, typ =  236,
}
glyphs[225] = { --'·'--
  num = 225,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =   97, tyn =  217, txp =  111, typ =  236,
}
glyphs[226] = { --'‚'--
  num = 226,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  121, tyn =  217, txp =  135, typ =  236,
}
glyphs[227] = { --'„'--
  num = 227,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  145, tyn =  217, txp =  159, typ =  236,
}
glyphs[228] = { --'‰'--
  num = 228,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  169, tyn =  217, txp =  183, typ =  236,
}
glyphs[229] = { --'Â'--
  num = 229,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  193, tyn =  217, txp =  207, typ =  236,
}
glyphs[230] = { --'Ê'--
  num = 230,
  adv = 16,
  oxn =   -2, oyn =   -3, oxp =   18, oyp =   12,
  txn =  217, tyn =  217, txp =  237, typ =  232,
}
glyphs[231] = { --'Á'--
  num = 231,
  adv = 10,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   12,
  txn =  241, tyn =  217, txp =  255, typ =  235,
}
glyphs[232] = { --'Ë'--
  num = 232,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  265, tyn =  217, txp =  279, typ =  236,
}
glyphs[233] = { --'È'--
  num = 233,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  289, tyn =  217, txp =  303, typ =  236,
}
glyphs[234] = { --'Í'--
  num = 234,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  313, tyn =  217, txp =  327, typ =  236,
}
glyphs[235] = { --'Î'--
  num = 235,
  adv = 10,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   16,
  txn =  337, tyn =  217, txp =  351, typ =  236,
}
glyphs[236] = { --'Ï'--
  num = 236,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    6, oyp =   16,
  txn =  361, tyn =  217, txp =  369, typ =  235,
}
glyphs[237] = { --'Ì'--
  num = 237,
  adv = 5,
  oxn =   -1, oyn =   -2, oxp =    8, oyp =   16,
  txn =  385, tyn =  217, txp =  394, typ =  235,
}
glyphs[238] = { --'Ó'--
  num = 238,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   16,
  txn =  409, tyn =  217, txp =  419, typ =  235,
}
glyphs[239] = { --'Ô'--
  num = 239,
  adv = 5,
  oxn =   -2, oyn =   -2, oxp =    8, oyp =   16,
  txn =  433, tyn =  217, txp =  443, typ =  235,
}
glyphs[240] = { --''--
  num = 240,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   16,
  txn =  457, tyn =  217, txp =  472, typ =  236,
}
glyphs[241] = { --'Ò'--
  num = 241,
  adv = 11,
  oxn =   -1, oyn =   -2, oxp =   12, oyp =   16,
  txn =  481, tyn =  217, txp =  494, typ =  235,
}
glyphs[242] = { --'Ú'--
  num = 242,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   16,
  txn =    1, tyn =  241, txp =   16, typ =  260,
}
glyphs[243] = { --'Û'--
  num = 243,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   16,
  txn =   25, tyn =  241, txp =   40, typ =  260,
}
glyphs[244] = { --'Ù'--
  num = 244,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   16,
  txn =   49, tyn =  241, txp =   64, typ =  260,
}
glyphs[245] = { --'ı'--
  num = 245,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   16,
  txn =   73, tyn =  241, txp =   88, typ =  260,
}
glyphs[246] = { --'ˆ'--
  num = 246,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   16,
  txn =   97, tyn =  241, txp =  112, typ =  260,
}
glyphs[247] = { --'˜'--
  num = 247,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   12, oyp =   11,
  txn =  121, tyn =  241, txp =  135, typ =  255,
}
glyphs[248] = { --'¯'--
  num = 248,
  adv = 11,
  oxn =   -2, oyn =   -3, oxp =   13, oyp =   13,
  txn =  145, tyn =  241, txp =  160, typ =  257,
}
glyphs[249] = { --'˘'--
  num = 249,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   12, oyp =   16,
  txn =  169, tyn =  241, txp =  182, typ =  260,
}
glyphs[250] = { --'˙'--
  num = 250,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   12, oyp =   16,
  txn =  193, tyn =  241, txp =  206, typ =  260,
}
glyphs[251] = { --'˚'--
  num = 251,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   12, oyp =   16,
  txn =  217, tyn =  241, txp =  230, typ =  260,
}
glyphs[252] = { --'¸'--
  num = 252,
  adv = 11,
  oxn =   -1, oyn =   -3, oxp =   12, oyp =   16,
  txn =  241, tyn =  241, txp =  254, typ =  260,
}
glyphs[253] = { --'˝'--
  num = 253,
  adv = 10,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   16,
  txn =  265, tyn =  241, txp =  279, typ =  263,
}
glyphs[254] = { --'˛'--
  num = 254,
  adv = 11,
  oxn =   -1, oyn =   -6, oxp =   13, oyp =   16,
  txn =  289, tyn =  241, txp =  303, typ =  263,
}
glyphs[255] = { --'ˇ'--
  num = 255,
  adv = 10,
  oxn =   -2, oyn =   -6, oxp =   12, oyp =   16,
  txn =  313, tyn =  241, txp =  327, typ =  263,
}

fontSpecs.glyphs = glyphs

return fontSpecs

