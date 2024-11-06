{pkgs, ...}:
{
  home.packages = with pkgs; [
    ffmpeg # Converter for video to audio and things, is a dependency for a lot of things

    losslesscut-bin # Cut videos easier and faster
    kdenlive # Video Editor
    glaxnimate # Dependency for KDenLive

    handbrake # Turn video formats into other video formats (But with GUI)
  ];
}
