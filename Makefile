all:
	c++ -DCYTHON_DMZ -DSCAN_EXPIRY -Icard.io-dmz -I/usr/local/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/include/python2.7/ `pkg-config --libs --cflags opencv` -shared card.io-dmz/dmz_all.cpp -o libdmz.so
	python setup.py build_ext --inplace
