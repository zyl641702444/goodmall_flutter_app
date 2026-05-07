#!/bin/bash
set +e
source /etc/profile.d/goodmall_git.sh 2>/dev/null || true
source /etc/profile.d/goodmall_flutter_android.sh 2>/dev/null || true
cd /www/wwwroot/khmail/native-workspace/goodmall_flutter_app || exit 1
git -c color.ui=false --version
flutter doctor -v
flutter pub get
flutter analyze
flutter build apk --debug
ls -lh build/app/outputs/flutter-apk/
