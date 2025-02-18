GET_FILENAME_COMPONENT(SUBDIRNAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

IF( DEFINED SPECIFIC_PROJECTNAME )
	# this is for ambix_decoder (which shares the code of ambix_binaural)
	SET (SUBPROJECT_NAME ${SPECIFIC_PROJECTNAME}${NUM_CHANNELS})
ELSE( DEFINED SPECIFIC_PROJECTNAME )
	# this is the normal way...
	SET (SUBPROJECT_NAME ${SUBDIRNAME}${NUM_CHANNELS})
ENDIF(DEFINED SPECIFIC_PROJECTNAME )

#############################
# add all c, cpp, cc files from the Source directory
FILE ( GLOB_RECURSE SOURCE Source/*.c* )
FILE ( GLOB_RECURSE HEADER Source/*.h* )

IF(DEFINED SPECIFIC_SOURE_DIR)
	FILE ( GLOB_RECURSE SOURCE ${SPECIFIC_SOURE_DIR}/Source/*.c* )
	FILE ( GLOB_RECURSE HEADER ${SPECIFIC_SOURE_DIR}/Source/*.h* )
ENDIF(DEFINED SPECIFIC_SOURE_DIR)

if (BUILD_STANDALONE)
	list(APPEND SOURCE ${SRC_DIR}/standalone-filter/Main.cpp)
	list(APPEND HEADER ${SRC_DIR}/standalone-filter/CustomStandaloneFilterWindow.h)
endif(BUILD_STANDALONE)

#SORT IT
LIST ( SORT SOURCE )

juce_add_plugin (${SUBPROJECT_NAME}
    PLUGIN_MANUFACTURER_CODE Kron
    PLUGIN_CODE ${PLUGIN_CODE}
    COMPANY_NAME "kronlachner"
    PRODUCT_NAME ${SUBPROJECT_NAME}
    FORMATS ${MCFX_FORMATS}
    VERSION ${VERSION}
    LV2URI http://www.matthiaskronlachner.com/${SUBPROJECT_NAME})

juce_generate_juce_header(${SUBPROJECT_NAME})

target_sources (${SUBPROJECT_NAME} PRIVATE
    ${SOURCE}
    ${HEADER}
    )

set(CHANNEL_CONFIG "\{${NUM_CHANNELS}, ${NUM_CHANNELS}\}")

target_compile_definitions (${SUBPROJECT_NAME} PRIVATE
    JUCE_USE_CURL=0
    JUCE_WEB_BROWSER=0
    JUCE_USE_CUSTOM_PLUGIN_STANDALONE_APP=1
    JUCE_USE_FLAC=0
    JUCE_USE_OGGVORBIS=0
    JUCE_USE_MP3AUDIOFORMAT=0
    JUCE_USE_LAME_AUDIO_FORMAT=0
    JUCE_USE_WINDOWS_MEDIA_FORMAT=0
    JUCE_DISPLAY_SPLASH_SCREEN=0
    JUCE_VST3_CAN_REPLACE_VST2=0
    JucePlugin_PreferredChannelConfigurations=${CHANNEL_CONFIG})

target_link_libraries (${SUBPROJECT_NAME} PRIVATE
    juce::juce_audio_utils
    juce::juce_audio_plugin_client
    juce::juce_osc
    juce::juce_dsp
    juce::juce_opengl
    juce::juce_recommended_config_flags
    juce::juce_recommended_lto_flags
    #juce::juce_recommended_warning_flags
	)

#IF(WITH_FFTW3)
#	target_link_libraries (${SUBPROJECT_NAME} PRIVATE
#		${FFTW3F_LIBRARY}
#		${FFTW3F_THREADS_LIBRARY}
#	)
#ENDIF(WITH_FFTW3)
