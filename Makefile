.PHONY: all clean

all: libdmz.so
	python setup.py build_ext --inplace

libdmz.so:
	c++ -DCYTHON_DMZ -DSCAN_EXPIRY -Idmz -I/usr/local/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/include/python2.7/ `pkg-config --libs --cflags opencv` -shared dmz/dmz_all.cpp -o libdmz.so

clean:
	rm -rf cardio.cpp cardio.so libdmz.so build
