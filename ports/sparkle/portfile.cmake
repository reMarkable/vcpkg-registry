vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/sparkle-project/Sparkle/releases/download/1.25.0/Sparkle-1.25.0.tar.xz"
    FILENAME "sparkle-1.25.0.zip"
    SHA512 cd397fa38ae878e2f7b408ab469d699215fee59c77d759c4a5bf13d6d73e9c3d3bb538a4cc5791ac3690af4dc2c2bc1b1605602fef21eaaa705b8becaa0054ec
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
)

file(INSTALL "${SOURCE_PATH}/Sparkle.framework/Versions/Current/Headers" DESTINATION "${CURRENT_PACKAGES_DIR}/include" FOLLOW_SYMLINK_CHAIN RENAME "${PORT}")

# Including all three files was the only way I could get this application to work
# dyld[16457]: Library not loaded: '@rpath/Sparkle.framework/Versions/A/Sparkle'
# Referenced from: '/Users/macm1/repos/github/xochitl/build/mac/reMarkable.app/Contents/MacOS/reMarkable'
# Reason: tried: '/Users/macm1/repos/github/xochitl/build/mac/vcpkg_installed/arm64-osx/lib/Sparkle.framework/Versions/A/Sparkle' (no such file), ...
file(INSTALL "${SOURCE_PATH}/Sparkle.framework/Sparkle" DESTINATION "${CURRENT_PACKAGES_DIR}/lib" FOLLOW_SYMLINK_CHAIN)
file(INSTALL "${SOURCE_PATH}/Sparkle.framework/Versions/Current/Sparkle" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/Sparkle.framework/Versions/Current")
file(INSTALL "${SOURCE_PATH}/Sparkle.framework/Versions/A/Sparkle" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/Sparkle.framework/Versions/A")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
