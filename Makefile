BUILD_DIR=Build
TARGET_NAME=MonitoringDevice

test:
	swift test

all: build 

build:
	xcodebuild build \
		-scheme ${TARGET_NAME} \
		-configuration Release \
		-sdk iphoneos \
		-destination generic/platform=iOS \
		BITCODE_GENERATION_MODE=bitcode \
		OTHER_CFLAGS=-fembed-bitcode \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		CONFIGURATION_BUILD_DIR=${BUILD_DIR}
