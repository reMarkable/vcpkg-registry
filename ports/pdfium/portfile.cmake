set(CHROMIUM_VERSION 5296)

function(_download target sha)
    vcpkg_download_distfile(ARCHIVE
        URLS "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/${CHROMIUM_VERSION}/pdfium-${target}.tgz"
        FILENAME "pdfium-${target}.zip"
        SHA512 ${sha}
    )
    set(ARCHIVE ${ARCHIVE} PARENT_SCOPE)
endfunction()

if (VCPKG_TARGET_IS_LINUX)
    set(LIBRARY_FILE "libpdfium.so")
    
    _download("linux-x64" 3ef806bd17667f0f8aa355d597007d94c25868241a8fb467ba1540cc37e31a3f83e085fdc74dc57999467b585792c15090ffd619fd6ac0a7b52deeed3ac2ec51)

elseif(VCPKG_TARGET_IS_MINGW)
    set(LIBRARY_FILE "pdfium.dll.lib")
    set(LIBRARY_BIN_FILE "pdfium.dll")

    _download("win-x86" 13997e4875aac1a1cccfab8b8a211b320a258bc3ec7af7870c52ba6e7e039d3c27ee2547aea2c826e82539f39f93c6846dd19a4d75d481c67ecb31009f493bec)

elseif(VCPKG_TARGET_IS_OSX)
    set(LIBRARY_FILE "libpdfium.dylib")
    
    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        _download("mac-arm64" 88cd3a9da9fb954279ef9f12c9be766d310f3758e7eaf9232de114e6a2aef99301088c35c814f2ee0ef46a2baa9e43be035d36cb22c4f1fccea65621eb029c73)
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        _download("mac-x64" 7cbf1f35b3c82d513e272a7aa9eb6ef066e082ffde8a4033c02896150d69a858a76052b602bbcc96842762f135c11367084448912c6d8d7f5ddd341a8d638ada)
    else()
        message(FATAL_ERROR "Invalid VCPKG_TARGET_ARCHITECTURE combination: ${VCPKG_TARGET_ARCHITECTURE}-mac")
    endif()
else()

    message(FATAL_ERROR "Selected VCPKG_TARGET_OS is not supported.")

endif()

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    NO_REMOVE_ONE_LEVEL
)

# We need headers
file(INSTALL "${SOURCE_PATH}/include" DESTINATION "${CURRENT_PACKAGES_DIR}/include" RENAME ${PORT})

# Library file
file(INSTALL "${SOURCE_PATH}/lib/${LIBRARY_FILE}" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
file(INSTALL "${SOURCE_PATH}/lib/${LIBRARY_FILE}" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")

# DLL for windows
if(LIBRARY_BIN_FILE)
    file(INSTALL "${SOURCE_PATH}/bin/${LIBRARY_BIN_FILE}" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    file(INSTALL "${SOURCE_PATH}/bin/${LIBRARY_BIN_FILE}" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

# Metadata/extras
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(INSTALL "${SOURCE_PATH}/VERSION" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME version)
