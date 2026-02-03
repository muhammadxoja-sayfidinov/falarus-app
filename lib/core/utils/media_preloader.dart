import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../features/courses/data/course_model.dart';
import '../../features/exam/data/question_repository.dart';

class MediaPreloader {
  final QuestionRepository _repository;
  final DefaultCacheManager _cacheManager;

  MediaPreloader({
    QuestionRepository? repository,
    DefaultCacheManager? cacheManager,
  }) : _repository = repository ?? QuestionRepository(),
       _cacheManager = cacheManager ?? DefaultCacheManager();

  /// Preloads all images associated with questions.
  /// Returns a stream of progress (0.0 to 1.0).
  Stream<double> preloadAll() async* {
    List<Question> allQuestions;
    try {
      allQuestions = await _repository.fetchAllQuestions();
    } catch (e) {
      debugPrint("Error fetching questions for preload: $e");
      yield 1.0; // Fail gracefully by saying "done"
      return;
    }

    if (allQuestions.isEmpty) {
      yield 1.0;
      return;
    }

    final Set<String> urlsToDownload = {};

    for (var q in allQuestions) {
      // 1. Question Image
      if (q.type == QuestionType.image && q.mediaUrl != null) {
        if (_isRemoteUrl(q.mediaUrl!)) {
          urlsToDownload.add(q.mediaUrl!);
        }
      }

      // 2. Option Images (filenames acting as keys)
      for (var subQ in q.subQuestions) {
        for (var opt in subQ.options) {
          if (_isImageFilename(opt)) {
            try {
              // We don't have the direct URL for options usually, we fetch them via storage ref.
              // To cache them efficiently with CachedNetworkImage later, we need their download URLs.
              // However, resolving ALL option URLs might be slow.
              // Strategy: We will just try to resolve and cache the ones we can finding.
              // Ideally, we would need the URL to pre-cache it for CachedNetworkImage.
              // Optimization: We will resolve them in parallel batches.
            } catch (e) {
              // ignore
            }
          }
        }
      }
    }

    // Since resolving 1000+ storage refs for options is heavy, let's focus on `mediaUrl` first
    // effectively, and maybe optimize options later or resolve them.
    // Actually, let's try to resolve option URLs too, but we need to know their full path.
    // In QuestionWidget, we check 'foto_questions/$filename' then 'filename'.

    // Let's gather all Futures to resolve option URLs for caching.

    // Collecting ALL download tasks
    // Since we need the *URL* to put into the cache so that CachedNetworkImage finds it by URL key.

    final List<Future<String?>> urlResolvers = [];

    // Add existing http URLs
    for (var url in urlsToDownload) {
      urlResolvers.add(Future.value(url));
    }

    // Add Option filenames to resolve
    for (var q in allQuestions) {
      for (var subQ in q.subQuestions) {
        for (var opt in subQ.options) {
          if (_isImageFilename(opt)) {
            urlResolvers.add(_resolveOptionUrl(opt));
          }
        }
      }
    }

    // int total = urlResolvers.length;
    // int completed = 0;

    // Process in batches to avoid rate limits? Firestore/Storage is usually fine.
    // But waiting for 1000 futures might be too much.
    // Better way: process them, and as they resolve, download.

    // Given the potentially large number, we should just preload the MAIN question media for now
    // and maybe the visible options.

    // Let's try to do it all but report progress effectively.

    List<String> finalUrls = [];

    // Resolve URLs first (lightweight metadata fetch)
    // We'll stick to a simpler approach: Parallelize resolving.

    // Batch resolution to avoid stack issues
    const batchSize = 20;
    for (var i = 0; i < urlResolvers.length; i += batchSize) {
      var end = (i + batchSize < urlResolvers.length)
          ? i + batchSize
          : urlResolvers.length;
      var batch = urlResolvers.sublist(i, end);

      var results = await Future.wait(batch);
      for (var url in results) {
        if (url != null) finalUrls.add(url);
      }

      // Update progress for "Resolution phase" (say first 20%)
      double progress = (end / urlResolvers.length) * 0.2;
      yield progress;
    }

    // Now download phase (remaining 80%)
    if (finalUrls.isEmpty) {
      yield 1.0;
      return;
    }

    int downloadTotal = finalUrls.length;
    int downloadCompleted = 0;

    // Download 5 at a time
    const downloadBatchSize = 10;
    for (var i = 0; i < finalUrls.length; i += downloadBatchSize) {
      var end = (i + downloadBatchSize < finalUrls.length)
          ? i + downloadBatchSize
          : finalUrls.length;
      var batchUrls = finalUrls.sublist(i, end);

      var tasks = batchUrls.map((url) => _cacheManager.downloadFile(url));

      // Await batch
      await Future.wait(tasks.map((f) => f.then((_) {}, onError: (_) {})));

      downloadCompleted += batchUrls.length;

      // Calculate total progress: 0.2 + (completed/total * 0.8)
      double progress = 0.2 + ((downloadCompleted / downloadTotal) * 0.8);
      yield progress;
    }

    yield 1.0;
  }

  Future<String?> _resolveOptionUrl(String filename) async {
    try {
      // Try foto_questions first
      return await FirebaseStorage.instance
          .ref('foto_questions/$filename')
          .getDownloadURL();
    } catch (e) {
      try {
        // Try root
        return await FirebaseStorage.instance.ref(filename).getDownloadURL();
      } catch (_) {
        return null;
      }
    }
  }

  bool _isRemoteUrl(String url) {
    return url.startsWith('http');
  }

  bool _isImageFilename(String text) {
    final lower = text.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.jpeg');
  }
}
