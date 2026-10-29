// =======================================================================
// 🎬 TECHNITIX MEDIA CONFIGURATION (இங்கே உங்கள் File Path-ஐ Paste செய்யவும்)
// =======================================================================
// நீங்கள் உங்கள் Video மற்றும் Audio file-ன் Copy Path எடுத்து கீழே உள்ள
// " " -க்குள் Paste செய்தால், வெப்சைட்டில் தானாகவே Play ஆகும்!
//
// எ.கா:
//   Local : "D:/Videos/my_video.mp4"
//   Media : "media/sample_video.mp4"
// =======================================================================

var TECHNITIX_MEDIA = {
  // 🎥 1. VIDEO FILE PATH (வீடியோ கோப்பு அல்லது YouTube Link):
  //   - Local Video : "D:/Videos/my_video.mp4"
  //   - YouTube Link: "https://www.youtube.com/watch?v=..."
  video: "D:\Videos\vidssave.com KALYANI (with Shreya Ghoshal) OFFICIAL MUSIC VIDEO _ ARJN _ KDS _ FIFTY4 _ RONN _ SHREYA GHOSHAL _ 1080P.mp4",

  // 🔊 2. AUDIO FILE PATH (ஆடியோ கோப்பு):
  audio: ""
};

if (typeof window !== 'undefined') {
  window.TECHNITIX_MEDIA = TECHNITIX_MEDIA;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = TECHNITIX_MEDIA;
}
