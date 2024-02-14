#bin/sh

flutter build web --web-renderer canvaskit --base-href /Paraworld_gsf_viewer/
cp -rf build/web/* docs/