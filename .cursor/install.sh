#!/usr/bin/env bash
# Idempotent setup for the Campus Event Finder Flutter app.
# Installs a pinned Flutter SDK (once) and refreshes project dependencies.
set -euo pipefail

FLUTTER_VERSION="3.47.4"
FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
FLUTTER_TARBALL_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

install_flutter() {
  echo "Installing Flutter ${FLUTTER_VERSION} to ${FLUTTER_DIR} ..."
  local tarball
  tarball="$(mktemp -t flutter-XXXXXX.tar.xz)"
  curl -fsSL -o "${tarball}" "${FLUTTER_TARBALL_URL}"
  rm -rf "${FLUTTER_DIR}"
  mkdir -p "$(dirname "${FLUTTER_DIR}")"
  tar -xf "${tarball}" -C "$(dirname "${FLUTTER_DIR}")"
  rm -f "${tarball}"
}

# Only (re)install when the pinned version is not already present.
if [ -x "${FLUTTER_DIR}/bin/flutter" ] \
   && "${FLUTTER_DIR}/bin/flutter" --version 2>/dev/null | grep -q "Flutter ${FLUTTER_VERSION}"; then
  echo "Flutter ${FLUTTER_VERSION} already installed at ${FLUTTER_DIR}."
else
  install_flutter
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"

# Flutter runs git against its own SDK checkout; mark it safe for any user.
git config --global --add safe.directory "${FLUTTER_DIR}" || true

flutter --version
flutter config --enable-web --no-analytics >/dev/null

# Fetch/refresh project dependencies.
flutter pub get

echo "Environment ready. Run the app with:"
echo "  ${FLUTTER_DIR}/bin/flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0"
