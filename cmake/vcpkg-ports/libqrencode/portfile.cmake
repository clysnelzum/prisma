vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO fukuchi/libqrencode
    REF 715e29fd4cd71b6e452ae0f4e36d917b43122ce8 # v4.1.1
    SHA512 78a5464c6fd37d2b4ed6d81c5faf8d95f6f1c95bfdb55dfe89fc227cd487c1685e8080694b1c93128364337959562ea133b3bb332ae1c5a4094614b493611e9f
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DWITH_TOOLS=OFF
        -DWITHOUT_PNG=ON
        -DWITH_TESTS=OFF
        -DWITH_TEST=NO
        -DCMAKE_DISABLE_FIND_PACKAGE_PNG=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_Iconv=TRUE
        -DSKIP_INSTALL_PROGRAMS=ON
        -DSKIP_INSTALL_EXECUTABLES=ON
        -DSKIP_INSTALL_FILES=ON
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
        -DWITH_TOOLS=NO
)

vcpkg_cmake_install()

if(VCPKG_TARGET_IS_WINDOWS)
    set(EXECUTABLE_SUFFIX ".exe")
else()
    set(EXECUTABLE_SUFFIX "")
endif()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/qrencode.dll")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/bin")
    file(RENAME "${CURRENT_PACKAGES_DIR}/lib/qrencode.dll" "${CURRENT_PACKAGES_DIR}/bin/qrencode.dll")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/qrencoded.dll")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/debug/bin")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/qrencoded.dll" "${CURRENT_PACKAGES_DIR}/debug/bin/qrencoded.dll")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
