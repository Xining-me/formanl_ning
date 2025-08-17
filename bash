# 在不覆盖 lib 与 pubspec 的情况下重建原生工程文件
flutter create .
flutter pub get
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
