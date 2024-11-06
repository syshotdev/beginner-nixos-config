{pkgs, ...}:
{
  home.packages = with pkgs; [
    ffmpeg # Converter for video to audio and things, is a dependency for a lot of things

    obs-studio # Most used video recorder
    audacity # Audio editing, recording, very useful in some situations
  ];
}
