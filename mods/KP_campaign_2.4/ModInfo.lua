return
{
	-- The name is shown in the selection interface
	game='KPC',
	shortGame='KPC',
	name='Kernel Panic Campaign 2.4',
	shortName='KPC',
	mutator='official',
	version='2.4',
	-- These can be shown by the selection interface
	description='A Campaing for Kernel Panic where Prog&Play API is used to command units.',
	url='http://www.irit.fr/ProgAndPlay/index_en.php',
	-- What kind of mod this is 
	--  0 - Hidden (support mod that can't be selected, such as OTA_textures) 
	--  1 - Normal, only one can be selected at a time 
	--  2 - Addon, any number of these can be selected. Could be used 
	--      for single units for example. 
	--  others - perhaps mutators and addon races that can be 
	--           enabled in addition to xta for example? 
	modtype=1,
	-- other archives this one depends on
	depend= {
		"Kernel Panic 4.1",
		--"Balanced Annihilation V7.50",
		"Marble_Madness_Map",
		--"SmallDivide"
		--do not used filenames, use the internal name, or downloader programs will fail to download the dependencies automatically
		},
}