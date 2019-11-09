# @date  Time-stamp: <2018-11-16 12:30:49 tagashira>

TARGET = test_dtw dtw_svm_utils

TAG_COMMAND = gtags
TAG_FILE = GPATH GRTAGS GTAGS

CXX = g++
CXXFLAGS += -std=c++11
# CXXFLAGS += -Wall -O3 -MMD -MP -std=c++11
# CXXFLAGS = -std=c++11 `pkg-config --cflags opencv`
# LDLIBS = `pkg-config --libs opencv`

# for gist
GIST_DIR = ./
GIST_OBJ = gist.o dtw-classifier.o standalone_image.o

CFLAGS += -I${GIST_DIR} -DUSE_GIST -DSTANDALONE_GIST
CXXFLAGS += -I${GIST_DIR}
LDLIBS += -lfftw3f

# for DTW
DTW_DIR = ./
DTW_OBJ = dtw.o

CFLAGS += -I${DTW_DIR} -DUSE_DTW
CXXFLAGS += -I${DTW_DIR}
LDLIBS += -lfftw3f

# for multi_camera
CXXFLAGS += -I${CAMERA_DIR} -I${PGR_CAMERA_DIR} -I${SHARED_MEMORY_DIR}
LDLIBS += -ldc1394

CAMERA_DIR = ./externals/multi_camera/
CAMERA_OBJ = camera.o

PGR_CAMERA_DIR = ${CAMERA_DIR}/externals/pgr_camera/
PGR_CAMERA_OBJ = cv1394.o

CV_FLYCAP_DIR = ${CAMERA_DIR}/externals/pgr_camera/
CV_FLYCAP_OBJ = cv_flycap.o
LDLIBS += -lflycapture
SHARED_MEMORY_DIR = ${CAMERA_DIR}/externals/shared_memory/
SHARED_MEMORY_OBJ = shared_memory_size.o

# for opencv
CXXFLAGS += `pkg-config --cflags opencv`
LDLIBS += `pkg-config --libs opencv` -L/usr/local/cuda/lib64/ -L/usr/local/share/OpenCV/3rdparty/lib/
# CXXFLAGS += -DOPENCV_2 # for opencv2 compatibility


all:	$(TARGET)

test_dtw:	test_dtw.o dtw.o
	${CXX} -o $@ $^ ${LDLIBS}

dtw_svm_utils:\
		dtw_svm_utils.o\
		${addprefix ${GIST_DIR}, ${GIST_OBJ}}\
		${addprefix ${DTW_DIR}, ${DTW_OBJ}}
	${CXX} -o $@ $^ ${LDLIBS}

tag:
	$(TAG_COMMAND) -vw

clean:
	$(RM) *.o *.d *~ \#* $(TARGET) $(TAG_FILE)

rebuild:\
	clean\
	all\
	tag


dist-clean:	clean
