class VideoPreviewData {
  const VideoPreviewData(this.image, this.aspectRatio, this.duration);
  final String image;
  final double aspectRatio;
  final Duration duration;
}

const videoPreviews = <String, VideoPreviewData>{
  'assets/videos/disminucion_movimientos_fetales.mp4': VideoPreviewData(
      'assets/video_thumbnails/disminucion_movimientos_fetales.jpg',
      1.76795580,
      Duration(milliseconds: 90710)),
  'assets/videos/dolor_cabeza_zumbidos.mp4': VideoPreviewData(
      'assets/video_thumbnails/dolor_cabeza_zumbidos.jpg',
      0.56239016,
      Duration(milliseconds: 44040)),
  'assets/videos/nauseas_vomitos.mp4': VideoPreviewData(
      'assets/video_thumbnails/nauseas_vomitos.jpg',
      0.56239016,
      Duration(milliseconds: 60560)),
  'assets/videos/perdida_liquido_amniotico.mp4': VideoPreviewData(
      'assets/video_thumbnails/perdida_liquido_amniotico.jpg',
      1.82857143,
      Duration(milliseconds: 66850)),
  'assets/videos/sangrado_vaginal.mp4': VideoPreviewData(
      'assets/video_thumbnails/sangrado_vaginal.jpg',
      0.56042032,
      Duration(milliseconds: 67340)),
};
