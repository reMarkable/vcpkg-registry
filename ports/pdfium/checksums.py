_BASE_URL = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/{}/pdfium-{}.tgz"

_TARGETS = [
    "linux-x64",
    "mac-arm64",
    "mac-x64",
    "win-x86",
]

_VERSION = "5296"

import hashlib
import urllib.request

def compute_sha(url):
    response = urllib.request.urlopen(url)
    m = hashlib.sha512()
    m.update(response.read())
    return m.hexdigest()



if __name__ == '__main__':
    for target in _TARGETS:
        url = _BASE_URL.format(_VERSION, target)
        print("_download(\"{}\" {})".format(target, compute_sha(url)))
