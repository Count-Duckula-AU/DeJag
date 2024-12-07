# DeJag
Patches a 64x64 Pixel 24-bit .bmp into the Jaguar BIOS  


## Usage:
-Create one or more 64x64 pixel, 24-bit bmp images. Save into the '\BMP' subfolder of the script's location  
-Run DeJag.ps1  
-The patched BIOS file(s) will be saved as '\Patched BIOS\boot-<BMP_NAME>.rom'


- The following files must be in the same folder as the script:  
  - '[BIOS] Atari Jaguar (World).j64' (MD5: BCFE348C565D9DEDB173822EE6850DEA)  
  - 'bmp_cry_nodither.exe'  
  - 'introorg.img'  
  - 'introptf.exe'  


## Tools:
- introptf.exe by Matthias Domin: http://mdgames.de/jag_eng.htm  
- bmp_cry_nodither.exe by Zerosquare: www.jagware.org/index.php?/topic/259-jaguar-image-converter/page/2/#comment-12881 (http://web.archive.org/web/20230206122916/http://www.jagware.org/applications/core/interface/file/attachment.php?id=929)
